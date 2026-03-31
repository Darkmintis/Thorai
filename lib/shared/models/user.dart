class User {
  final String token;
  final String? email;

  User({required this.token, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json['token'] ?? json['access_token'] ?? json['key'] ?? '',
        email: json['email'],
      );
}