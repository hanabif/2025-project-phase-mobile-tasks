// lib/features/product/presentation/widgets/home_header.dart
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String dateText;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Color(0xFFCCCCCC),
          ),
        ),
        SizedBox(width: 13),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFAAAAAA),
                fontWeight: FontWeight.w500,
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Hello, ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFDDDDDD), width: 1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.notifications_active_outlined),
            ),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF3F51F3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
