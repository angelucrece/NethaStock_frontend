

import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    final width =  MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Image.asset(
          'assets/images/logo.jpg',
          width: size.width * 0.4,
          // fit: BoxFit.cover,
        ),
      ),
    );
  }
}
