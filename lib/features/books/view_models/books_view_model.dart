import '../../../core/base/base_viewmodel.dart';
import '../../../features/books/services/book_service.dart';
import '../../../models/book.dart';
import '../../../services/storage_service.dart';

class BooksViewModel extends BaseViewModel {
  final BookService bookService;
  final StorageService storage;
  List<Book> books = [];
  List<Book> favorites = [];
  int currentPage = 1;
  bool hasNextPage = true;
  bool hasPrevPage = false;

  BooksViewModel({
    BookService? bookService,
    StorageService? storage,
  })  : bookService = bookService ?? BookService(),
        storage = storage ?? StorageService() {
    loadFavorites();
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
    if (hasNextPage) {
      loadBooks(page: currentPage + 1);
    }
  }

  void prevPage() {
    if (hasPrevPage) {
      loadBooks(page: currentPage - 1);
    }
  }

  Future<void> loadFavorites() async {
    final favBooks = await storage.getFavoriteBooks();
    favorites = favBooks;
    notifyListeners();
  }

  Future<void> toggleFavorite(Book book) async {
    final isFav = isFavorite(book);

    if (isFav) {
      favorites.removeWhere((b) => b.slug == book.slug);
    } else {
      if (!favorites.any((b) => b.slug == book.slug)) {
        favorites.add(book);
      }
    }

    await storage.saveFavoriteBooks(favorites);
    notifyListeners();
  }

  bool isFavorite(Book book) {
    return favorites.any((b) => b.slug == book.slug);
  }
}