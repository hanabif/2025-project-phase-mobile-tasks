// lib/features/product/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/product_local_data_source.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/model/Product_model.dart';
import '../../domain/entities/product.dart';
import '../widgets/home_header.dart';
import '../widgets/home_title.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductRemoteDataSource remoteDataSource;
  ProductLocalDataSource? localDataSource;

  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    remoteDataSource = ProductRemoteDataSourceImpl(client: http.Client());
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      // Fetch from API
      final fetchedProducts = await remoteDataSource.getAllProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });

      // Cache products locally if localDataSource is available
      if (localDataSource != null) {
        await localDataSource!.cacheProductList(fetchedProducts);
      }
    } catch (e) {
      setState(() => isLoading = false);

      // Fallback to local cache if available
      try {
        if (localDataSource != null) {
          final cached = await localDataSource!.getLastProductList();
          setState(() => products = cached);
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load products')),
        );
      }
    }
  }

  void _goToAddProductPage() async {
    final result = await Navigator.pushNamed<ProductModel>(context, '/add');
    if (result != null) {
      setState(() => products.add(result));
      if (localDataSource != null) {
        await localDataSource!.cacheProduct(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProductPage,
        backgroundColor: const Color(0xFF3F51F3),
        child: const Icon(Icons.add, size: 36, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(userName: 'Yohannes', dateText: 'July 14, 2023'),
              const SizedBox(height: 38),
              const HomeTitle(),
              const SizedBox(height: 22),
              Expanded(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                          itemCount: products.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/details",
                                  arguments: product,
                                );
                              },
                              child: ProductCard(
                                product: Product(
                                  id: product.id,
                                  name: product.name,
                                  description: product.description,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
