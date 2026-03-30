import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';

final GetIt getIt = GetIt.instance;

void setupLocator(){
  getIt.registerLazySingleton<DioClient>(() => DioClient());
}