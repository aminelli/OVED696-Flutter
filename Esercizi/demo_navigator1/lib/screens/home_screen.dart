/// Schermata principale dell'applicazione che mostra la lista dei task.
/// 
/// Funzionalità:
/// - Visualizza tutti i task in una lista scrollabile
/// - Permette di filtrare i task (tutti, completati, da completare)
/// - Permette di ordinare i task (per data, priorità)
/// - Navigazione verso il dettaglio di un task
/// - Navigazione verso la creazione di un nuovo task
/// - Navigazione verso le impostazioni
/// 
/// Utilizza Navigator 1.0 con push e pop per la navigazione.

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/route_arguments.dart';
import '../routes.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista di task di esempio (in un'app reale useremmo un provider o un database)
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Completare il progetto Flutter',
      description: 'Implementare Navigator 1.0 con tutte le best practices',
      priority: TaskPriority.high,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Task(
      id: '2',
      title: 'Leggere documentazione Flutter',
      description: 'Studiare la navigazione e il routing in Flutter',
      priority: TaskPriority.medium,
      isCompleted: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Task(
      id: '3',
      title: 'Fare la spesa',
      description: 'Comprare latte, pane e uova',
      priority: TaskPriority.low,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Task(
      id: '4',
      title: 'Chiamare il dentista',
      description: 'Prenotare una visita di controllo',
      priority: TaskPriority.high,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Filtro corrente per i task
  TaskFilter _currentFilter = TaskFilter.all;

  // Ordinamento corrente per i task
  TaskSort _currentSort = TaskSort.byDate;

  /// Restituisce la lista di task filtrata e ordinata.
  List<Task> get _filteredAndSortedTasks {
    // Applica il filtro
    List<Task> filtered;
    switch (_currentFilter) {
      case TaskFilter.all:
        filtered = _tasks;
        break;
      case TaskFilter.completed:
        filtered = _tasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filtered = _tasks.where((task) => !task.isCompleted).toList();
        break;
    }

    // Applica l'ordinamento
    switch (_currentSort) {
      case TaskSort.byDate:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.byPriority:
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
    }

    return filtered;
  }

  /// Toggle dello stato di completamento di un task.
  void _toggleTaskComplete(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      }
    });
  }

  /// Naviga alla schermata di dettaglio del task.
  /// Utilizza Navigator.pushNamed con argomenti tipizzati.
  void _navigateToTaskDetail(Task task) {
    Navigator.pushNamed(
      context,
      AppRoutes.taskDetail,
      arguments: TaskDetailArguments(taskId: task.id),
    ).then((result) {
      // Callback eseguito quando si torna da taskDetail
      // Qui potremmo aggiornare i dati se necessario
      if (result != null && result is bool && result) {
        // Il task è stato modificato, aggiorna la UI
        setState(() {});
      }
    });
  }

  /// Naviga alla schermata di creazione nuovo task.
  void _navigateToCreateTask() {
    Navigator.pushNamed(
      context,
      AppRoutes.taskForm,
      arguments: TaskFormArguments.create(),
    ).then((result) {
      // Se un task è stato creato, lo aggiungiamo alla lista
      if (result != null && result is Task) {
        setState(() {
          _tasks.add(result);
        });
      }
    });
  }

  /// Naviga alla schermata delle impostazioni.
  void _navigateToSettings() {
    Navigator.pushNamed(context, AppRoutes.settings);
  }

  /// Mostra il menu per cambiare il filtro.
  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtra task',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Tutti i task'),
              trailing: _currentFilter == TaskFilter.all
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _currentFilter = TaskFilter.all);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Completati'),
              trailing: _currentFilter == TaskFilter.completed
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _currentFilter = TaskFilter.completed);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.radio_button_unchecked),
              title: const Text('Da completare'),
              trailing: _currentFilter == TaskFilter.pending
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _currentFilter = TaskFilter.pending);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Mostra il menu per cambiare l'ordinamento.
  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ordina task',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Per data'),
              trailing: _currentSort == TaskSort.byDate
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _currentSort = TaskSort.byDate);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.priority_high),
              title: const Text('Per priorità'),
              trailing: _currentSort == TaskSort.byPriority
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _currentSort = TaskSort.byPriority);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredAndSortedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('I Miei Task'),
        actions: [
          // Pulsante filtro
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtra',
            onPressed: _showFilterMenu,
          ),
          // Pulsante ordinamento
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordina',
            onPressed: _showSortMenu,
          ),
          // Pulsante impostazioni
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Impostazioni',
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? EmptyState(
              message: _currentFilter == TaskFilter.all
                  ? 'Nessun task presente.\nCrea il tuo primo task!'
                  : 'Nessun task ${_currentFilter == TaskFilter.completed ? "completato" : "da completare"}',
              icon: _currentFilter == TaskFilter.all
                  ? Icons.task_outlined
                  : Icons.inbox_outlined,
              actionLabel: _currentFilter == TaskFilter.all ? 'Crea Task' : null,
              onAction:
                  _currentFilter == TaskFilter.all ? _navigateToCreateTask : null,
            )
          : Column(
              children: [
                // Contatore task
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Totali',
                        _tasks.length.toString(),
                        Icons.list,
                      ),
                      _buildStatItem(
                        'Completati',
                        _tasks.where((t) => t.isCompleted).length.toString(),
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        'Da fare',
                        _tasks.where((t) => !t.isCompleted).length.toString(),
                        Icons.pending,
                      ),
                    ],
                  ),
                ),
                // Lista task
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        task: task,
                        onToggleComplete: (_) => _toggleTaskComplete(task),
                        onTap: () => _navigateToTaskDetail(task),
                      );
                    },
                  ),
                ),
              ],
            ),
      // Floating Action Button per creare un nuovo task
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateTask,
        icon: const Icon(Icons.add),
        label: const Text('Nuovo Task'),
      ),
    );
  }

  /// Widget per mostrare una statistica.
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

}

/// Enum per i filtri disponibili sui task.
enum TaskFilter {
  all,       // Tutti i task
  completed, // Solo task completati
  pending,   // Solo task da completare
}

/// Enum per gli ordinamenti disponibili sui task.
enum TaskSort {
  byDate,     // Ordina per data di creazione
  byPriority, // Ordina per priorità
}
