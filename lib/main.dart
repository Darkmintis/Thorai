import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/services/navigation_service.dart';
import 'core/constants/app_routes.dart';
import 'shared/services/favorite_service.dart';
import 'views/book/books_screen.dart';
import 'views/favorite/favorites_screen.dart';
import 'views/login/login_screen.dart';
import 'views/book/books_view_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: locator<NavigationService>()),
        ChangeNotifierProvider.value(value: locator<FavoriteService>()),

        ChangeNotifierProvider(create: (_) => locator<BooksViewModel>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thorai Books',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        navigatorKey: locator<NavigationService>().navigatorKey,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.books: (_) => const BooksScreen(),
          AppRoutes.favorites: (_) => const FavoritesScreen(),
        },
      ),
    );
  }
}