/// File: task_repository_impl.dart
/// 
/// Implementazione concreta del TaskRepository.
/// Coordina datasources e converte tra models ed entities.

import 'package:demo_test/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:demo_test/features/tasks/data/models/task_model.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';
import 'package:demo_test/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDatasource localDatasource;

  TaskRepositoryImpl({required this.localDatasource});

  @override
  Future<List<Task>> getTasks() async {
    final models = await localDatasource.getTasks();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final model = await localDatasource.getTaskById(id);
    return model?.toEntity();
  }

  @override
  Future<Task> createTask(String title, String? description) async {
    final now = DateTime.now();
    final model = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      isCompleted: false,
      createdAt: now,
    );
    
    final saved = await localDatasource.saveTask(model);
    return saved.toEntity();
  }

  @override
  Future<Task> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    final saved = await localDatasource.saveTask(model);
    return saved.toEntity();
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDatasource.deleteTask(id);
  }

  @override
  Future<Task> completeTask(String id) async {
    final task = await getTaskById(id);
    if (task == null) {
      throw Exception('Task not found');
    }
    
    final updated = task.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    
    return updateTask(updated);
  }

  @override
  Future<Task> uncompleteTask(String id) async {
    final task = await getTaskById(id);
    if (task == null) {
      throw Exception('Task not found');
    }
    
    final updated = task.copyWith(
      isCompleted: false,
      completedAt: null,
    );
    
    return updateTask(updated);
  }
}
