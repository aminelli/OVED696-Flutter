/// Modello che rappresenta un singolo task nell'applicazione.
/// 
/// Ogni task ha:
/// - [id]: Identificatore univoco del task
/// - [title]: Titolo del task
/// - [description]: Descrizione dettagliata del task
/// - [isCompleted]: Stato di completamento del task
/// - [priority]: Livello di priorità (bassa, media, alta)
/// - [createdAt]: Data e ora di creazione
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    required this.createdAt,
  });

  /// Crea una copia del task con alcuni campi modificati.
  /// 
  /// Utile per creare versioni modificate del task mantenendo
  /// l'immutabilità dell'oggetto.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converte il task in una mappa per la serializzazione.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crea un task da una mappa (deserializzazione).
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
      priority: TaskPriority.values[map['priority'] as int],
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Enum che rappresenta i livelli di priorità di un task.
enum TaskPriority {
  low,    // Bassa priorità
  medium, // Media priorità
  high,   // Alta priorità
}

/// Estensione per ottenere informazioni utili sulla priorità.
extension TaskPriorityExtension on TaskPriority {
  /// Restituisce il nome leggibile della priorità.
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Bassa';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  /// Restituisce il colore associato alla priorità.
  String get colorHex {
    switch (this) {
      case TaskPriority.low:
        return '#4CAF50'; // Verde
      case TaskPriority.medium:
        return '#FF9800'; // Arancione
      case TaskPriority.high:
        return '#F44336'; // Rosso
    }
  }
}
