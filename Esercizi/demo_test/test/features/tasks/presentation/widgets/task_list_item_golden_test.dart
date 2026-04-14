/// File: task_list_item_golden_test.dart
/// 
/// Golden test per TaskListItem.
/// Verifica regressioni UI attraverso screenshot comparison.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';
import 'package:demo_test/features/tasks/presentation/widgets/task_list_item.dart';

void main() {
  group('TaskListItem Golden Tests', () {
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'This is a test task description',
      isCompleted: false,
      createdAt: DateTime(2026, 4, 14, 10, 30),
    );

    testWidgets('golden - task incompletpo light theme', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TaskListItem(task: testTask),
            ),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TaskListItem),
        matchesGoldenFile('goldens/task_list_item_uncompleted_light.png'),
      );
    });

    testWidgets('golden - task completato light theme', (tester) async {
      // Arrange
      final completedTask = testTask.copyWith(
        isCompleted: true,
        completedAt: DateTime(2026, 4, 14, 11, 0),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TaskListItem(task: completedTask),
            ),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TaskListItem),
        matchesGoldenFile('goldens/task_list_item_completed_light.png'),
      );
    });

    testWidgets('golden - task incompleto dark theme', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TaskListItem(task: testTask),
            ),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TaskListItem),
        matchesGoldenFile('goldens/task_list_item_uncompleted_dark.png'),
      );
    });

    testWidgets('golden - task senza descrizione', (tester) async {
      // Arrange
      final taskNoDesc = testTask.copyWith(description: null);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: TaskListItem(task: taskNoDesc),
            ),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TaskListItem),
        matchesGoldenFile('goldens/task_list_item_no_description.png'),
      );
    });
  });
}
