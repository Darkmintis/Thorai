import '../../core/base/base_viewmodel.dart';
import '../../shared/models/book.dart';
import '../../core/services/storage_service.dart';

class FavoritesViewModel extends BaseViewModel {
  final StorageService storage;
  List<Book> favorites = [];

  FavoritesViewModel({
    StorageService? storage,
  }) : storage = storage ?? StorageService() {
    loadFavorites();
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