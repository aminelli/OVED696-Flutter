/// File: task_model_test.dart
/// 
/// Test per TaskModel (serializzazione/deserializzazione JSON).

import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/tasks/data/models/task_model.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';

void main() {
  group('TaskModel', () {
    final testDate = DateTime(2026, 4, 14, 10, 30);
    
    test('fromJson dovrebbe creare TaskModel correttamente', () {
      // Arrange
      final json = {
        'id': '1', 
        'title': 'Test Task',
        'description': 'Test Description',
        'isCompleted': true,
        'createdAt': testDate.toIso8601String(),
        'completedAt': testDate.toIso8601String(),
      };

      // Act
      final model = TaskModel.fromJson(json);

      // Assert
      expect(model.id, '1');
      expect(model.title, 'Test Task');
      expect(model.description, 'Test Description');
      expect(model.isCompleted, true);
      expect(model.createdAt, testDate);
      expect(model.completedAt, testDate);
    });

    test('fromJson dovrebbe gestire campi opzionali nulli', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test',
        'description': null,
        'isCompleted': false,
        'createdAt': testDate.toIso8601String(),
        'completedAt': null,
      };

      // Act
      final model = TaskModel.fromJson(json);

      // Assert
      expect(model.description, null);
      expect(model.completedAt, null);
    });

    test('toJson dovrebbe serializzare correttamente', () {
      // Arrange
      final model = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
        createdAt: DateTime(2026, 4, 14),
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['description'], 'Test Description');
      expect(json['isCompleted'], true);
      expect(json['createdAt'], isA<String>());
    });

    test('fromEntity dovrebbe convertire Task a TaskModel', () {
      // Arrange
      final entity = Task(
        id: '1',
        title: 'Test',
        isCompleted: false,
        createdAt: testDate,
      );

      // Act
      final model = TaskModel.fromEntity(entity);

      // Assert
      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.isCompleted, entity.isCompleted);
    });

    test('toEntity dovrebbe convertire TaskModel a Task', () {
      // Arrange
      final model = TaskModel(
        id: '1',
        title: 'Test',
        isCompleted: false,
        createdAt: DateTime(2026, 4, 14),
      );

      // Act
      final entity = model.toEntity();

      // Assert
      expect(entity, isA<Task>());
      expect(entity.id, model.id);
      expect(entity.title, model.title);
    });
  });
}
