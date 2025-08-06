import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'injection_container.dart' as di;
import 'dart:developer' as developer;
import 'dart:ui';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log('Flutter Error: ${details.exception}, stack: ${details.stack}', error: details.exception);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    developer.log('Platform Error: $error, stack: $stack');
    return true; // Prevent the error from being handled elsewhere
  };
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final productBloc = di.sl<ProductBloc>();
            if (productBloc == null) {
              throw Exception('ProductBloc is not registered');
            }
            return productBloc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'eCommerce UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
          primarySwatch: const MaterialColor(0xFF3F51F3, {
            50: Color(0xFFE8EAFD), 
            100: Color(0xFFC5C8FA),
            200: Color(0xFF9CA2F7),
            300: Color(0xFF737CF4),
            400: Color(0xFF4F5BF1),
            500: Color(0xFF3F51F3), // Primary color
            600: Color(0xFF3748DB),
            700: Color(0xFF2F3EC3),
            800: Color(0xFF2735AA),
            900: Color(0xFF1F2B92),
          }),
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}