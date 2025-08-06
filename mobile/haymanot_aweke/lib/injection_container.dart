// ignore_for_file: depend_on_referenced_packages

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/domain/usecases/view_product_by_id_usecase.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features – Product
  //bloc
  if (sl.isRegistered<ProductBloc>()) {
    sl.unregister<ProductBloc>();
  }
  sl.registerFactory(
    () => ProductBloc(
      createProduct: sl(),
      deleteProduct: sl(),
      updateProduct: sl(),
      viewProduct: sl(),
      viewSingleProduct: sl(),
      inputConverter: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => ViewProductByIdUsecase(sl()));
  sl.registerLazySingleton(() => ViewProductUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  final baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com';

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: http.Client(), baseUrl: baseUrl),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //!core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
}
