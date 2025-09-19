import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class UserStatsScreen extends StatefulWidget {
  const UserStatsScreen({super.key});

  @override
  State<UserStatsScreen> createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends State<UserStatsScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les stats dès l'ouverture de l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final stats = userProvider.userStats.isNotEmpty ? userProvider.userStats : {};
    final topUsers = userProvider.topUsers.isNotEmpty ? userProvider.topUsers : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques Utilisateurs'),
        backgroundColor: const Color(0xFF4361EE),
        centerTitle: true,
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section stats générales
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart_rounded, color: Color(0xFF4361EE), size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Statistiques Utilisateurs',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4361EE)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Utilisateurs', stats['totalUsers']?.toString() ?? '0', Color(0xFF4361EE)),
                      _buildStatColumn('Actifs', stats['activeUsers']?.toString() ?? '0', Colors.green),
                      _buildStatColumn('Nouveaux (30j)', stats['activeThisMonth']?.toString() ?? '0', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Top Users
            if (topUsers.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top utilisateurs (mouvements)',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...topUsers.map((user) {
                      final u = Map<String, dynamic>.from(user);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: const Icon(Icons.person_rounded, size: 20, color: Color(0xFF4361EE)),
                        ),
                        title: Text('${u['firstName'] ?? ''} ${u['lastName'] ?? ''}'),
                        subtitle: Text('${u['movementCount'] ?? 0} mouvements'),
                        trailing: Chip(
                          label: Text(
                            '${u['role'] ?? ''}',
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          backgroundColor: (u['role'] ?? '') == 'administrateur' ? Colors.blue : Colors.orange,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
