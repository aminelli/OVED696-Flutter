/// File: task_repository_test.dart
/// 
/// Test del repository con Mockito.
/// Testa l'implementazione del repository mockando il datasource.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:demo_test/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:demo_test/features/tasks/data/models/task_model.dart';
import 'package:demo_test/features/tasks/data/repositories/task_repository_impl.dart';

// Genera mocks con build_runner
@GenerateMocks([TaskLocalDatasource])
import 'task_repository_test.mocks.dart';

void main() {
  group('TaskRepositoryImpl', () {
    late MockTaskLocalDatasource mockDatasource;
    late TaskRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockTaskLocalDatasource();
      repository = TaskRepositoryImpl(localDatasource: mockDatasource);
    });

    test('getTasks dovrebbe ritornare lista di tasks', () async {
      // Arrange
      final taskModels = [
        TaskModel(
          id: '1',
          title: 'Task 1',
          isCompleted: false,
          createdAt: DateTime(2026, 4, 14),
        ),
        TaskModel(
          id: '2',
          title: 'Task 2',
          isCompleted: true,
          createdAt: DateTime(2026, 4, 14),
        ),
      ];
      
      when(mockDatasource.getTasks())
          .thenAnswer((_) async => taskModels);

      // Act
      final result = await repository.getTasks();

      // Assert
      expect(result.length, 2);
      expect(result[0].title, 'Task 1');
      expect(result[1].title, 'Task 2');
      verify(mockDatasource.getTasks()).called(1);
    });

    test('getTaskById dovrebbe ritornare task corretto', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Task 1',
        isCompleted: false,
        createdAt: DateTime(2026, 4, 14),
      );
      
      when(mockDatasource.getTaskById('1'))
          .thenAnswer((_) async => taskModel);

      // Act
      final result = await repository.getTaskById('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.title, 'Task 1');
      verify(mockDatasource.getTaskById('1')).called(1);
    });

    test('getTaskById dovrebbe ritornare null se non trovato', () async {
      // Arrange
      when(mockDatasource.getTaskById('999'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getTaskById('999');

      // Assert
      expect(result, isNull);
    });

    test('createTask dovrebbe creare e salvare nuovo task', () async {
      // Arrange
      when(mockDatasource.saveTask(any))
          .thenAnswer((invocation) async {
            final model = invocation.positionalArguments[0] as TaskModel;
            return model;
          });

      // Act
      final result = await repository.createTask('New Task', 'Description');

      // Assert
      expect(result.title, 'New Task');
      expect(result.description, 'Description');
      expect(result.isCompleted, false);
      verify(mockDatasource.saveTask(any)).called(1);
    });

    test('deleteTask dovrebbe chiamare datasource', () async {
      // Arrange
      when(mockDatasource.deleteTask('1'))
          .thenAnswer((_) async => {});

      // Act
      await repository.deleteTask('1');

      // Assert
      verify(mockDatasource.deleteTask('1')).called(1);
    });

    test('completeTask dovrebbe marcare task come completato', () async {
      // Arrange
      final existingTask = TaskModel(
        id: '1',
        title: 'Task',
        isCompleted: false,
        createdAt: DateTime(2026, 4, 14),
      );
      
      when(mockDatasource.getTaskById('1'))
          .thenAnswer((_) async => existingTask);
      
      when(mockDatasource.saveTask(any))
          .thenAnswer((invocation) async {
            final model = invocation.positionalArguments[0] as TaskModel;
            return model;
          });

      // Act
      final result = await repository.completeTask('1');

      // Assert
      expect(result.isCompleted, true);
      expect(result.completedAt, isNotNull);
      verify(mockDatasource.getTaskById('1')).called(1);
      verify(mockDatasource.saveTask(any)).called(1);
    });
  });
}
