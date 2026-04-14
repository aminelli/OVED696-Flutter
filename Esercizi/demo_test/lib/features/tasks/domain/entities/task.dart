/// File: task.dart
/// 
/// Entity del domain layer rappresentante un task.
/// Contiene solo business logic, senza dipendenze da framework.

class Task {
  /// ID univoco del task
  final String id;
  
  /// Titolo del task
  final String title;
  
  /// Descrizione dettagliata del task
  final String? description;
  
  /// Stato di completamento
  final bool isCompleted;
  
  /// Data di creazione
  final DateTime createdAt;
  
  /// Data di completamento (se completato)
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  /// Crea una copia del task con modifiche opzionali
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
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      isCompleted.hashCode ^
      createdAt.hashCode ^
      completedAt.hashCode;
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
