/// File che contiene tutte le classi per gli argomenti delle route.
/// 
/// Ogni classe rappresenta i parametri necessari per navigare
/// verso una specifica schermata dell'applicazione.

import 'task.dart';

/// Argomenti per la navigazione alla schermata di dettaglio del task.
/// 
/// Richiede:
/// - [taskId]: ID del task da visualizzare
class TaskDetailArguments {
  final String taskId;

  const TaskDetailArguments({
    required this.taskId,
  });
}

/// Argomenti per la navigazione alla schermata del form task.
/// 
/// Può essere utilizzato sia per creare un nuovo task che per modificarne uno esistente.
/// - [task]: Se null, si sta creando un nuovo task; altrimenti si modifica il task esistente
/// - [isEditing]: Flag che indica se si è in modalità modifica
class TaskFormArguments {
  final Task? task;
  final bool isEditing;

  const TaskFormArguments({
    this.task,
    this.isEditing = false,
  });

  /// Factory per creare argomenti per un nuovo task.
  factory TaskFormArguments.create() {
    return const TaskFormArguments(isEditing: false);
  }

  /// Factory per creare argomenti per modificare un task esistente.
  factory TaskFormArguments.edit(Task task) {
    return TaskFormArguments(
      task: task,
      isEditing: true,
    );
  }
}
