

import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    final width =  MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(
              //   'images/A.png',
              //   width: size.width * 0.4,
              // ),

              Text(
                "Gérez votre stock en toute simplicité",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  
                ),),
              Text(
                  "Suivi en temps réel, alertes intelligentes et rapports détaillés",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20.0,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
