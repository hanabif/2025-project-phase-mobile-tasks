import 'package:flutter/material.dart';
import 'package:haymanot_aweke/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 366,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ), // Rounded corners for the entire card
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              product.imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Info section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xFF3E3E3E),
                    ),
                  ),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_rate, color: Color(0xFFFFD700), size: 20),
                      Text("(4.0)",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
