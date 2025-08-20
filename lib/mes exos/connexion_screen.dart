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
//   bool _isSecret = true;
//   String _password = '';
//
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   String? _selectedGender;
//   bool _acceptTerms = false;
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
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
//         padding: const EdgeInsets.all(0.0),
//
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Image.asset(
//                 'images/photo.png',
//                 width: width/2,  // Largeur optionnelle
//                 height: height/2, // Hauteur optionnelle
//                 fit: BoxFit.fitWidth, // Redimensionnement (cover, contain, fill, etc.)
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
//               TextFormField(
//                 keyboardType: TextInputType.emailAddress,
//                 onChanged: (value) => setState(() => _password = value),
//                 validator: (value) {
//                   // 1. Vérifiez si la valeur est null ou vide
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer un mot de passe.'; // Un message spécifique pour un champ vide
//                   }
//                   // 2. Maintenant que nous savons que 'value' n'est pas null, nous pouvons vérifier sa longueur en toute sécurité
//                   if (value.length < 6) {
//                     return 'Le mot de passe doit contenir au moins 6 caractères.';
//                   }
//                   // 3. Si toutes les vérifications passent, retournez null (pas d'erreur)
//                   return null;
//                 },
//                 // onSaved: (value) {
//                 //   _password = value!; // Assignez la valeur (non-null) à votre variable _email
//                 // },
//                 obscureText: _isSecret,
//                 decoration: InputDecoration(
//                   labelText: 'Nom complet',
//                   prefixIcon: Icon(Icons.lock),
//                   suffixIcon: InkWell(
//                     onTap: () => setState(() => _isSecret = !_isSecret ),
//                     child: Icon(
//                         !_isSecret
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                   ),
//                   //hintText: 'Ex: gh!D4Yhd',
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
//                   ),),
//               ),
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text('Mot de passe oublie?',style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
//                 ],
//               ),
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