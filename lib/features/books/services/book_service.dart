import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../models/book.dart';

class BookService {
  Future<List<Book>> fetchBooks(String? token) async {
    // Try first with token if provided.
    if (token != null && token.isNotEmpty) {
      final tokenResponse = await _getBooks(token);
      if (tokenResponse.statusCode == 200) return _parseBooks(tokenResponse);
      if (tokenResponse.statusCode == 401 && ApiConstants.demoToken.isNotEmpty && token != ApiConstants.demoToken) {
        final demoResponse = await _getBooks(ApiConstants.demoToken);
        if (demoResponse.statusCode == 200) return _parseBooks(demoResponse);
      }
    }

    // Retry without auth header (for open endpoint mode).
    final noAuthResponse = await http.get(
      Uri.parse(ApiConstants.bookGrid),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (noAuthResponse.statusCode == 200) {
      return _parseBooks(noAuthResponse);
    }

    // Last fallback: local static demo books so app always shows something.
    return [
      Book(id: 1, title: 'Demo Book 1', englishTitle: 'Demo Book 1', frontCover: null),
      Book(id: 2, title: 'Demo Book 2', englishTitle: 'Demo Book 2', frontCover: null),
      Book(id: 3, title: 'Demo Book 3', englishTitle: 'Demo Book 3', frontCover: null),
    ];
  }

  Future<http.Response> _getBooks(String token) => http.get(
        Uri.parse(ApiConstants.bookGrid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );

  List<Book> _parseBooks(http.Response res) {
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final list = (body['results'] as List).cast<Map<String, dynamic>>();
    return list.map((json) => Book.fromJson(json)).toList();
  }
}