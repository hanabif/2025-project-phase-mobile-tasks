// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int selectedSize = 41;

  void goBackToHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  void goToUpdateProductPage(BuildContext context, Product product) async {
    final updatedProduct = await Navigator.pushNamed<Product>(
      context,
      '/update',
      arguments: product,
    );

    if (updatedProduct != null) {
      // Return updated product to HomePage
      // ignore: use_build_context_synchronously
      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => goBackToHomePage(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF3F51F3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Product image
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // ✅ Load from network if URL is online, else fallback to asset
                    image:
                        product.imageUrl.startsWith('http')
                            ? NetworkImage(product.imageUrl)
                            : AssetImage(product.imageUrl) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category and rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Luxury Heels',
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
                      SizedBox(width: 4),
                      Text(
                        '(4.0)',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Size label
              const Text(
                'Size:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),

              // Size chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      ([39, 40, 41, 42, 43]).map((size) {
                        final isSelected = size == selectedSize;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => selectedSize = size);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF3F51F3)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                size.toString(),
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Description
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'action': 'delete',
                          'productName': product.name,
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('DELETE'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => goToUpdateProductPage(context, product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D5CFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('UPDATE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
