/// Modello immutabile che rappresenta un task dell'applicazione.
///
/// Un task ha un titolo, una descrizione opzionale, uno stato di completamento
/// e le date di creazione e completamento.
class Task {
  /// Crea un nuovo Task.
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Identificatore univoco del task
  final String id;

  /// Titolo del task
  final String title;

  /// Descrizione opzionale del task
  final String? description;

  /// Indica se il task è stato completato
  final bool isCompleted;

  /// Data di creazione del task
  final DateTime createdAt;

  /// Data di completamento del task (null se non completato)
  final DateTime? completedAt;

  /// Crea una copia del task con i campi specificati modificati.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Marca il task come completato.
  Task complete() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  /// Marca il task come non completato.
  Task uncomplete() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      isCompleted,
      createdAt,
      completedAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, '
        'isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt)';
  }

  /// Converte il task in una Map per la serializzazione.
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

  /// Crea un task da una Map (deserializzazione).
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
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
}
