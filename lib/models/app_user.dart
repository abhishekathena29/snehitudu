class UserPreferences {
  const UserPreferences({
    required this.notifications,
    required this.accessibility,
    required this.theme,
  });

  final bool notifications;
  final bool accessibility;
  final String theme;

  factory UserPreferences.fromMap(Map<String, dynamic>? map) {
    final data = map ?? <String, dynamic>{};
    return UserPreferences(
      notifications: data['notifications'] ?? true,
      accessibility: data['accessibility'] ?? true,
      theme: data['theme'] ?? 'auto',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications,
      'accessibility': accessibility,
      'theme': theme,
    };
  }

  UserPreferences copyWith({
    bool? notifications,
    bool? accessibility,
    String? theme,
  }) {
    return UserPreferences(
      notifications: notifications ?? this.notifications,
      accessibility: accessibility ?? this.accessibility,
      theme: theme ?? this.theme,
    );
  }
}

class AppUser {
  const AppUser({
    required this.name,
    this.age,
    this.emergencyContact,
    required this.preferences,
  });

  final String name;
  final int? age;
  final String? emergencyContact;
  final UserPreferences preferences;

  factory AppUser.initial() {
    return const AppUser(
      name: 'Friend',
      preferences: UserPreferences(
        notifications: true,
        accessibility: true,
        theme: 'auto',
      ),
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? 'Friend',
      age: map['age'],
      emergencyContact: map['emergencyContact'],
      preferences: UserPreferences.fromMap(map['preferences']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'emergencyContact': emergencyContact,
      'preferences': preferences.toMap(),
    };
  }

  AppUser copyWith({
    String? name,
    int? age,
    String? emergencyContact,
    UserPreferences? preferences,
  }) {
    return AppUser(
      name: name ?? this.name,
      age: age ?? this.age,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      preferences: preferences ?? this.preferences,
    );
  }
}
