/// File: add_task_dialog_test.dart
/// 
/// Widget test per AddTaskDialog.
/// Testa rendering, validazione form e interazioni.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/tasks/presentation/widgets/add_task_dialog.dart';

void main() {
  group('AddTaskDialog Widget', () {
    testWidgets('dovrebbe renderizzare correttamente', (tester) async {
      // Arrange - nessuna callback necessaria per test rendering

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(
              onAdd: (title, description) {
                // Callback vuota per test
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Add New Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('dovrebbe validare campo titolo obbligatorio', (tester) async {
      // Arrange
      var addCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(
              onAdd: (title, description) {
                addCalled = true;
              },
            ),
          ),
        ),
      );

      // Act - Tap Add senza inserire titolo
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Please enter a title'), findsOneWidget);
      expect(addCalled, false);
    });

    testWidgets('dovrebbe validare lunghezza minima titolo', (tester) async {
      // Arrange
      var addCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(
              onAdd: (title, description) {
                addCalled = true;
              },
            ),
          ),
        ),
      );

      // Act - Inserisci titolo troppo corto
      await tester.enterText(
        find.byType(TextFormField).first,
        'ab',
      );
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(find.text('Title must be at least 3 characters'), findsOneWidget);
      expect(addCalled, false);
    });

    testWidgets('dovrebbe chiamare onAdd con dati corretti', (tester) async {
      // Arrange
      var addCalled = false;
      String? capturedTitle;
      String? capturedDescription;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(
              onAdd: (title, description) {
                addCalled = true;
                capturedTitle = title;
                capturedDescription = description;
              },
            ),
          ),
        ),
      );

      // Act - Compila form valido
      await tester.enterText(
        find.byType(TextFormField).first,
        'Test Task',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Test Description',
      );
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(addCalled, true);
      expect(capturedTitle, 'Test Task');
      expect(capturedDescription, 'Test Description');
    });

    testWidgets('dovrebbe gestire descrizione opzionale vuota', (tester) async {
      // Arrange
      String? capturedDescription;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskDialog(
              onAdd: (title, description) {
                capturedDescription = description;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'Test Task');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Assert
      expect(capturedDescription, null);
    });

    testWidgets('Cancel dovrebbe chiudere dialog', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AddTaskDialog(onAdd: (_, __) {}),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Act - Apri dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add New Task'), findsOneWidget);

      // Act - Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Assert - Dialog chiuso
      expect(find.text('Add New Task'), findsNothing);
    });
  });
}
