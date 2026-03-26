class User {
  final String token;
  final String? username;

  User({required this.token, this.username});

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json['token'] ?? json['access_token'] ?? '',
        username: json['username'] ?? json['email'],
      );
}