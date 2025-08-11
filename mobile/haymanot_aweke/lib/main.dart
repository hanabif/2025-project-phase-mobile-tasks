import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/socket/socket_Service.dart';
import 'features/auth/presentation/bloc/signin_bloc/signin_bloc.dart';
import 'features/auth/presentation/bloc/signup_bloc/signup_bloc.dart';

import 'features/product/presentation/bloc/product_bloc.dart';
import 'injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Before di.init: ${di.sl.isRegistered<SocketService>()}');
  await di.init();
  print('After di.init: ${di.sl.isRegistered<SocketService>()}');
  

  print('GetIt instance hashCode: ${GetIt.instance.hashCode}');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(create: (_) => di.sl<ProductBloc>()),
        BlocProvider<SigninBloc>(create: (_) => di.sl<SigninBloc>()),
        BlocProvider<SignupBloc>(create: (_) => di.sl<SignupBloc>()),
      ],
      child: MaterialApp(
        title: 'eCommerce UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
          primarySwatch: const MaterialColor(0xFF2196F3, {
            50: Color(0xFFE3F2FD),
            100: Color(0xFFBBDEFB),
            200: Color(0xFF90CAF9),
            300: Color(0xFF64B5F6),
            400: Color(0xFF42A5F5),
            500: Color(0xFF2196F3),
            600: Color(0xFF1E88E5),
            700: Color(0xFF1976D2),
            800: Color(0xFF1565C0),
            900: Color(0xFF0D47A1),
          }),
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
