// ignore_for_file: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/socket/socket_service.dart';
import 'core/util/input_converter.dart';

//chat
import 'features/auth/data/datasource/user_local_datasource.dart';
import 'features/auth/data/datasource/user_remote_datasource.dart';
import 'features/auth/data/repository/siginin_repository.dart';
import 'features/auth/data/repository/signup_repository_impl.dart';
import 'features/auth/domain/repositories/signin_repository.dart';
import 'features/auth/domain/repositories/signup_repositroy.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/signup.dart';
import 'features/auth/presentation/bloc/signin_bloc/signin_bloc.dart';
import 'features/auth/presentation/bloc/signup_bloc/signup_bloc.dart';

import 'features/chat/data/datasource/chat_api_service.dart';
import 'features/chat/data/repository/chat_repository_impl.dart';
import 'features/chat/domain/repository/chat_repository.dart';

import 'features/chat/domain/usecase/create_chat.dart';
import 'features/chat/domain/usecase/get_all_users.dart';
import 'features/chat/domain/usecase/get_chat_messages.dart';
import 'features/chat/domain/usecase/get_my_chat.dart';
import 'features/chat/domain/usecase/send_message.dart';

// PRODUCT
import 'features/chat/presentation/bloc/chat_bloc.dart';
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
  print('Starting DI init...');

  print('GetIt instance hashCode: ${GetIt.instance.hashCode}');

  //! -------------------------
  //! EXTERNAL
  //! -------------------------
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  sl.registerLazySingleton<DioClient>(() => DioClient());


  print(
    'Before registering SocketService: ${sl.isRegistered<SocketService>()}',
  );
  sl.registerLazySingleton<SocketService>(() => SocketServiceImpl());
  print('After registering SocketService: ${sl.isRegistered<SocketService>()}');

  //! -------------------------
  //! PRODUCT FEATURE
  //! -------------------------
  // Bloc
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

  // Use cases
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
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! -------------------------
  //! CHAT FEATURE
  //! -------------------------
  // ChatBloc
  sl.registerFactory(
    () => ChatBloc(
      getChats: sl(),
      getMessages: sl(),
      sendMessage: sl(),
      createChat: sl(),
      getAllChats: sl(),
      getAllUsers: sl(),
      getChatById: sl(),
      getMessagesInChat: sl(),
      messageStream: sl(),
      socketService: sl(),
      userLocalDatasource: sl(),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ChatApiService>(() => ChatApiServiceImpl());
  // Use cases
  sl.registerLazySingleton(() => CreateChatWithUserUsecase(sl()));
  sl.registerLazySingleton(() => GetMyChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetChatMessagesUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () =>
        ChatRepositoryImpl(api: sl(), socket: sl(), userLocalDatasource: sl()),
  );

  //! -------------------------
  //! CORE
  //! -------------------------
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl<InternetConnectionChecker>()),
  );

  // if (sl.isRegistered<SocketService>()) {
  //   sl.unregister<SocketService>();
  // }

  //! -------------------------
  //! AUTH FEATURE
  //! -------------------------
  //usecases
  sl.registerLazySingleton(
    () => SigninUsecase(signinRepository: sl<SigninRepository>()),
  );
  sl.registerLazySingleton(() => SignupUsecase(sl<SignupRepository>()));

  //bloc
  sl.registerFactory(() => SigninBloc(signinUsecase: sl<SigninUsecase>()));
  sl.registerFactory(() => SignupBloc(signupUsecase: sl<SignupUsecase>()));

  //repository
  sl.registerLazySingleton<SigninRepository>(
    () => SigninRepositoryImpl(
      userLocalDatasource: sl(),
      userRemoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<SignupRepository>(
    () => SignupRepositoryImpl(networkInfo: sl(), userRemoteDatasource: sl()),
  );

  //datasources
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasourceImpl(client: sl()),
  );
  sl.registerLazySingleton<UserLocalDatasource>(
    () => UserLocalDatasourceImpl(sharedPreferences: sl(), client: sl()),
  );
}
