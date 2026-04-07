/// Schermata di dettaglio di un singolo task.
/// 
/// Mostra tutte le informazioni complete del task:
/// - Titolo
/// - Descrizione completa
/// - Stato di completamento
/// - Priorità
/// - Data di creazione
/// 
/// Azioni disponibili:
/// - Modifica del task (naviga a TaskFormScreen)
/// - Eliminazione del task (con conferma)
/// - Toggle dello stato di completamento
/// - Condivisione del task (simulata)
/// 
/// Utilizza Navigator.pop per tornare indietro con un risultato.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/route_arguments.dart';
import '../routes.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // In un'app reale, questi dati verrebbero caricati da un database o provider
  late Task _task;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  /// Simula il caricamento del task dal database.
  /// In un'app reale, questo sarebbe un accesso asincrono a un database o API.
  Future<void> _loadTask() async {
    // Simula un ritardo di rete
    await Future.delayed(const Duration(milliseconds: 500));

    // Task di esempio - in realtà dovrebbe essere recuperato dal database
    setState(() {
      _task = Task(
        id: widget.taskId,
        title: 'Task di Esempio',
        description:
            'Questa è una descrizione dettagliata del task. In un\'applicazione reale, questi dati verrebbero recuperati da un database o da un provider di stato.',
        priority: TaskPriority.high,
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      _isLoading = false;
    });
  }

  /// Toggle dello stato di completamento del task.
  void _toggleComplete() {
    setState(() {
      _task = _task.copyWith(isCompleted: !_task.isCompleted);
    });

    // Mostra un feedback all'utente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _task.isCompleted ? 'Task completato!' : 'Task segnato come da completare',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: _toggleComplete, // Annulla l'azione
        ),
      ),
    );
  }

  /// Naviga alla schermata di modifica del task.
  /// Utilizza Navigator.pushNamed con pushReplacement se necessario.
  void _editTask() {
    Navigator.pushNamed(
      context,
      AppRoutes.taskForm,
      arguments: TaskFormArguments.edit(_task),
    ).then((result) {
      // Se il task è stato modificato, aggiorna i dati
      if (result != null && result is Task) {
        setState(() {
          _task = result;
        });
      }
    });
  }

  /// Elimina il task con richiesta di conferma.
  /// Utilizza Navigator.pop con un risultato per comunicare l'eliminazione.
  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma Eliminazione'),
        content: const Text(
          'Sei sicuro di voler eliminare questo task? '
          'Questa azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Chiude il dialog
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Chiude il dialog
              // Torna alla home con un flag che indica l'eliminazione
              Navigator.pop(context, 'deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  /// Simula la condivisione del task.
  void _shareTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Condivisione di "${_task.title}"...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Utilizza WillPopScope per intercettare il back button.
  /// Restituisce un risultato alla schermata precedente.
  Future<bool> _onWillPop() async {
    // Torna indietro passando true per indicare che potrebbero esserci modifiche
    Navigator.pop(context, true);
    return false; // Previene il pop automatico
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Caricamento...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dettagli Task'),
          actions: [
            // Pulsante condividi
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Condividi',
              onPressed: _shareTask,
            ),
            // Pulsante modifica
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Modifica',
              onPressed: _editTask,
            ),
            // Menu con altre azioni
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteTask();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Elimina', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con stato e priorità
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titolo
                    Text(
                      _task.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Badge stato e priorità
                    Row(
                      children: [
                        _buildStatusChip(),
                        const SizedBox(width: 12),
                        _buildPriorityChip(),
                      ],
                    ),
                  ],
                ),
              ),

              // Sezione descrizione
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descrizione',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _task.description.isEmpty
                          ? 'Nessuna descrizione disponibile.'
                          : _task.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: _task.description.isEmpty
                            ? Colors.grey
                            : Colors.black87,
                        fontStyle: _task.description.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // Sezione informazioni
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informazioni',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Creato il',
                      DateFormat('dd/MM/yyyy HH:mm').format(_task.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.fingerprint,
                      'ID',
                      _task.id,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Pulsante floating per toggle completamento
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _toggleComplete,
          icon: Icon(_task.isCompleted ? Icons.undo : Icons.check),
          label: Text(_task.isCompleted ? 'Segna come da fare' : 'Completa'),
          backgroundColor:
              _task.isCompleted ? Colors.orange : Colors.green,
        ),
      ),
    );
  }

  /// Widget per mostrare il chip dello stato.
  Widget _buildStatusChip() {
    return Chip(
      avatar: Icon(
        _task.isCompleted ? Icons.check_circle : Icons.pending,
        color: _task.isCompleted ? Colors.green : Colors.orange,
        size: 20,
      ),
      label: Text(
        _task.isCompleted ? 'Completato' : 'Da completare',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor:
          (_task.isCompleted ? Colors.green : Colors.orange).withOpacity(0.1),
    );
  }

  /// Widget per mostrare il chip della priorità.
  Widget _buildPriorityChip() {
    Color color;
    switch (_task.priority) {
      case TaskPriority.low:
        color = Colors.green;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.high:
        color = Colors.red;
        break;
    }

    return Chip(
      avatar: Icon(
        Icons.priority_high,
        color: color,
        size: 20,
      ),
      label: Text(
        'Priorità ${_task.priority.displayName}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  /// Widget per mostrare una riga di informazioni.
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
