import 'package:flutter/material.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/add_update_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/retrieve_all_products_page.dart';
import '../../features/product/presentation/pages/search_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const RetrieveAllProductsPage());

      case '/details':
        final product = settings.arguments as Product;
        return MaterialPageRoute(builder: (_) => DetailPage(product: product));

      case '/add':
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder: (_) => AddUpdatePage(
            product: product,
            isEditing: product != null,
          ),
        );

      case '/search':
        final results = settings.arguments as List<Product>? ?? [];
        return MaterialPageRoute(builder: (_) => SearchPage(searchResults: results));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
