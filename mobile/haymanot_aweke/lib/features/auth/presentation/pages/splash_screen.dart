import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/sign-up');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/back.png', fit: BoxFit.cover),
          Container(color: Color(0xFF3F51F3)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  // ignore: prefer_const_constructors
                  child: Center(
                    child: const Text(
                      'ECOM',
                      style: TextStyle(
                        fontFamily: 'CaveatBrush',
                        fontSize: 112,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3F51F3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'ECOMMERCE APP',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                
              ],
            ),
          ),
        ],
      ),
    );
  }
}