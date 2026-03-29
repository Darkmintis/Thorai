import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../models/book.dart';

class BookResult {
  final List<Book> books;
  final bool hasNext;

  BookResult({required this.books, required this.hasNext});
}

class BookService {
  Future<BookResult> fetchBooks(String? token, {int page = 1}) async {
    final url = '${ApiConstants.bookGrid}?page=$page';
    http.Response response;

    if (token != null && token.isNotEmpty) {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        return _parseBookResult(response);
      }
    }

    // Try without auth
    response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return _parseBookResult(response);
    }

    throw Exception('Failed to load books: ${response.statusCode}');
  }

  BookResult _parseBookResult(http.Response res) {
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final pagination = body['pagination'] as Map<String, dynamic>?;
    final nextPage = pagination != null ? pagination['next'] : null;
    final list = (body['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final books = list.map((json) => Book.fromJson(json)).toList();
    final hasNext = nextPage != null && nextPage.toString().isNotEmpty;
    return BookResult(books: books, hasNext: hasNext);
  }
}