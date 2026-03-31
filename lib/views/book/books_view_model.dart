import '../../core/base/base_viewmodel.dart';
import 'package:flutter/material.dart';
import 'models/book_service.dart';
import '../../shared/models/book.dart';
import '../../core/services/storage_service.dart';

class BooksViewModel extends BaseViewModel {
  final BookService bookService;
  final StorageService storage;

  List<Book> books = [];
  int currentPage = 1;
  bool hasNextPage = true;
  bool hasPrevPage = false;
  bool _initialized = false;

  // Navigation callbacks - set by the View
  VoidCallback? onNavigateToFavorites;
  VoidCallback? onNavigateToLogin;

  BooksViewModel({
    BookService? bookService,
    StorageService? storage,
  })  : bookService = bookService ?? BookService(),
        storage = storage ?? StorageService();

  void init() {
    if (_initialized) return;
      _initialized = true;
      loadBooks();
      }

  Future<void> loadBooks({int? page}) async {
    if (page != null) currentPage = page;
    setLoading(true);
    clearError();
    try {
      final token = await storage.getToken();
      final result = await bookService.fetchBooks(token, page: currentPage);
      books = result.books;
      hasNextPage = result.hasNext && books.isNotEmpty;
      hasPrevPage = currentPage > 1;
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  void nextPage() {
    if (hasNextPage && !loading) {
      loadBooks(page: currentPage + 1);
    }
  }

  void prevPage() {
    if (hasPrevPage && !loading) {
      loadBooks(page: currentPage - 1);
    }
  }

  Future<void> logout() async {
    await storage.clearToken();
    onNavigateToLogin?.call();
  }

  void navigateToFavorites() {
    onNavigateToFavorites?.call();
  }

  bool get isInitialized => _initialized;
}