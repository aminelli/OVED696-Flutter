/// File: task_test.dart
/// 
/// Unit test per la entity Task.
/// Testa creazione, equality, copyWith.

import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    final testDate = DateTime(2026, 4, 14);
    
    test('dovrebbe creare un task con tutti i parametri', () {
      // Arrange & Act
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: testDate,
      );

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
      expect(task.createdAt, testDate);
      expect(task.completedAt, null);
    });

    test('copyWith dovrebbe creare una copia con modifiche', () {
      // Arrange
      final original = Task(
        id: '1',
        title: 'Original',
        isCompleted: false,
        createdAt: testDate,
      );

      // Act
      final modified = original.copyWith(
        title: 'Modified',
        isCompleted: true,
      );

      // Assert
      expect(modified.id, '1'); // Unchanged
      expect(modified.title, 'Modified'); // Changed
      expect(modified.isCompleted, true); // Changed
      expect(modified.createdAt, testDate); // Unchanged
    });

    test('equality dovrebbe funzionare correttamente', () {
      // Arrange
      final task1 = Task(
        id: '1',
        title: 'Task',
        isCompleted: false,
        createdAt: testDate,
      );
      
      final task2 = Task(
        id: '1',
        title: 'Task',
        isCompleted: false,
        createdAt: testDate,
      );
      
      final task3 = Task(
        id: '2',
        title: 'Task',
        isCompleted: false,
        createdAt: testDate,
      );

      // Assert
      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('toString dovrebbe ritornare rappresentazione corretta', () {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test',
        isCompleted: true,
        createdAt: testDate,
      );

      // Act
      final result = task.toString();

      // Assert
      expect(result, contains('id: 1'));
      expect(result, contains('title: Test'));
      expect(result, contains('isCompleted: true'));
    });
  });
}
