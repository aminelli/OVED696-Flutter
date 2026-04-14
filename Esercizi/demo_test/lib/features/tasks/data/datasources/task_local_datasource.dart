/// File: task_local_datasource.dart
/// 
/// Datasource locale per i task.
/// Implementa storage in memoria (in produzione sarebbe un database locale).

import 'package:demo_test/features/tasks/data/models/task_model.dart';

class TaskLocalDatasource {
  // Storage in memoria dei task
  final List<TaskModel> _tasks = [];

  /// Recupera tutti i task
  Future<List<TaskModel>> getTasks() async {
    // Simula delay di rete
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_tasks);
  }

  /// Recupera un task per ID
  Future<TaskModel?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Salva un task
  Future<TaskModel> saveTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Rimuovi task esistente con stesso ID
    _tasks.removeWhere((t) => t.id == task.id);
    
    // Aggiungi nuovo task
    _tasks.add(task);
    
    return task;
  }

  /// Elimina un task
  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tasks.removeWhere((task) => task.id == id);
  }

  /// Pulisce tutti i task (utile per testing)
  Future<void> clearAll() async {
    _tasks.clear();
  }
}
