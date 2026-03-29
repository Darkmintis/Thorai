import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import 'dart:convert';

class StorageService {
  static const _tokenKey = 'auth_token';
  static const _favoritesKey = 'favorite_books';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> saveFavoriteBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = books.map((b) => b.toJson()).toList();
    await prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }

  Future<List<Book>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null) return [];
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => Book.fromJson(json as Map<String, dynamic>)).toList();
  }
}
