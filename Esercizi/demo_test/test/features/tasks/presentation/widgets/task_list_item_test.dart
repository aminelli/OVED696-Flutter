/// File: task_list_item_test.dart
/// 
/// Widget test per TaskListItem.
/// Testa rendering e interazioni.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/tasks/domain/entities/task.dart';
import 'package:demo_test/features/tasks/presentation/widgets/task_list_item.dart';

void main() {
  group('TaskListItem Widget', () {
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      isCompleted: false,
      createdAt: DateTime(2026, 4, 14, 10, 30),
    );

    testWidgets('dovrebbe renderizzare task non completato', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
    });

    testWidgets('dovrebbe renderizzare task completato con strikethrough', (tester) async {
      // Arrange
      final completedTask = testTask.copyWith(
        isCompleted: true,
        completedAt: DateTime(2026, 4, 14, 11, 0),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(task: completedTask),
          ),
        ),
      );

      // Assert
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
      
      // Verifica strikethrough sul titolo
      final titleText = tester.widget<Text>(find.text('Test Task'));
      expect(titleText.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('dovrebbe chiamare onToggle quando checkbox tappato', (tester) async {
      // Arrange
      var toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(
              task: testTask,
              onToggle: () {
                toggleCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Assert
      expect(toggleCalled, true);
    });

    testWidgets('dovrebbe chiamare onTap quando item tappato', (tester) async {
      // Arrange
      var tapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(
              task: testTask,
              onTap: () {
                tapCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      // Assert
      expect(tapCalled, true);
    });

    testWidgets('dovrebbe mostrare menu delete', (tester) async {
      // Arrange
      var deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(
              task: testTask,
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      // Act - Apri popup menu
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert - Menu visible
      expect(find.text('Delete'), findsOneWidget);

      // Act - Tap delete
      await tester.tap(find.text('Delete'));
      await tester.pump();

      // Assert - Callback chiamato
      expect(deleteCalled, true);
    });

    testWidgets('dovrebbe mostrare data creazione', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(task: testTask),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Created:'), findsOneWidget);
      expect(find.textContaining('Apr 14, 2026'), findsOneWidget);
    });

    testWidgets('dovrebbe mostrare data completamento se completato', (tester) async {
      // Arrange
      final completedTask = testTask.copyWith(
        isCompleted: true,
        completedAt: DateTime(2026, 4, 14, 11, 0),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskListItem(task: completedTask),
          ),
        ),
      );

      // Assert
      expect(find.textContaining('Completed:'), findsOneWidget);
    });
  });
}
