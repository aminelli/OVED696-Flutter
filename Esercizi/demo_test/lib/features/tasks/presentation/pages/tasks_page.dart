/// File: tasks_page.dart
/// 
/// Schermata principale per la visualizzazione e gestione dei task.
/// Mostra la lista dei task e permette di crearli, modificarli ed eliminarli.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_test/features/tasks/presentation/providers/task_provider.dart';
import 'package:demo_test/features/tasks/presentation/widgets/task_list_item.dart';
import 'package:demo_test/features/tasks/presentation/widgets/add_task_dialog.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    // Carica i task all'avvio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          // Pulsante refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TaskProvider>().loadTasks();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          // Stato di caricamento
          if (provider.isLoading && provider.tasks.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Stato di errore
          if (provider.error != null && provider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadTasks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Lista vuota
          if (provider.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to create your first task',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Lista task
          return RefreshIndicator(
            onRefresh: () => provider.loadTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];
                return TaskListItem(
                  key: ValueKey(task.id),
                  task: task,
                  onTap: () {
                    // TODO: Navigare al dettaglio task
                  },
                  onToggle: () {
                    provider.toggleTaskCompletion(task.id);
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, task.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Mostra dialog per aggiungere un nuovo task
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddTaskDialog(
        onAdd: (title, description) {
          context.read<TaskProvider>().createTask(title, description);
          Navigator.of(dialogContext).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task created successfully')),
          );
        },
      ),
    );
  }

  /// Mostra conferma eliminazione task
  void _showDeleteConfirmation(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(taskId);
              Navigator.of(dialogContext).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
