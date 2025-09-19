import 'package:flutter/material.dart';
import 'package:nethastock/screens/EditUserScreen.dart';
import 'package:nethastock/screens/UserDetailScreen.dart';
import 'package:nethastock/screens/add_user_screen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

// class UsersScreen extends StatefulWidget {
//   const UsersScreen({super.key});

//   @override
//   State<UsersScreen> createState() => _UsersScreenState();
// }

// class _UsersScreenState extends State<UsersScreen> {
//   List<User> users = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future<void> fetchUsers() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });

//     final response = await ApiService().getUsers();

//     if (response.success && response.data != null) {
//       setState(() {
//         users = response.data!;
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         error = response.message;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Utilisateurs')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//           ? Center(child: Text(error!))
//           : ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           return ListTile(
//             title: Text(user.fullName),
//             subtitle: Text(user.email),
//             trailing: Text(user.isActive ? 'Actif' : 'Inactif'),
//           );
//         },
//       ),
//     );
//   }
// }

// screens/user_list_screen.dart
// Écran qui liste tous les utilisateurs actifs (selon backend).
// Quand on clique sur un utilisateur, on ouvre la page de détails.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom, email ou rôle...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: ${userProvider.error}')),
              );
              userProvider.clearError(); // Efface l'erreur pour la prochaine fois
            });
          }

          List<User> displayedUsers = searchQuery.isEmpty
              ? userProvider.users
              : userProvider.searchUsers(searchQuery);

          if (displayedUsers.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          }

          return ListView.builder(
            itemCount: displayedUsers.length,
            itemBuilder: (context, index) {
              final user = displayedUsers[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    user.isActive ? Icons.check_circle : Icons.cancel,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                  title: Text(user.fullName),
                  subtitle: Text('${user.email} • Rôle: ${user.role}'),
                 // onTap: () => _showUserDetails(context, user),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserDetailScreen(userId: user.id),
                        ),
                      );
                    },
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'Modifier') {
                        // TODO: Ouvrir formulaire modification
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditUserScreen(user: user),
                            ),
                        );    
                      } else if (action == 'Désactiver') {
                        AlertDialog(title: Text('bonjour'));
                        bool success = await userProvider.deactivateUser(user.id);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(userProvider.error ?? 'Erreur')),
                          );
                        }
                      } else if (action == 'Activer') {
                        bool success = await userProvider.activateUser(user.id);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(userProvider.error ?? 'Erreur')),
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'Modifier', child: Text('Modifier')),
                      if (user.isActive)
                        const PopupMenuItem(value: 'Désactiver', child: Text('Désactiver')),
                      if (!user.isActive)
                        const PopupMenuItem(value: 'Activer', child: Text('Activer')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Formulaire création utilisateur
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddUserScreen(),
              ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // /// Affiche une modal avec tous les détails et statistiques de l'utilisateur
  // void _showUserDetails(BuildContext context, User user) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       final userProvider = Provider.of<UserProvider>(context, listen: false);
  //       return AlertDialog(
  //         title: Text(user.fullName),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('Email: ${user.email}'),
  //               Text('Rôle: ${user.role}'),
  //               Text('Téléphone: ${user.phone ?? "Non renseigné"}'),
  //               Text('Compte actif: ${user.isActive ? "Oui" : "Non"}'),
  //               Text('Créé le: ${user.createdAt.toLocal()}'),
  //               Text('Dernière connexion: ${user.lastLogin?.toLocal() ?? "Jamais"}'),
  //               const SizedBox(height: 10),
  //               const Text('Statistiques:', style: TextStyle(fontWeight: FontWeight.bold)),
  //               // TODO: Récupérer et afficher les statistiques de mouvements et actions
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Fermer'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
