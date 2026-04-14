/// File: app_test.dart
/// 
/// Integration test completi end-to-end.
/// Testa user flow principali dell'applicazione.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_test/core/config/app_config.dart';
import 'package:demo_test/core/utils/app_logger.dart';
import 'package:demo_test/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('User Flow: Navigare a Tasks e creare task', (tester) async {
      // Arrange - Avvia app
      final config = AppConfig.dev();
      AppLogger.init(config);

      await tester.pumpWidget(MyApp(config: config));
      await tester.pumpAndSettle();

      // Assert - Home page visible
      expect(find.text('[DEV] Demo App'), findsOneWidget);
      expect(find.text('Task Management'), findsOneWidget);

      // Act - Naviga a tasks page
      await tester.tap(find.text('Task Management'));
      await tester.pumpAndSettle();

      // Assert - Tasks page visible
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('No tasks yet'), findsOneWidget);

      // Act - Tap FAB per aggiungere task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert - Dialog aperto
      expect(find.text('Add New Task'), findsOneWidget);

      // Act - Compila form
      await tester.enterText(
        find.byType(TextFormField).first,
        'Integration Test Task',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'This task was created by integration test',
      );

      // Act - Tap Add
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Assert - Task creato
      expect(find.text('Integration Test Task'), findsOneWidget);
      expect(find.text('This task was created by integration test'), findsOneWidget);
      expect(find.text('Task created successfully'), findsOneWidget);

      // Cleanup - Chiudi snackbar
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('User Flow: Completare un task', (tester) async {
      // Arrange - Avvia app e naviga a tasks
      final config = AppConfig.dev();
      AppLogger.init(config);

      await tester.pumpWidget(MyApp(config: config));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Task Management'));
      await tester.pumpAndSettle();

      // Crea un task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Task to Complete',
      );
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Task incompleto
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);

      // Act - Toggle completamento
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Assert - Task completato
      final checkboxCompleted = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkboxCompleted.value, true);
      
      // Verifica strikethrough
      final titleText = tester.widget<Text>(find.text('Task to Complete'));
      expect(titleText.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('User Flow: Eliminare un task', (tester) async {
      // Arrange - Avvia app e naviga a tasks
      final config = AppConfig.dev();
      AppLogger.init(config);

      await tester.pumpWidget(MyApp(config: config));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Task Management'));
      await tester.pumpAndSettle();

      // Crea un task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Task to Delete',
      );
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Task presente
      expect(find.text('Task to Delete'), findsOneWidget);

      // Act - Apri menu e tap delete
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert - Conferma dialog aperto
      expect(find.text('Delete Task'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this task?'), findsOneWidget);

      // Act - Conferma eliminazione
      await tester.tap(find.text('Delete').last); // Secondo "Delete" è nel dialog
      await tester.pumpAndSettle();

      // Assert - Task eliminato
      expect(find.text('Task to Delete'), findsNothing);
      expect(find.text('Task deleted'), findsOneWidget);
    });

    testWidgets('User Flow: Refresh task list', (tester) async {
      // Arrange
      final config = AppConfig.dev();
      AppLogger.init(config);

      await tester.pumpWidget(MyApp(config: config));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Task Management'));
      await tester.pumpAndSettle();

      // Crea task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Test Task');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Act - Pull to refresh
      await tester.drag(
        find.text('Test Task'),
        const Offset(0, 300),
      );
      await tester.pumpAndSettle();

      // Assert - Task ancora presente dopo refresh
      expect(find.text('Test Task'), findsOneWidget);
    });
  });
}
