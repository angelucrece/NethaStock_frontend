import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nethastock/screens/Connexion1.dart';
import 'package:nethastock/screens/Inscription1.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        iconTheme: const IconThemeData(
          color: Colors.blue,
          size: 24,
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyMedium: const TextStyle(fontSize: 16),
          titleMedium: const TextStyle(fontSize: 18),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

      ),

      home:BeautifulInscriptionScreen(),
      // routes: {
      //   '/connexion': (context) => ConnexionScreen(),
      //   '/inscription': (context) =>  InscriptionScreen(),
      // },
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'screens/onboarding_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'StockMaster Pro',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF0D47A1),
//         colorScheme: const ColorScheme.light(
//           primary: Color(0xFF0D47A1),
//           secondary: Color(0xFF1565C0),
//           surface: Color(0xFFF5F9FF),
//           background: Color(0xFFF5F9FF),
//         ),
//         fontFamily: 'Inter',
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0D47A1),
//             height: 1.2,
//           ),
//           bodyLarge: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.w400,
//             color: Color(0xFF37474F),
//             height: 1.6,
//           ),
//           labelLarge: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       home: const OnboardingScreen(),
//     );
//   }
// }