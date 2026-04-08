/// Model per rappresentare un Task nel database SQLite.
/// 
/// Contiene le informazioni principali di un task:
/// - id: chiave primaria auto-incrementale
/// - title: titolo del task
/// - description: descrizione dettagliata
/// - completed: stato di completamento
/// - createdAt: timestamp di creazione
class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.completed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Crea un TaskModel da una mappa (per lettura da DB)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      completed: (map['completed'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Converte il TaskModel in una mappa (per scrittura su DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crea una copia del task con alcuni campi modificati
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, completed: $completed)';
  }
}
