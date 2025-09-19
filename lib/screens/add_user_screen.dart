import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variables pour stocker les valeurs des champs du formulaire
  String firstName = '';
  String lastName = '';
  String email = '';
  String role = 'magasinier';
  String password = '';

  // Variables de contrôle avec valeurs par défaut non-null
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Contrôleurs pour les champs de texte (solution alternative)
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Ajouter un utilisateur",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4361EE),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isSmallScreen ? double.infinity : 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 40,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Center(
                  child: Text(
                    "Nouvel Utilisateur",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3753),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    "Remplissez les informations ci-dessous",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Champ Prénom avec controller
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: "Prénom",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prénom';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            firstName = val;
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Champ Nom avec controller
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "Nom",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            lastName = val;
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Champ Email avec controller
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            email = val;
                          }
                        },
                      ),
                      const SizedBox(height: 20),

                      // Sélecteur de rôle
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: role,
                          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4361EE)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.work, color: Colors.grey),
                            labelText: "Rôle",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "admin",
                              child: Text("Admin", style: TextStyle(fontSize: 16)),
                            ),
                            DropdownMenuItem(
                              value: "magasinier",
                              child: Text("Magasinier", style: TextStyle(fontSize: 16)),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => role = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Champ Mot de passe avec controller
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF4361EE), width: 2),
                          ),
                        ),
                        style: const TextStyle(fontSize: 16),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          }
                          if (value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          if (val != null) {
                            password = val;
                          }
                        },
                      ),
                      // TextFormField(
                      //   controller: _passwordController,
                      //   obscureText: _obscurePassword,
                      //   decoration: InputDecoration(
                      //     labelText: "Mot de passe",
                      //     labelStyle: const TextStyle(color: Colors.grey),
                      //     prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      //     suffixIcon: IconButton(
                      //       icon: Icon(
                      //           _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      //           color: Colors.grey,
                      //       ),
                      //       onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      //     ),
                      //
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Veuillez entrer votre mot de passe';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      const SizedBox(height: 32),

                      // Bouton de soumission
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: () async {
                            // Validation du formulaire
                            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                // Création de l'utilisateur
                                final user = User(
                                  id: 0,
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  role: role,
                                  isActive: true,
                                  password: _passwordController.text,
                                  createdAt: DateTime.now(),
                                );

                                // Appel au provider pour créer l'utilisateur
                                final userProvider = Provider.of<UserProvider>(context, listen: false);
                                final success = await userProvider.createUser(user, _passwordController.text);

                                // Gestion de la réponse
                                // Gestion de la réponse
                                if (success == true) {
                                  // 1. Afficher le message de succès d'abord
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Utilisateur créé avec succès"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  // 2. Naviguer seulement après que le message a été affiché
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Erreur lors de la création de l'utilisateur"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Erreur: ${e.toString()}"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                // Vérification que le widget est toujours monté avant de changer l'état
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4361EE),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            "Créer l'utilisateur",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}