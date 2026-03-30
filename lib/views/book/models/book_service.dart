import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import 'book.dart';

class BookResult {
  final List<Book> books;
  final bool hasNext;

  BookResult({required this.books, required this.hasNext});


factory BookResult.fromJson(Map<String, dynamic> json){
  final pagination = json['pagination'] as Map<String, dynamic>?;
  final nextPage = pagination != null ? pagination['next'] : null;
  final list = (json['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  final books = list.map((bookJson) => Book.fromJson(bookJson)).toList();
  final hasNext = nextPage != null && nextPage.toString().isNotEmpty;

  return BookResult(
    books: books,
    hasNext: hasNext,
  );
}

Map<String, dynamic> toJson(){
  return{
    'books': books.map((book) => book.toJson()).toList(),
    'hasNext': hasNext,
  };
}
}

class BookService {
  Future<BookResult> fetchBooks(String? token, {int page = 1}) async {
    final url = '${ApiConstants.bookGrid}?page=$page';

        final headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
       if(token != null && token.isNotEmpty)
        'Authorization' : 'Token $token',
        };

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return BookResult.fromJson(body);
    }

    throw Exception('Failed to load books: ${response.statusCode}');
  }
}
