/// Schermata principale dell'app che mostra la lista dei task.
///
/// Permette all'utente di:
/// - Visualizzare tutti i task
/// - Aggiungere un nuovo task
/// - Completare/decompletare task
/// - Filtrare task (tutti, attivi, completati)
library;

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:ui_components/ui_components.dart';

/// Enum per i filtri dei task.
enum TaskFilter {
  all,
  active,
  completed,
}

/// Schermata principale con lista task.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista dei task (in un'app reale verrebbe da uno state management)
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Implementare UI components',
      description: 'Creare widget riusabili per il progetto',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isCompleted: true,
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Configurare Melos',
      description: 'Setup del monorepo con Melos',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Task(
      id: '3',
      title: 'Scrivere documentazione',
      description: 'README completo con istruzioni',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  TaskFilter _currentFilter = TaskFilter.all;

  /// Restituisce i task filtrati in base al filtro corrente.
  List<Task> get _filteredTasks {
    switch (_currentFilter) {
      case TaskFilter.all:
        return _tasks;
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
    }
  }

  /// Aggiunge un nuovo task.
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => _AddTaskDialog(
        onAdd: (title, description) {
          setState(() {
            _tasks.add(
              Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                description: description.isNotEmpty ? description : null,
                createdAt: DateTime.now(),
              ),
            );
          });
        },
      ),
    );
  }

  /// Toggle dello stato completato di un task.
  void _toggleTaskComplete(Task task, bool isCompleted) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = isCompleted ? task.complete() : task.uncomplete();
      }
    });
  }

  /// Mostra i dettagli di un task.
  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => _TaskDetailsDialog(task: task),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('I Miei Task'),
        actions: [
          PopupMenuButton<TaskFilter>(
            onSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: TaskFilter.all,
                child: Text('Tutti'),
              ),
              const PopupMenuItem(
                value: TaskFilter.active,
                child: Text('Attivi'),
              ),
              const PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completati'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getFilterLabel(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    onTap: () => _showTaskDetails(task),
                    onToggleComplete: (isCompleted) =>
                        _toggleTaskComplete(task, isCompleted),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Nuovo Task'),
      ),
    );
  }

  /// Widget per lo stato vuoto.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun task ${_getFilterLabel().toLowerCase()}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Aggiungi un nuovo task per iniziare',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  /// Restituisce la label del filtro corrente.
  String _getFilterLabel() {
    switch (_currentFilter) {
      case TaskFilter.all:
        return 'Tutti';
      case TaskFilter.active:
        return 'Attivi';
      case TaskFilter.completed:
        return 'Completati';
    }
  }
}

/// Dialog per aggiungere un nuovo task.
class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog({required this.onAdd});

  final void Function(String title, String description) onAdd;

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(
        _titleController.text,
        _descriptionController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuovo Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titolo',
                hintText: 'Inserisci il titolo del task',
              ),
              validator: (value) =>
                  Validators.validateRequired(value, fieldName: 'Titolo'),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione (opzionale)',
                hintText: 'Aggiungi una descrizione',
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Aggiungi'),
        ),
      ],
    );
  }
}

/// Dialog con i dettagli di un task.
class _TaskDetailsDialog extends StatelessWidget {
  const _TaskDetailsDialog({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(task.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description != null) ...[
            Text(
              'Descrizione',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(task.description!),
            const SizedBox(height: 16),
          ],
          Text(
            'Creato',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(DateFormatter.formatDateTime(task.createdAt)),
          if (task.isCompleted && task.completedAt != null) ...[
            const SizedBox(height: 16),
            Text(
              'Completato',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(DateFormatter.formatDateTime(task.completedAt!)),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? theme.colorScheme.primary : null,
              ),
              const SizedBox(width: 8),
              Text(
                task.isCompleted ? 'Completato' : 'Da fare',
                style: TextStyle(
                  color: task.isCompleted ? theme.colorScheme.primary : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Chiudi'),
        ),
      ],
    );
  }
}
