// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/custom_text_field.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
//   final _emailController = TextEditingController(); // Controller pour le champ email
//   final _passwordController = TextEditingController(); // Controller pour le champ mot de passe
//   bool _isLoading = false; // État de chargement
//
//   // Méthode pour gérer la soumission du formulaire
//   Future<void> _submitForm() async {
//     // Valide le formulaire
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true); // Active l'état de chargement
//
//     try {
//       // Tente de se connecter via le AuthProvider
//       await Provider.of<AuthProvider>(context, listen: false).login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//       // La navigation est gérée automatiquement par le Consumer dans main.dart
//     } catch (error) {
//       // Affiche une erreur en cas d'échec
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Erreur de connexion: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       // Désactive l'état de chargement dans tous les cas
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size; // Taille de l'écran
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: size.height,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.blue.shade700, Colors.blue.shade300], // Dégradé bleu
//             ),
//           ),
//           child: Center(
//             child: Container(
//               width: size.width > 600 ? 500 : size.width * 0.9, // Responsive width
//               padding: EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Logo et titre
//                     Image.asset(
//                       'assets/images/logo.jpg',
//                       height: 100,
//                       width: 100,
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'NethaStock',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue.shade700,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Gestion de Stocks',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     SizedBox(height: 32),
//
//                     // Champ email
//                     CustomTextField(
//                       controller: _emailController,
//                       labelText: 'Email',
//                       // prefixIcon: Icons.email,
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez entrer votre email';
//                         }
//                         if (!value.contains('@')) {
//                           return 'Email invalide';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16),
//
//                     // Champ mot de passe
//                     CustomTextField(
//                       controller: _passwordController,
//                       labelText: 'Mot de passe',
//                       // prefixIcon: Icons.lock,
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez entrer votre mot de passe';
//                         }
//                         if (value.length < 6) {
//                           return 'Le mot de passe doit contenir au moins 6 caractères';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 24),
//
//                     // Bouton de connexion
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _submitForm, // Désactivé pendant le chargement
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange, // Couleur orange
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? CircularProgressIndicator(color: Colors.white) // Indicateur de chargement
//                             : Text(
//                           'Se connecter',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // Nettoie les controllers pour éviter les fuites de mémoire
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  /// Écran de connexion à l'application NethaStock
  /// Gère l'authentification des utilisateurs avec validation des champs

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour valider le formulaire
  final _emailController = TextEditingController(); // Controller pour le champ email
  final _passwordController = TextEditingController(); // Controller pour le champ mot de passe
  bool _isLoading = false; // État de chargement pendant la connexion
  bool _obscurePassword = true; // Visibilité du mot de passe

  /// Méthode pour gérer la soumission du formulaire de connexion
  Future<void> _submitForm() async {
    // Valide tous les champs du formulaire
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true); // Active l'indicateur de chargement

    try {
      // Tente de se connecter via le AuthProvider
      final success = await Provider.of<AuthProvider>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!success) {
        // Affiche une erreur si la connexion échoue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      // Affiche une erreur en cas d'exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion: $error'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isLoading = false); // Désactive le chargement
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Dimensions de l'écran

    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width > 600 ? 500 : size.width * 0.9,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo de l'application
                    Icon(
                      Icons.inventory_2,
                      size: 60,
                      color: Colors.blue.shade700,
                    ),
                    SizedBox(height: 16),

                    // Titre de l'application
                    Text(
                      'NethaStock',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Sous-titre
                    Text(
                      'Gestion de Stocks',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 32),

                    // Champ email
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Format d\'email invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Champ mot de passe
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),

                    // Bouton de connexion
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? LoadingIndicator(size: 20) // Indicateur de chargement
                            : Text(
                          'Se connecter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Lien pour mot de passe oublié
                    TextButton(
                      onPressed: () {
                        // TODO: Implémenter la récupération de mot de passe
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fonctionnalité à venir'),
                            backgroundColor: Colors.blue.shade700,
                          ),
                        );
                      },
                      child: Text(
                        'Mot de passe oublié?',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Nettoie les controllers pour éviter les fuites de mémoire
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}