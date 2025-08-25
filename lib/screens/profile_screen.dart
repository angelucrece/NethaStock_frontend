import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  /// Écran de gestion du profil utilisateur
  /// Permet à tous les utilisateurs de consulter et modifier leurs informations

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;
  bool _showPasswordSection = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final updatedUser = authProvider.user!.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      );

      final success = await authProvider.updateProfile(updatedUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _isEditing = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Les mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implémenter la mise à jour du mot de passe via l'API
      await Future.delayed(Duration(seconds: 2)); // Simulation

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mot de passe mis à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _showPasswordSection = false;
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour du mot de passe'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          if (!_isEditing && !_showPasswordSection) ...[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Modifier le profil',
            ),
          ],
          if (_isEditing || _showPasswordSection) ...[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => setState(() {
                _isEditing = false;
                _showPasswordSection = false;
                _loadUserData();
              }),
              tooltip: 'Annuler',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? LoadingIndicator(message: 'Chargement...')
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade700,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user?.fullName ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Chip(
                      label: Text(
                        user?.isAdmin == true ? 'Administrateur' : 'Magasinier',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: user?.isAdmin == true ? Colors.blue : Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Informations personnelles
              Text(
                'Informations Personnelles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              CustomTextField(
                controller: _firstNameController,
                labelText: 'Prénom',
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Le prénom est requis';
                  return null;
                },
              ),
              SizedBox(height: 16),

              CustomTextField(
                controller: _lastNameController,
                labelText: 'Nom',
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Le nom est requis';
                  return null;
                },
              ),
              SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'L\'email est requis';
                  if (!value.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                labelText: 'Téléphone (optionnel)',
                keyboardType: TextInputType.phone,
                enabled: _isEditing,
              ),

              if (_isEditing) ...[
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Enregistrer les modifications'),
                  ),
                ),
              ],

              // Section changement de mot de passe
              if (!_isEditing && !_showPasswordSection) ...[
                SizedBox(height: 32),
                Divider(),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _showPasswordSection = true),
                    child: Text('Changer le mot de passe'),
                  ),
                ),
              ],

              if (_showPasswordSection) ...[
                SizedBox(height: 32),
                Text(
                  'Changer le mot de passe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                CustomTextField(
                  controller: _currentPasswordController,
                  labelText: 'Mot de passe actuel',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Le mot de passe actuel est requis';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  controller: _newPasswordController,
                  labelText: 'Nouveau mot de passe',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Le nouveau mot de passe est requis';
                    if (value.length < 6) return '6 caractères minimum';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmer le mot de passe',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'La confirmation est requise';
                    if (value != _newPasswordController.text) return 'Les mots de passe ne correspondent pas';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _showPasswordSection = false),
                        child: Text('Annuler'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ],

              // Informations de compte
              if (!_isEditing && !_showPasswordSection) ...[
                SizedBox(height: 32),
                Divider(),
                SizedBox(height: 16),
                Text(
                  'Informations du Compte',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.calendar_today, size: 20),
                  title: Text('Date de création'),
                  subtitle: Text(user?.createdAt.toString() ?? ''),
                  dense: true,
                ),
                if (user?.lastLogin != null) ...[
                  ListTile(
                    leading: Icon(Icons.login, size: 20),
                    title: Text('Dernière connexion'),
                    subtitle: Text(user!.lastLogin!.toString()),
                    dense: true,
                  ),
                ],
                ListTile(
                  leading: Icon(Icons.verified_user, size: 20),
                  title: Text('Statut du compte'),
                  subtitle: Text(user?.isActive == true ? 'Actif' : 'Inactif'),
                  dense: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}