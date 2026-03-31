import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/book_card.dart';
import '../../shared/services/favorite_service.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/navigation_service.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            locator<NavigationService>().goBack();
          },
        ),
      ),
      body: Consumer<FavoriteService>(
        builder: (context, favoriteService, _){
         if (favoriteService.favorites.isEmpty){
          return const Center(
            child: Text(
              'No favorite books yet',
              style: TextStyle(fontSize: 18, color: Colors.grey ),
            ),
          );
         }

         return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: favoriteService.favorites.length,
                      itemBuilder: (context, index) {
                        final book = favoriteService.favorites[index];
                        return BookCard(
                          key: ValueKey('fav_${book.slug}_$index'),
                          book: book,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            favoriteService.toggleFavorite(book);
                          },
                        );
                      },
                    );
        },
      ),
    );
  }
}