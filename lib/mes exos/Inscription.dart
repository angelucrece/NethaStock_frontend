

//
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Formulaire Flutter',
//       home: Connexion(),
//     );
//   }
// }
//
// class Connexion extends StatefulWidget {
//   @override
//   _MyFormState createState() => _MyFormState();
// }
//
// class _MyFormState extends State<Connexion> {
//   final _formKey = GlobalKey<FormState>();
//
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   String? _selectedGender;
//   bool _acceptTerms = false;
//
//   @override MediaQuery.of(context).size.width;
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width =
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: const EdgeInsets.only(
//             top: 40.0,
//             left: 20.0,
//             right: 20.0,
//             bottom: 20.0,
//           ),
//           child: Text('Connexion',
//             style: TextStyle(color: Colors.blue,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//               fontSize: 30.0,
//             ),
//
//           ),
//         ),
//
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Image.asset(
//                 'images/photo.png',
//                 width: width/4,  // Largeur optionnelle
//                 height: height/2, // Hauteur optionnelle
//                 fit: BoxFit.cover, // Redimensionnement (cover, contain, fill, etc.)
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 20.0),
//                 child: TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Nom complet',
//                     prefixIcon: Icon(Icons.person),
//                     enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                     ),
//                     focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: BorderSide(color: Colors.blueAccent, width: 3.0),
//                     ),
//                     errorBorder: OutlineInputBorder( // Bordure en cas d'erreur
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: BorderSide(color: Colors.red, width: 2.0),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder( // Bordure d'erreur quand le champ est sélectionné
//                       borderRadius: BorderRadius.circular(15.0),
//                       borderSide: BorderSide(color: Colors.deepOrange, width: 3.0),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre nom';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller:  _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                   enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(color: Colors.blueAccent, width: 3.0),
//                   ),
//                   errorBorder: OutlineInputBorder( // Bordure en cas d'erreur
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(color: Colors.red, width: 2.0),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder( // Bordure d'erreur quand le champ est sélectionné
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(color: Colors.deepOrange, width: 3.0),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer votre email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                     return 'Email invalide';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.end,
//               //   children: [
//               //     Text('Mot de passe oublie?'),
//               //   ],
//               // ),
//               // DropdownButtonFormField<String>(
//               //   value: _selectedGender,
//               //   hint: Text('Sélectionnez votre genre'),
//               //   items: ['Masculin', 'Féminin', 'Autre']
//               //       .map((gender) => DropdownMenuItem(
//               //     value: gender,
//               //     child: Text(gender),
//               //   ))
//               //       .toList(),
//               //   onChanged: (value) {
//               //     setState(() {
//               //       _selectedGender = value;
//               //     });
//               //   },
//               //   validator: (value) {
//               //     if (value == null) {
//               //       return 'Veuillez sélectionner un genre';
//               //     }
//               //     return null;
//               //   },
//               // ),
//               // SizedBox(height: 16),
//               // CheckboxListTile(
//               //   title: Text('J\'accepte les termes et conditions'),
//               //   value: _acceptTerms,
//               //   onChanged: (value) {
//               //     setState(() {
//               //       _acceptTerms = value ?? false;
//               //     });
//               //   },
//               //   controlAffinity: ListTileControlAffinity.leading,
//               // ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 // onPressed: _submitForm,
//                 // onPressed: (onHover),
//                 child: Text('Connexion',style: TextStyle(color: Colors.white),),
//                 style: ElevatedButton.styleFrom(
//                   // padding: EdgeInsets.symmetric(vertical: 5),
//                   maximumSize: Size(100, 100),
//                   backgroundColor: Colors.blue,
//                 ),
//                 onPressed: () {  },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
// return MaterialApp(
// debugShowCheckedModeBanner: false,
// title: 'Flutter Demo',
// theme: ThemeData(
// primarySwatch: Colors.blue,
// fontFamily: 'Roboto',
// iconTheme: const IconThemeData(
// color: Colors.blue,
// size: 24,
// ),
// textTheme: GoogleFonts.robotoTextTheme(
// Theme.of(context).textTheme,
// ).copyWith(
// bodyMedium: const TextStyle(fontSize: 16),
// titleMedium: const TextStyle(fontSize: 18),
// ),
// inputDecorationTheme: InputDecorationTheme(
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12.0),
// borderSide: const BorderSide(color: Colors.blue, width: 1.5),
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12.0),
// borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
// ),
// errorBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12.0),
// borderSide: const BorderSide(color: Colors.red, width: 1.5),
// ),
// focusedErrorBorder: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12.0),
// borderSide: const BorderSide(color: Colors.deepOrange, width: 2.0),
// ),
// contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
// floatingLabelBehavior: FloatingLabelBehavior.auto,
// ),
// elevatedButtonTheme: ElevatedButtonThemeData(
// style: ElevatedButton.styleFrom(
// padding: const EdgeInsets.symmetric(vertical: 18),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// backgroundColor: Colors.blue,
// textStyle: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// ),
// ),
//
// ),
//
// home:InscriptionScreen(),
// routes: {
// '/connexion': (context) => ConnexionScreen(),
// '/inscription': (context) =>  InscriptionScreen(),
// },
// );