import 'package:dio/dio.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../shared/models/book.dart';

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
  final Dio _dio = DioClient().dio;

  Future<BookResult> fetchBooks(String? token, {int page = 1}) async {
    try {
   final response = await _dio.get(
    ApiConstants.bookGrid,
    queryParameters: {'page': page},
    options: Options(
      headers: {
        if (token != null && token.isNotEmpty)
        'Authorization': 'Token $token',
      },
    ),
   );

   if (response.statusCode == 200){
    return BookResult.fromJson(response.data as Map<String, dynamic>);
   }

   throw Exception('Failed to load books: ${response.statusCode}');
    } on DioException catch (e){
      if (e.type == DioExceptionType.connectionTimeout || 
      e.type == DioExceptionType.receiveTimeout){
        throw Exception('Connection timeout. Please check your internet.');
      }
      if (e.response?.statusCode == 401){
        throw Exception('Unauthorized. Please login again.');
      }
      throw Exception('Failed to load books: ${e.message}');
    }
  }
}