import 'package:flutter/material.dart';
import '../../shared/models/book.dart';
import '../../core/services/storage_service.dart';

class FavoriteService extends ChangeNotifier {
  final StorageService _storage;

  List<Book> _favorites = [];

  FavoriteService(this._storage) {
    loadFavorites(); // auto load on start
  }

  List<Book> get favorites => _favorites;
  int get favoritesCount => _favorites.length;
  bool get hasFavorites => _favorites.isNotEmpty;

  Future<void> loadFavorites() async {
    _favorites = await _storage.getFavoriteBooks();
    notifyListeners();
  }

  bool isFavorite(Book book) {
    return _favorites.any((b) => b.slug == book.slug);
  }

  Future<void> toggleFavorite(Book book) async {
    if (isFavorite(book)) {
      _favorites.removeWhere((b) => b.slug == book.slug);
    } else {
      _favorites.add(book);
    }

    await _storage.saveFavoriteBooks(_favorites);
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _storage.saveFavoriteBooks(_favorites);
    notifyListeners();
  }

  Book? getFavoriteBySlug(String slug) {
    try {
      return _favorites.firstWhere((b) => b.slug == slug);
    } catch (_) {
      return null;
    }
  }
}