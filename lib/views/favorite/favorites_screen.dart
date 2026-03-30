import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../book/widget/book_card.dart';
import '../book/books_view_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Books',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 78, 132),
        foregroundColor: Colors.white,
      ),
      body: Consumer<BooksViewModel>(
        builder: (context, vm, _) => vm.favorites.isEmpty
            ? const Center(
                child: Text(
                  'No favorite books yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
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
                      itemCount: vm.favorites.length,
                      itemBuilder: (context, index) {
                        final book = vm.favorites[index];
                        return BookCard(
                          key: ValueKey('fav_${book.slug}_$index'),
                          book: book,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            vm.toggleFavorite(book);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}