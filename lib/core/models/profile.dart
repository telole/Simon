class Profile {
  final String id;
  final String fullName;
  final String username;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.fullName,
    required this.username,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'avatar_url': avatarUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

