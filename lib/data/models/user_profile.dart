class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final String statusQuote;
  final String email;
  final String phone;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.statusQuote,
    required this.email,
    required this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      statusQuote: json['statusQuote'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'statusQuote': statusQuote,
      'email': email,
      'phone': phone,
    };
  }
}
