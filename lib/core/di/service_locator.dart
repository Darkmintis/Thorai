import 'package:get_it/get_it.dart';
import '../services/storage_service.dart';
import '../services/navigation_service.dart';
import '../network/dio_client.dart';
import '../../views/book/books_view_model.dart';
import '../../shared/services/favorite_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton<DioClient>(() => DioClient());

  locator.registerLazySingleton<StorageService>(() => StorageService());
  locator.registerLazySingleton<NavigationService>(() => NavigationService());

  locator.registerLazySingleton<FavoriteService>(() => FavoriteService(locator<StorageService>()));

  locator.registerFactory<BooksViewModel>(
    () => BooksViewModel(
    storage: locator<StorageService>(),
    ),
    );
}