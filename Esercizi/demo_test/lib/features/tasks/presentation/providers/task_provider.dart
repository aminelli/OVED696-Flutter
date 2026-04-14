/// File: task_provider.dart
/// 
/// Provider per la gestione dello stato dei task.
/// Utilizza ChangeNotifier per notificare i cambiamenti.

import 'package:flutter/foundation.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';
import 'package:demo_test/features/tasks/domain/repositories/task_repository.dart';
import 'package:demo_test/core/utils/app_logger.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskProvider({required this.repository});

  // Lista dei task
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Stato di caricamento
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Errore
  String? _error;
  String? get error => _error;

  /// Carica tutti i task
  Future<void> loadTasks() async {
    _setLoading(true);
    _error = null;

    try {
      _tasks = await repository.getTasks();
      AppLogger.debug('Tasks loaded successfully', '${_tasks.length} tasks');
      notifyListeners();
    } catch (e, stackTrace) {
      _error = 'Failed to load tasks: $e';
      AppLogger.error('Error loading tasks', e, stackTrace);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Crea un nuovo task
  Future<void> createTask(String title, String? description) async {
    _error = null;

    try {
      final newTask = await repository.createTask(title, description);
      _tasks.insert(0, newTask);
      AppLogger.info('Task created', newTask.toString());
      notifyListeners();
    } catch (e, stackTrace) {
      _error = 'Failed to create task: $e';
      AppLogger.error('Error creating task', e, stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Aggiorna un task
  Future<void> updateTask(Task task) async {
    _error = null;

    try {
      final updated = await repository.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _tasks[index] = updated;
      }
      AppLogger.info('Task updated', updated.toString());
      notifyListeners();
    } catch (e, stackTrace) {
      _error = 'Failed to update task: $e';
      AppLogger.error('Error updating task', e, stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Elimina un task
  Future<void> deleteTask(String id) async {
    _error = null;

    try {
      await repository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      AppLogger.info('Task deleted', id);
      notifyListeners();
    } catch (e, stackTrace) {
      _error = 'Failed to delete task: $e';
      AppLogger.error('Error deleting task', e, stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Toggle completamento task
  Future<void> toggleTaskCompletion(String id) async {
    _error = null;

    try {
      final task = _tasks.firstWhere((t) => t.id == id);
      final updated = task.isCompleted
          ? await repository.uncompleteTask(id)
          : await repository.completeTask(id);

      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updated;
      }
      AppLogger.info('Task toggled', updated.toString());
      notifyListeners();
    } catch (e, stackTrace) {
      _error = 'Failed to toggle task: $e';
      AppLogger.error('Error toggling task', e, stackTrace);
      notifyListeners();
      rethrow;
    }
  }

  /// Filtra task completati
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  /// Filtra task attivi
  List<Task> get activeTasks => _tasks.where((t) => !t.isCompleted).toList();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
