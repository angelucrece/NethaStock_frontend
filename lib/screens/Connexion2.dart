// import 'package:flutter/material.dart';
//
// class OnboardingContentPage1 extends StatelessWidget {
//   const OnboardingContentPage1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     const Color color = Color(0xFF0D47A1);
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 220,
//             height: 220,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 ...List.generate(3, (index) {
//                   return AnimatedContainer(
//                     duration: Duration(milliseconds: 1500 + index * 400),
//                     curve: Curves.easeOut,
//                     width: 200 + index * 30,
//                     height: 200 + index * 30,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: color.withOpacity(0.2 - index * 0.06),
//                         width: 1.5,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                   );
//                 }),
//                 Container(
//                   width: 180,
//                   height: 180,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         color,
//                         Color.lerp(color, Colors.white, 0.2)!,
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: color.withOpacity(0.4),
//                         blurRadius: 20,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.inventory_rounded,
//                     size: 70,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 50),
//           const Text(
//             'Gestion de Stock\nProfessionnelle',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0D47A1),
//               height: 1.3,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Optimisez votre inventaire avec des outils avancés de suivi et de gestion des produits.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 17,
//               color: Color(0xFF546E7A),
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Expressions régulières pour la validation
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _passwordRegex = RegExp(r'^.{6,}$'); // Au moins 6 caractères

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icône et texte de bienvenue
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      size: 60,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bonjour',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // BIENVENUE! text
              Center(
                child: Text(
                  'BIENVENUE!',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // VOTRE NOM HEADLINE text
              Center(
                child: Text(
                  'VOTRE NOM HEADLINE',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Champ email avec icône
              Text(
                'Adresse email:',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'exemple@mail.com',
                  prefixIcon: Icon(Icons.email, color: Colors.blue.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre adresse email';
                  }
                  if (!_emailRegex.hasMatch(value)) {
                    return 'Veuillez saisir une adresse email valide';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Champ mot de passe avec icône
              Text(
                'Mot de passe',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Saisissez votre mot de passe',
                  prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre mot de passe';
                  }
                  if (!_passwordRegex.hasMatch(value)) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Se souvenir de moi et Mot de passe oublié
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        'Se souvenir de moi',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Action mot de passe oublié
                      _showForgotPasswordDialog();
                    },
                    child: Text(
                      'Mot de passe oublié?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Boutons Se connecter et S'inscrire
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _validateAndSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: Text(
                        'Se connecter',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Action s'inscrire
                        Navigator.pushNamed(context, '/register');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.person_add, color: Colors.blue.shade700),
                      label: Text(
                        "S'inscrire",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Si le formulaire est valide, procéder à la connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connexion en cours...'),
          backgroundColor: Colors.green,
        ),
      );

      // Ici, vous ajouteriez votre logique de connexion réelle
      // _loginUser();
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';
        return AlertDialog(
          title: Text('Mot de passe oublié'),
          content: TextFormField(
            decoration: InputDecoration(
              labelText: 'Votre adresse email',
              prefixIcon: Icon(Icons.email),
            ),
            onChanged: (value) => email = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir votre email';
              }
              if (!_emailRegex.hasMatch(value)) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (email.isNotEmpty && _emailRegex.hasMatch(email)) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Instructions envoyées à $email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }
}