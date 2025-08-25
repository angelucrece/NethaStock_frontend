import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/movement_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/dashboard_card.dart';
import 'products_screen.dart';
import 'movements_screen.dart';
import 'users_screen.dart';
import 'reports_screen.dart';
import 'pending_approvals_screen.dart';
import 'profile_screen.dart';

class DashboardAdminScreen extends StatelessWidget {
  /// Tableau de bord spécifique au rôle Administrateur
  /// Affiche les informations de gestion complète du système

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final movementProvider = Provider.of<MovementProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Statistiques pour le dashboard
    final pendingMovements = movementProvider.pendingMovements.length;
    final todayMovements = movementProvider.movements
        .where((m) => m.date.day == DateTime.now().day)
        .length;
    final activeUsers = userProvider.activeUsers.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord - Administrateur'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Text(
              'Bonjour Administrateur',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vue globale du système',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),

            // Cartes de statistiques
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                children: [
                  DashboardCard(
                    title: 'Produits Total',
                    value: productProvider.products.length.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductsScreen()),
                    ),
                  ),
                  DashboardCard(
                    title: 'Alertes Stock',
                    value: productProvider.lowStockProducts.length.toString(),
                    icon: Icons.warning,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductsScreen(showLowStock: true)),
                    ),
                  ),
                  DashboardCard(
                    title: 'Mouvements Auj.',
                    value: todayMovements.toString(),
                    icon: Icons.compare_arrows,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MovementsScreen()),
                    ),
                  ),
                  DashboardCard(
                    title: 'Validations En Attente',
                    value: pendingMovements.toString(),
                    icon: Icons.pending_actions,
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PendingApprovalsScreen()),
                    ),
                  ),
                  DashboardCard(
                    title: 'Utilisateurs Actifs',
                    value: activeUsers.toString(),
                    icon: Icons.people,
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UsersScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Actions administratives
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Actions Administratives',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ActionChip(
                  avatar: Icon(Icons.people, color: Colors.white, size: 20),
                  label: Text('Gérer Utilisateurs'),
                  backgroundColor: Colors.blue.shade700,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UsersScreen()),
                  ),
                ),
                ActionChip(
                  avatar: Icon(Icons.inventory_2, color: Colors.white, size: 20),
                  label: Text('Gérer Produits'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductsScreen()),
                  ),
                ),
                ActionChip(
                  avatar: Icon(Icons.bar_chart, color: Colors.white, size: 20),
                  label: Text('Rapports'),
                  backgroundColor: Colors.orange,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsScreen()),
                  ),
                ),
                ActionChip(
                  avatar: Icon(Icons.approval, color: Colors.white, size: 20),
                  label: Text('Validations'),
                  backgroundColor: Colors.red,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PendingApprovalsScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construction du menu latéral pour l'administrateur
  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.admin_panel_settings, color: Colors.blue.shade700),
                ),
                SizedBox(height: 16),
                Text(
                  'Administrateur',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Accès complet',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blue.shade700),
            title: Text('Tableau de Bord'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.blue.shade700),
            title: Text('Utilisateurs'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UsersScreen())),
          ),
          ListTile(
            leading: Icon(Icons.inventory_2, color: Colors.blue.shade700),
            title: Text('Produits'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.compare_arrows, color: Colors.blue.shade700),
            title: Text('Mouvements'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovementsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.approval, color: Colors.blue.shade700),
            title: Text('Validations'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PendingApprovalsScreen())),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.blue.shade700),
            title: Text('Rapports'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsScreen())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue.shade700),
            title: Text('Mon Profil'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Déconnexion'),
            onTap: () => authProvider.logout(),
          ),
        ],
      ),
    );
  }
}