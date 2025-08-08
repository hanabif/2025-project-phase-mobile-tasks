import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/signin_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/chat/presentation/pages/chat_detail.dart';
import '../../features/chat/presentation/pages/recent_chats.dart';
import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/add_update_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/retrieve_all_products_page.dart';
import '../../features/product/presentation/pages/search_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --- AUTH SCREENS ---
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/sign-up':
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case '/sign-in':
        return MaterialPageRoute(builder: (_) => SigninPage());

      // -- CHAT SCREENS ---
      case '/chat':
        return MaterialPageRoute(builder: (_) => RecentChats());

      case '/chatDetail':
        return MaterialPageRoute(builder: (_) => ChatDetailPage());

      // --- PRODUCT SCREENS ---
      case '/retrieve':
        return MaterialPageRoute(builder: (_) => RetrieveAllProductsPage());

      
      case '/create':
        return MaterialPageRoute(builder: (_) => AddUpdatePage(isEditing: false,));

      case '/details':
        final product = settings.arguments as Product;
        return MaterialPageRoute(builder: (_) => DetailPage(product: product));

      case '/add':
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder:
              (_) =>
                  AddUpdatePage(product: product, isEditing: product != null),
        );

      case '/search':
        final results = settings.arguments as List<Product>? ?? [];
        return MaterialPageRoute(
          builder: (_) => SearchPage(searchResults: results),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
