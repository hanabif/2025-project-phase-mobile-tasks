// lib/features/product/presentation/widgets/home_title.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Available Products",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E3E3E),
          ),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          height: 40,
          width: 40,
          padding: EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            icon: Icon(Icons.search_outlined, size: 24),
          ),
        ),
      ],
    );
  }
}
