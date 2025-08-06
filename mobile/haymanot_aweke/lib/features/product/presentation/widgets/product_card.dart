// ignore_for_file: prefer_const_constructors, prefer_single_quotes, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/styles/text_styles.dart';
import '../../domain/entities/product.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap ?? () {
        Navigator.pushNamed(context, '/details', arguments: product);
      },
      child: Container(
        height: AppConstants.productCardHeight,
        width: AppConstants.productCardWidth,
        decoration: const BoxDecoration(
          borderRadius:  AppConstants.defaultBorderRadius,
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
      ),
    );
  }
}
