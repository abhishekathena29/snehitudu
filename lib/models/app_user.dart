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
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.emergencyContact,
    this.medicalInfo,
    required this.preferences,
  });

  final String id;
  final String name;
  final String email;
  final int? age;
  final String? emergencyContact;
  final String? medicalInfo;
  final UserPreferences preferences;

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? 'User',
      email: map['email'] ?? '',
      age: map['age'],
      emergencyContact: map['emergencyContact'],
      medicalInfo: map['medicalInfo'],
      preferences: UserPreferences.fromMap(map['preferences']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'emergencyContact': emergencyContact,
      'medicalInfo': medicalInfo,
      'preferences': preferences.toMap(),
    };
  }

  AppUser copyWith({
    String? name,
    String? email,
    int? age,
    String? emergencyContact,
    String? medicalInfo,
    UserPreferences? preferences,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      preferences: preferences ?? this.preferences,
    );
  }
}
