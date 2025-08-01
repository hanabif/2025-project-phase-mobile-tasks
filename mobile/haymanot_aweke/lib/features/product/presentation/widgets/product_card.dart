import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/styles/text_styles.dart';
import '../../domain/entities/product.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.productCardHeight,
      width: AppConstants.productCardWidth,
      decoration: BoxDecoration(
        borderRadius: AppConstants.defaultBorderRadius,
        boxShadow: AppConstants.defaultShadow,
      ),
      child: Column(
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.cardBorderRadius),
              topRight: Radius.circular(AppConstants.cardBorderRadius),
            ),
            child: Image.network(
              product.imageUrl,
              height: AppConstants.productImageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.all(AppConstants.smallPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(product.name, style: AppTextStyles.title),
                    Text('Luxury Heels'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.price,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rate,
                          color: AppConstants.starColor,
                          size: 20,
                        ),
                        Text("(4.0)", style: AppTextStyles.rating),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
