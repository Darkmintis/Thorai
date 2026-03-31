import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/book_card.dart';
import 'books_view_model.dart';
import '../../core/services/navigation_service.dart';
import '../../shared/services/favorite_service.dart';
import '../../core/constants/app_routes.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/storage_service.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BooksViewModel, FavoriteService>(
      builder: (context, booksVm, favoriteService, _) {
        if (!booksVm.isInitialized){

        WidgetsBinding.instance.addPostFrameCallback((_){
          booksVm.init();
        });
        }
        
        return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thorai Books',
            style: TextStyle( 
              fontWeight: FontWeight.bold,
              fontSize: 40,
            )
            ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 12, 78, 132),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: (){
                locator<NavigationService>().navigateTo(AppRoutes.favorites);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async { 
                final storage = locator<StorageService>();
                await storage.clearToken();
                if (context.mounted){
                  locator<NavigationService>().navigateToAndClearStack(AppRoutes.login);
                }
              },
            ),
          ],
        ),
        body: booksVm.loading && booksVm.books.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : booksVm.error != null && booksVm.books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(booksVm.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => booksVm.loadBooks(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: booksVm.books.length,
                          itemBuilder: (context, index) {
                            final book = booksVm.books[index];
                            return BookCard(
                              key: ValueKey('book_${book.slug}_$index'),
                              book: book,
                              isFavorite: favoriteService.isFavorite(book),
                              onFavoriteToggle: () {
                                favoriteService.toggleFavorite(book);
                              },
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: booksVm.hasPrevPage && !booksVm.loading ? () => booksVm.prevPage() : null,
                                child: const Text(
                                  'Previous',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 59, 58, 58),
                                  ),
                                  ),
                              ),
                              const SizedBox(width: 20),
                              Text('Page ${booksVm.currentPage}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: booksVm.hasNextPage && !booksVm.loading ? () => booksVm.nextPage() : null,
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 34, 33, 33),
                                  ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}