import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCommerce UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        primarySwatch: const MaterialColor(0xFF2196F3, {
          50: Color(0xFFE8E9FD),
          100: Color(0xFFC1C4FA),
          200: Color(0xFF969BF7),
          300: Color(0xFF6D72F4),
          400: Color(0xFF4E56F2),
          500: Color(0xFF3F51F3),
          600: Color(0xFF3848EA),
          700: Color(0xFF2D3BCC),
          800: Color(0xFF252F9E),
          900: Color(0xFF1B2171),
        }),
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
