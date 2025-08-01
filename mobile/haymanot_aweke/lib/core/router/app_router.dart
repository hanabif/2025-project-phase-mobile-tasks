import 'package:flutter/material.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/product/presentation/pages/add_update_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/search_page.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeTransition(const HomePage());

      case '/details':
        final product = settings.arguments as Product;
        return _slideTransition(DetailPage(product: product));

      case '/add':
        final product = settings.arguments as Product?;
        return _scaleFadeTransition(AddUpdatePage(product: product));

      case '/search':
        final results = settings.arguments as List<Product>? ?? [];
        return _slideTransition(SearchPage(searchResults: results));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Fade Transition
  static PageRouteBuilder _fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Slide Transition (from right)
  static PageRouteBuilder _slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Scale + Fade Transition
  static PageRouteBuilder _scaleFadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final scaleAnimation = Tween<double>(
          begin: 0.95,
          end: 1.0,
        ).animate(animation);
        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
