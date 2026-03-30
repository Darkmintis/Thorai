import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/book_card.dart';
import 'books_view_model.dart';
import '../../core/services/storage_service.dart';
import '../login/login_screen.dart';
import '../favorite/favorites_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  void initState() {
    super.initState();
    // Load books when screen is first shown
    Future.microtask(() {
      if (mounted) {
        context.read<BooksViewModel>().loadBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksViewModel>(
      builder: (context, vm, _) => Scaffold(
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final storage = StorageService();
                await storage.clearToken();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
        body: vm.loading && vm.books.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : vm.error != null && vm.books.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(vm.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => vm.loadBooks(),
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
                          itemCount: vm.books.length,
                          itemBuilder: (context, index) {
                            final book = vm.books[index];
                            return BookCard(
                              key: ValueKey('book_${book.slug}_${index}'),
                              book: book,
                              isFavorite: vm.isFavorite(book),
                              onFavoriteToggle: () {
                                vm.toggleFavorite(book);
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
                                onPressed: vm.hasPrevPage && !vm.loading ? () => vm.prevPage() : null,
                                child: const Text('Previous'),
                              ),
                              const SizedBox(width: 20),
                              Text('Page ${vm.currentPage}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: vm.hasNextPage && !vm.loading ? () => vm.nextPage() : null,
                                child: const Text('Next'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}