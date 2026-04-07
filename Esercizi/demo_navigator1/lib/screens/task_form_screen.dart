/// Schermata per creare o modificare un task.
/// 
/// Funzionalità:
/// - Form con validazione per titolo, descrizione e priorità
/// - Modalità creazione (task == null)
/// - Modalità modifica (task != null)
/// - Validazione input con messaggi di errore
/// - Salvataggio con feedback visivo
/// - Utilizzo di WillPopScope per confermare l'uscita se ci sono modifiche non salvate
/// 
/// Utilizza Navigator.pop con il task creato/modificato come risultato.

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/route_arguments.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskFormArguments? arguments;

  const TaskFormScreen({
    super.key,
    this.arguments,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  // Chiave per il form per la validazione
  final _formKey = GlobalKey<FormState>();

  // Controllers per i campi di testo
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  // Priorità selezionata
  late TaskPriority _selectedPriority;

  // Flag per tracciare se ci sono modifiche non salvate
  bool _hasUnsavedChanges = false;

  // Indica se siamo in modalità modifica o creazione
  bool get _isEditing => widget.arguments?.isEditing ?? false;

  @override
  void initState() {
    super.initState();

    // Inizializza i controller con i dati del task se in modifica
    final task = widget.arguments?.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _selectedPriority = task?.priority ?? TaskPriority.medium;

    // Aggiungi listener per tracciare le modifiche
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Chiamato quando un campo del form viene modificato.
  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  /// Valida e salva il task.
  void _saveTask() {
    // Valida il form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Crea il task (nuovo o modificato)
    final task = Task(
      id: widget.arguments?.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority,
      isCompleted: widget.arguments?.task?.isCompleted ?? false,
      createdAt: widget.arguments?.task?.createdAt ?? DateTime.now(),
    );

    // Mostra un feedback di successo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing ? 'Task modificato con successo!' : 'Task creato con successo!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Torna indietro passando il task salvato
    Navigator.pop(context, task);
  }

  /// Gestisce il back button con conferma se ci sono modifiche non salvate.
  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) {
      return true; // Permette di tornare indietro
    }

    // Mostra dialog di conferma
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifiche non salvate'),
        content: const Text(
          'Hai modifiche non salvate. Sei sicuro di voler uscire?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Esci senza salvare'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Modifica Task' : 'Nuovo Task'),
          actions: [
            // Pulsante salva nella AppBar
            TextButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Salva',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Campo titolo
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titolo *',
                  hintText: 'Inserisci il titolo del task',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Il titolo è obbligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'Il titolo deve contenere almeno 3 caratteri';
                  }
                  if (value.trim().length > 100) {
                    return 'Il titolo non può superare 100 caratteri';
                  }
                  return null;
                },
                maxLength: 100,
              ),

              const SizedBox(height: 24),

              // Campo descrizione
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrizione',
                  hintText: 'Inserisci una descrizione dettagliata (opzionale)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 5,
                maxLength: 500,
                validator: (value) {
                  if (value != null && value.trim().length > 500) {
                    return 'La descrizione non può superare 500 caratteri';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Selezione priorità
              const Text(
                'Priorità *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Radio buttons per la priorità
              ...TaskPriority.values.map((priority) {
                return RadioListTile<TaskPriority>(
                  title: Text(priority.displayName),
                  subtitle: Text(_getPriorityDescription(priority)),
                  value: priority,
                  groupValue: _selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                      _onFieldChanged();
                    });
                  },
                  secondary: Icon(
                    _getPriorityIcon(priority),
                    color: _getPriorityColor(priority),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Info card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I campi contrassegnati con * sono obbligatori',
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Floating Action Button per salvare
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveTask,
          icon: const Icon(Icons.save),
          label: const Text('Salva Task'),
        ),
      ),
    );
  }

  /// Restituisce la descrizione della priorità.
  String _getPriorityDescription(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Task non urgente, può essere fatto quando c\'è tempo';
      case TaskPriority.medium:
        return 'Task di routine, priorità normale';
      case TaskPriority.high:
        return 'Task urgente, deve essere completato al più presto';
    }
  }

  /// Restituisce l'icona della priorità.
  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }

  /// Restituisce il colore della priorità.
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }
}
