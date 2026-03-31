import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../shared/models/book.dart';
import 'dart:convert';

class StorageService {
  static const _tokenKey = 'auth_token';
  static const _favoritesKey = 'favorite_books';
  
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await storage.delete(key: _tokenKey);
  }

  Future<void> saveFavoriteBooks(List<Book> books) async {
    final jsonList = books.map((b) => b.toJson()).toList();
    await storage.write(key: _favoritesKey, value: jsonEncode(jsonList));
  }

  Future<List<Book>> getFavoriteBooks() async {
    final jsonString = await storage.read(key: _favoritesKey);
    if (jsonString == null) return [];
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Book.fromJson(json as Map<String, dynamic>)).toList();
  }
}
