// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nethastock/screens/Connexion1.dart';
// import 'package:nethastock/screens/Connexion2.dart';
// import 'package:nethastock/screens/Dashboard.dart';
// import 'package:nethastock/screens/Inscription1.dart';
// import 'package:nethastock/screens/Produits.dart';
// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Roboto',
//         iconTheme: const IconThemeData(
//           color: Colors.blue,
//           size: 24,
//         ),
//         textTheme: GoogleFonts.robotoTextTheme(
//           Theme.of(context).textTheme,
//         ).copyWith(
//           bodyMedium: const TextStyle(fontSize: 16),
//           titleMedium: const TextStyle(fontSize: 18),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(color: Colors.red, width: 1.5),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.0),
//             borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
//           ),
//           contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             backgroundColor: Colors.blue,
//             textStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//
//       ),
//
//       home:StockDashboardApp(),
//       // routes: {
//       //   '/connexion': (context) => ConnexionScreen(),
//       //   '/inscription': (context) =>  InscriptionScreen(),
//       // },
//     );
//   }
// }
//
//
// //
// // import 'package:flutter/material.dart';
// // import 'screens/onboarding_screen.dart';
// //
// // void main() {
// //   runApp(const MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'StockMaster Pro',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         primaryColor: const Color(0xFF0D47A1),
// //         colorScheme: const ColorScheme.light(
// //           primary: Color(0xFF0D47A1),
// //           secondary: Color(0xFF1565C0),
// //           surface: Color(0xFFF5F9FF),
// //           background: Color(0xFFF5F9FF),
// //         ),
// //         fontFamily: 'Inter',
// //         textTheme: const TextTheme(
// //           displayLarge: TextStyle(
// //             fontSize: 32,
// //             fontWeight: FontWeight.w700,
// //             color: Color(0xFF0D47A1),
// //             height: 1.2,
// //           ),
// //           bodyLarge: TextStyle(
// //             fontSize: 17,
// //             fontWeight: FontWeight.w400,
// //             color: Color(0xFF37474F),
// //             height: 1.6,
// //           ),
// //           labelLarge: TextStyle(
// //             fontSize: 16,
// //             fontWeight: FontWeight.w600,
// //             color: Colors.white,
// //           ),
// //         ),
// //       ),
// //       home: const OnboardingScreen(),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:nethastock/screens/login_screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
// import 'providers/product_provider.dart';
// import 'providers/movement_provider.dart';
// import 'providers/category_provider.dart';
// // import 'screens/login_screen.dart';
// import 'screens/dashboard_screen.dart';
// import 'utils/theme.dart';
//
// void main() {
//   // Point d'entrée principal de l'application Flutter
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Utilisation de MultiProvider pour fournir tous les providers à l'application
//     return MultiProvider(
//       providers: [
//         // Provider pour la gestion de l'authentification
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//
//         // Provider pour la gestion des produits
//         ChangeNotifierProvider(create: (_) => ProductProvider()),
//
//         // Provider pour la gestion des mouvements de stock
//         ChangeNotifierProvider(create: (_) => MovementProvider()),
//
//         // Provider pour la gestion des catégories
//         ChangeNotifierProvider(create: (_) => CategoryProvider()),
//       ],
//       child: MaterialApp(
//         title: 'NethaStock',
//         debugShowCheckedModeBanner: false, // Désactive la bannière de debug
//         theme: AppTheme.lightTheme, // Thème clair de l'application
//         darkTheme: AppTheme.darkTheme, // Thème sombre de l'application
//         home: Consumer<AuthProvider>(
//           builder: (context, auth, child) {
//             // Affiche le dashboard si l'utilisateur est authentifié, sinon l'écran de login
//             //return auth.isAuthenticated ? DashboardScreen() : LoginScreen();
//             return DashboardScreen();
//           },
//         ),
//         routes: {
//           '/login': (context) => LoginScreen(),
//           '/dashboard': (context) => DashboardScreen(),
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nethastock/screens/movements_screen.dart';
import 'package:nethastock/widgets/image_picker_widget.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/movement_provider.dart';
import 'providers/category_provider.dart';
import 'providers/user_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_magasinier.dart';
import 'screens/dashboard_admin.dart';
import 'utils/theme.dart';
import 'services/notification_service.dart';

void main() async {
  // Initialisation des binding Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation des services
  await NotificationService().initialize();


  // Lancement de l'application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider pour l'authentification et la gestion des utilisateurs
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Provider pour la gestion des produits
        ChangeNotifierProvider(create: (_) => ProductProvider()),

        // Provider pour la gestion des mouvements de stock
        ChangeNotifierProvider(create: (_) => MovementProvider()),

        // Provider pour la gestion des catégories
        ChangeNotifierProvider(create: (_) => CategoryProvider()),

        // Provider pour la gestion des utilisateurs (admin seulement)
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'NethaStock',
        debugShowCheckedModeBanner: false,

        // Thème principal de l'application avec couleurs bleu, orange, vert
        theme: AppTheme.lightTheme,

        // Thème sombre pour le mode nuit
        darkTheme: AppTheme.darkTheme,

        // Gestion de la navigation basée sur l'état d'authentification et le rôle
        // home: Consumer<AuthProvider>(
        //   builder: (context, auth, child) {
        //     if (auth.isAuthenticated) {
        //       // Redirection vers le dashboard approprié selon le rôle
        //       return auth.isAdmin ? DashboardAdminScreen() : DashboardMagasinierScreen();
        //     }
        //     return LoginScreen();
        //   },
        // ),
        home:ImagePickerWidget () ,

        // Routes nommées pour la navigation
        routes: {
          '/login': (context) => LoginScreen(),
          '/dashboard': (context) => Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return auth.isAdmin ? DashboardAdminScreen() : DashboardMagasinierScreen();
            },
          ),
        },
      ),
    );
  }
}