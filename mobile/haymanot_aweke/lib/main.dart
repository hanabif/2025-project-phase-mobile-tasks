import 'package:flutter/material.dart';
import 'package:haymanot_aweke/models/product.dart';
import 'pages/home_page.dart';
import 'pages/detail_page.dart';
import 'pages/add_update_page.dart';
import 'pages/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCommerce UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        primarySwatch: MaterialColor(0xFF2196F3, <int, Color>{
          50: Color(0xFFE8E9FD),
          100: Color(0xFFC1C4FA),
          200: Color(0xFF969BF7),
          300: Color(0xFF6D72F4),
          400: Color(0xFF4E56F2),
          500: Color(0xFF3F51F3), // your main color
          600: Color(0xFF3848EA),
          700: Color(0xFF2D3BCC),
          800: Color(0xFF252F9E),
          900: Color(0xFF1B2171),
        }),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;

          
          if (args is Product) {
            return DetailPage(product: args);
          } else {
            return Scaffold(
              body: Center(child: Text('No product found or passed.')),
            );
          }
        },
        '/add': (context) => AddUpdatePage(),
        '/search': (context) => SearchPage(searchResults: []),
      },
    );
  }
}
