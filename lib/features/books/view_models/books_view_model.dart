import '../../../core/base/base_viewmodel.dart';
import '../../../features/books/services/book_service.dart';
import '../../../models/book.dart';
import '../../../services/storage_service.dart';

class BooksViewModel extends BaseViewModel {
  final BookService bookService;
  final StorageService storage;
  List<Book> books = [];

  BooksViewModel({
    BookService? bookService,
    StorageService? storage,
  })  : bookService = bookService ?? BookService(),
        storage = storage ?? StorageService();

  Future<void> loadBooks() async {
    setLoading(true);
    clearError();

    try {
      final token = await storage.getToken();
      books = await bookService.fetchBooks(token);
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}