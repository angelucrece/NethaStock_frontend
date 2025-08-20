import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nethastock/mes%20exos/Connexion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

final storage = FlutterSecureStorage();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const MonApp());
}

class MonApp extends StatefulWidget {
  const MonApp({super.key});

  @override
  State<MonApp> createState() => _MonAppState();
}

class _MonAppState extends State<MonApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inscription',
      debugShowCheckedModeBanner: false,
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
      home: const InscriptionScreen(),
    );
  }
}

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSecret = true;
  bool _isSecretConfirm = true;
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _isSubmitting = false;

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'magasinier';

  final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,50}$');
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s\-]{2,50}$');
  final RegExp _phoneRegex = RegExp(r'^[0-9]{10}$');
  final RegExp _passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _formIsValid() {
    return _usernameController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _password.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _acceptTerms;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les termes et conditions'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await registerUser();
    setState(() => _isSubmitting = false);
  }

  Future<void> registerUser() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _isSubmitting = true;
    });

    try {
      // 1. Construire la requête
      final uri = Uri.parse('http://localhost:5000/api/auth/register'); // Exemple pour émulateur Android
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'username': _usernameController.text.trim(),
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'role': _selectedRole,
        'password': _password,
      });

      // 2. Afficher les logs de débogage
      debugPrint('Envoi à: $uri');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      // 3. Envoyer la requête
      final response = await http.post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 60));

      // 4. Traiter la réponse
      final data = jsonDecode(response.body);
      debugPrint('Réponse: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        await storage.write(key: 'auth_token', value: data['token']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConnexionScreen()));
      } else {
        final errorMsg = data['error'] ?? data['message'] ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $errorMsg'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'enregistrement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isSubmitting = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: size.width * 0.4,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Créez votre compte',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ Nom d'utilisateur
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        hintText: 'john_doe',
                        prefixIcon: Icon(Icons.person, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        if (!_usernameRegex.hasMatch(value)) {
                          return '3-50 caractères (lettres, chiffres, _)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ Nom complet
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom complet',
                        hintText: 'Jean Dupont',
                        prefixIcon: Icon(Icons.badge, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        if (!_nameRegex.hasMatch(value.trim())) {
                          return 'Nom invalide (2-50 caractères)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse email',
                        hintText: 'exemple@domaine.com',
                        prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        if (!_emailRegex.hasMatch(value.trim())) {
                          return 'Format email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ Téléphone
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Téléphone',
                        hintText: '0612345678',
                        prefixIcon: Icon(Icons.phone, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && !_phoneRegex.hasMatch(value)) {
                          return 'Numéro invalide (10 chiffres)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sélecteur de rôle
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        prefixIcon: Icon(Icons.work, color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'magasinier',
                          child: Text('Magasinier'),
                        ),
                        DropdownMenuItem(
                          value: 'administrateur',
                          child: Text('Administrateur'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un rôle';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ Mot de passe
                    TextFormField(
                      obscureText: _isSecret,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '8+ caractères avec maj, min, chiffre, spécial',
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecret ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue[800],
                          ),
                          onPressed: () => setState(() => _isSecret = !_isSecret),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => setState(() => _password = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est obligatoire';
                        }
                        if (value.length < 8) {
                          return '8 caractères minimum';
                        }
                        if (!_passwordRegex.hasMatch(value)) {
                          return 'Majuscule, minuscule, chiffre et caractère spécial requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Champ Confirmation mot de passe
                    TextFormField(
                      obscureText: _isSecretConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecretConfirm ? Icons.visibility_off : Icons.visibility,
                            color: Colors.blue[800],
                          ),
                          onPressed: () => setState(() => _isSecretConfirm = !_isSecretConfirm),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => setState(() => _confirmPassword = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer votre mot de passe';
                        }
                        if (value != _password) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Checkbox conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'En créant un compte, vous acceptez nos ',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                        children: [
                          TextSpan(
                            text: 'Conditions d\'utilisation',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' et notre '),
                          TextSpan(
                            text: 'Politique de confidentialité',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bouton d'inscription
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _formIsValid() && !_isSubmitting ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.blue.shade300,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                      : const Text('S\'inscrire', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Lien vers connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vous avez déjà un compte? ',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnexionScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
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
}