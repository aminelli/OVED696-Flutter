/// File: task_repository.dart
/// 
/// Interfaccia del repository per i task (domain layer).
/// Definisce i contratti che l'implementazione deve rispettare.

import 'package:demo_test/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  /// Recupera tutti i task
  Future<List<Task>> getTasks();
  
  /// Recupera un task specifico per ID
  Future<Task?> getTaskById(String id);
  
  /// Crea un nuovo task
  Future<Task> createTask(String title, String? description);
  
  /// Aggiorna un task esistente
  Future<Task> updateTask(Task task);
  
  /// Elimina un task
  Future<void> deleteTask(String id);
  
  /// Segna un task come completato
  Future<Task> completeTask(String id);
  
  /// Segna un task come non completato
  Future<Task> uncompleteTask(String id);
}
