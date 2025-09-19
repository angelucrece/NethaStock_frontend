//ecran de modification des infos utilisateur admin uniquement
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late String _selectedRole;
  bool _isActive = true;
  bool _isLoading = false;

  // Liste des rôles disponibles
  final List<String> _roles = ['administrateur', 'magasinier','utilisateur'];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _selectedRole = widget.user.role;
    _isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    // 1. Validation du formulaire : si le formulaire est invalide, on ne fait rien.
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    // 2. Début du chargement
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Préparation des données de l'utilisateur
      final updatedUser = User(
        id: widget.user.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: widget.user.email,
        role: _selectedRole,
        isActive: _isActive,
        lastLogin: widget.user.lastLogin,
        recentMovements: widget.user.recentMovements,
        stats: widget.user.stats,
        password: widget.user.password,
        createdAt: widget.user.createdAt,
      );

      // 4. Appel au provider et récupération du résultat (true ou false)
      final provider = Provider.of<UserProvider>(context, listen: false);
      final bool success = await provider.updateUser(updatedUser);

      // 5. Gestion du succès ou de l'échec
      if (success) {
        // Cas de succès : afficher un message vert et naviguer.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Utilisateur mis à jour avec succès"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Cas d'échec : rester sur la page et afficher un message d'erreur.
        // Le message d'erreur est stocké dans le provider (provider.error)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur : ${provider.error}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Gérer ici les erreurs inattendues, comme les problèmes de connexion réseau.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur de connexion : $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 6. Arrêt du chargement, que l'opération ait réussi ou échoué.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Modifier l'utilisateur",
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
                // En-tête avec icône
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4361EE).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF4361EE),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Titre
                const Center(
                  child: Text(
                    "Modifier l'Utilisateur",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3753),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Email (non modifiable)
                Center(
                  child: Text(
                    widget.user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Formulaire
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Champ Prénom
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
                      ),
                      const SizedBox(height: 20),

                      // Champ Nom
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
                          value: _selectedRole,
                          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4361EE)),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.work, color: Colors.grey),
                            labelText: "Rôle",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          items: _roles.map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(
                                role[0].toUpperCase() + role.substring(1), // Capitalize first letter
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Switch Actif/Inactif
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.power_settings_new, color: Colors.grey),
                          title: const Text(
                            "Statut",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Switch(
                            value: _isActive,
                            activeColor: const Color(0xFF4361EE),
                            onChanged: (bool value) {
                              setState(() {
                                _isActive = value;
                              });
                            },
                          ),
                          subtitle: Text(
                            _isActive ? "Utilisateur actif" : "Utilisateur inactif",
                            style: TextStyle(
                              color: _isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Bouton d'enregistrement
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: _saveChanges,
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
                            "Enregistrer les modifications",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bouton d'annulation
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4361EE),
                            side: const BorderSide(color: Color(0xFF4361EE)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            "Annuler",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
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