import '../../core/base/base_viewmodel.dart';
import 'models/book_service.dart';
import 'models/book.dart';
import '../../core/services/storage_service.dart';

class BooksViewModel extends BaseViewModel {
  final BookService bookService;
  final StorageService storage;
  List<Book> books = [];
  int currentPage = 1;
  bool hasNextPage = true;
  bool hasPrevPage = false;
  bool _initialized = false;

  BooksViewModel({
    BookService? bookService,
    StorageService? storage,
  })  : bookService = bookService ?? BookService(),
        storage = storage ?? StorageService();

  void init() {
    if (!_initialized) {
      _initialized = true;
      loadBooks();
    }
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
}