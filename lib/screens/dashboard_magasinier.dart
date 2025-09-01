import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/movement_provider.dart';
import '../widgets/dashboard_card.dart';
import 'products_screen.dart';
import 'movements_screen.dart';
import 'scanner_screen.dart';
import 'profile_screen.dart';
import 'add_movement_screen.dart';
import 'dart:convert';

class DashboardMagasinierScreen extends StatelessWidget {
  /// Tableau de bord spécifique au rôle Magasinier
  /// Affiche les informations et actions pertinentes pour les opérations de terrain

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final movementProvider = Provider.of<MovementProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Mouvements du jour
    final todayMovements = movementProvider.movements
        .where((m) => m.date.day == DateTime.now().day &&
        m.date.month == DateTime.now().month &&
        m.date.year == DateTime.now().year)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord - Magasinier'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          // Bouton de déconnexion
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
            // En-tête avec message de bienvenue
            Text(
              'Bonjour, ${authProvider.user?.firstName ?? ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vue d\'ensemble de vos activités',
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
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: [
                  // Carte produits totaux
                  DashboardCard(
                    title: 'Produits en Stock',
                    value: productProvider.products.length.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductsScreen()),
                    ),
                  ),

                  // Carte alertes stock
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

                  // Carte mouvements du jour
                  DashboardCard(
                    title: 'Mouvements Aujourd\'hui',
                    value: todayMovements.toString(),
                    icon: Icons.compare_arrows,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MovementsScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Section actions rapides
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Actions Rapides',
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
                // Action: Scanner produit
                ActionChip(
                  avatar: Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                  label: Text('Scanner Produit'),
                  backgroundColor: Colors.blue.shade700,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScannerScreen()),
                  ),
                ),

                // Action: Entrée stock
                ActionChip(
                  avatar: Icon(Icons.add, color: Colors.white, size: 20),
                  label: Text('Entrée Stock'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddMovementScreen(type: 'entry')),
                  ),
                ),

                // Action: Sortie stock
                ActionChip(
                  avatar: Icon(Icons.remove, color: Colors.white, size: 20),
                  label: Text('Sortie Stock'),
                  backgroundColor: Colors.orange,
                  labelStyle: TextStyle(color: Colors.white),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddMovementScreen(type: 'exit')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construction du menu latéral (drawer) pour le magasinier
  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du drawer avec infos utilisateur
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  authProvider.user?.firstName ?? 'Magasinier',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  authProvider.user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Éléments de navigation
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blue.shade700),
            title: Text('Tableau de Bord'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory_2, color: Colors.blue.shade700),
            title: Text('Produits'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.compare_arrows, color: Colors.blue.shade700),
            title: Text('Mes Mouvements'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovementsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue.shade700),
            title: Text('Mon Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}