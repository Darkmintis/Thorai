import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../models/login_request.dart';
import '../../../models/user.dart';

class AuthService {
  Future<User> login(LoginRequest req) async {
    final res = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    }

    String message = 'Failed to login (status ${res.statusCode})';
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['detail'] != null) message = body['detail'];
    } catch (_) {}
    throw Exception(message);
  }
}