/// File: task_model.dart
/// 
/// Model del data layer per Task.
/// Si occupa della serializzazione/deserializzazione JSON.

import 'package:demo_test/features/tasks/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.isCompleted,
    required super.createdAt,
    super.completedAt,
  });

  /// Crea un TaskModel da JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  /// Converte il TaskModel in JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Crea un TaskModel da un Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
    );
  }

  /// Converte il TaskModel in Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      completedAt: completedAt,
    );
  }
}
