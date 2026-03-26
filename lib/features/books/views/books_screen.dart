import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/book_card.dart';
import '../view_models/books_view_model.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BooksViewModel>(
      create: (_) => BooksViewModel()..loadBooks(),
      child: Consumer<BooksViewModel>(
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
                icon: const Icon(Icons.refresh),
                onPressed: vm.loadBooks,
              ),
            ],
          ),
          body: vm.loading
              ? const Center(child: CircularProgressIndicator())
              : vm.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(vm.error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: vm.loadBooks,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: vm.books.length,
                      itemBuilder: (context, index) => BookCard(book: vm.books[index]),
                    ),
        ),
      ),
    );
  }
}