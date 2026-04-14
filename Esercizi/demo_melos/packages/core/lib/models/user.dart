/// Modello immutabile che rappresenta un utente dell'applicazione.
///
/// Un utente ha un ID univoco, nome, email e un avatar opzionale.
/// È utilizzato sia nell'app mobile che nell'app admin.
class User {
  /// Crea un nuovo User.
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = UserRole.user,
  });

  /// Identificatore univoco dell'utente
  final String id;

  /// Nome completo dell'utente
  final String name;

  /// Email dell'utente (univoca)
  final String email;

  /// URL dell'avatar (opzionale)
  final String? avatarUrl;

  /// Ruolo dell'utente nel sistema
  final UserRole role;

  /// Restituisce le iniziali del nome per avatar placeholder.
  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  /// Verifica se l'utente è un amministratore.
  bool get isAdmin => role == UserRole.admin;

  /// Crea una copia dell'utente con i campi specificati modificati.
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        other.role == role;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, email, avatarUrl, role);
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, '
        'avatarUrl: $avatarUrl, role: $role)';
  }

  /// Converte l'utente in una Map per la serializzazione.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.name,
    };
  }

  /// Crea un utente da una Map (deserializzazione).
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.user,
      ),
    );
  }
}

/// Enumerazione dei possibili ruoli utente.
enum UserRole {
  /// Utente standard
  user,

  /// Amministratore con privilegi elevati
  admin,

  /// Moderatore con privilegi limitati
  moderator,
}
