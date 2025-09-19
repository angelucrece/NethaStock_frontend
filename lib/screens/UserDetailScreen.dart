// screens/user_detail_screen.dart
// Écran qui affiche les détails d’un utilisateur sélectionné
// avec possibilité de désactiver l’utilisateur.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool isLoading = true;
  String? error;
  User? fetchedUser;
  String filterType = 'all'; // all | entry | exit

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = await userProvider.getUserDetails(widget.userId);
      setState(() {
        fetchedUser = user;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> get filteredMovements {
    if (fetchedUser == null) return [];
    if (filterType == 'all') return fetchedUser!.recentMovements ?? [];
    return fetchedUser!.recentMovements!
        .where((m) => m['type'] == filterType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Détails utilisateur")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Erreur: $error"))
          : fetchedUser == null
          ? const Center(child: Text("Utilisateur introuvable"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Infos utilisateur
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fetchedUser!.fullName,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("📧 ${fetchedUser!.email}"),
                    Text("🎭 Rôle: ${fetchedUser!.role}"),
                    Text("✅ Statut: ${fetchedUser!.isActive ? "Actif" : "Inactif"}"),
                    Text(
                      "⏱ Dernière connexion: ${fetchedUser!.lastLogin != null ? fetchedUser!.lastLogin!.toLocal().toString() : "Jamais"}",
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final provider =
                            Provider.of<UserProvider>(context,
                                listen: false);
                            if (fetchedUser!.isActive) {
                              await provider.deactivateUser(
                                  fetchedUser!.id);
                            } else {
                              await provider.activateUser(
                                  fetchedUser!.id);
                            }
                            await _fetchUserDetails();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fetchedUser!.isActive
                                ? Colors.red
                                : Colors.green,
                          ),
                          child: Text(fetchedUser!.isActive
                              ? "Désactiver"
                              : "Activer"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: écran modification
                          },
                          child: const Text("Modifier"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Statistiques utilisateur
            Text("📊 Statistiques",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard(
                    "Total mouvements",
                    "${fetchedUser!.stats?['total_movements'] ?? 0}",
                    Colors.blue),
                _buildStatCard(
                    "Entrées",
                    "${fetchedUser!.stats?['total_entries'] ?? 0}",
                    Colors.green),
                _buildStatCard(
                    "Sorties",
                    "${fetchedUser!.stats?['total_exits'] ?? 0}",
                    Colors.red),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Filtres
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text("Tous"),
                  selected: filterType == 'all',
                  onSelected: (_) =>
                      setState(() => filterType = 'all'),
                ),
                FilterChip(
                  label: const Text("Entrées"),
                  selected: filterType == 'entry',
                  onSelected: (_) =>
                      setState(() => filterType = 'entry'),
                ),
                FilterChip(
                  label: const Text("Sorties"),
                  selected: filterType == 'exit',
                  onSelected: (_) =>
                      setState(() => filterType = 'exit'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ Liste des mouvements
            filteredMovements.isEmpty
                ? const Center(
                child: Text("Aucun mouvement trouvé"))
                : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredMovements.length,
              itemBuilder: (context, index) {
                final movement =
                filteredMovements[index];
                final isEntry =
                    movement['type'] == 'entry';

                return Card(
                  color: isEntry
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10)),
                  margin: const EdgeInsets.symmetric(
                      vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      isEntry
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: isEntry
                          ? Colors.green
                          : Colors.red,
                    ),
                    title: Text(
                      "${movement['product_name'] ?? 'Produit'} (${movement['quantity']})",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Motif: ${movement['motif'] ?? '-'}"),
                        Text(
                            "Date: ${movement['date'] ?? '-'}"),
                        Text(
                            "Statut: ${movement['status'] ?? '-'}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Widget réutilisable pour les cartes statistiques
  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 3,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 5),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
