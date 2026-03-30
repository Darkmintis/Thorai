import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import 'login_request.dart';
import 'user.dart';

class AuthService {
  Future<User> login(LoginRequest req) async {
    // Try with 'email' field first
    var response = await _attemptLogin({'email': req.email, 'password': req.password});
    
    // If 400, try with 'username' field
    if (response.statusCode == 400) {
      response = await _attemptLogin({'username': req.email, 'password': req.password});
    }
    
    return _handleResponse(response);
  }

  Future<http.Response> _attemptLogin(Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  User _handleResponse(http.Response res) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    }

    // For any error, show user-friendly message
    if (res.statusCode == 400 || res.statusCode == 401 || res.statusCode == 403) {
      throw Exception('Invalid email or password');
    }

    String message = 'Invalid email or password';
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['detail'] != null) {
        message = body['detail'];
      }
    } catch (e) {
      // Ignore parse errors
    }
    
    throw Exception(message);
  }
}