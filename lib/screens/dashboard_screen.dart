import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/dashboard_card.dart';
import 'products_screen.dart';
import 'movements_screen.dart';

class DashboardScreen extends StatelessWidget {
  /// Écran principal du tableau de bord après la connexion
  /// Affiche les statistiques principales et sert de hub de navigation

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord NethaStock'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      drawer: _buildDrawer(context, authProvider), // Menu latéral
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec message de bienvenue
            Text(
              'Bonjour, ${authProvider.user?.email ?? ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bienvenue dans votre gestionnaire de stocks',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Grille de cartes de statistiques
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: [
                  // Carte produits totaux
                  DashboardCard(
                    title: 'Produits',
                    value: productProvider.products.length.toString(),
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductsScreen()),
                    ),
                  ),

                  // Carte produits en alerte stock
                  DashboardCard(
                    title: 'Alertes Stock',
                    value: productProvider.lowStockProducts.length.toString(),
                    icon: Icons.warning,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductsScreen(showLowStock: true)),
                    ),
                  ),

                  // Carte mouvements aujourd'hui
                  DashboardCard(
                    title: 'Mouvements Auj.',
                    value: '12', // Donnée factice pour l'exemple
                    icon: Icons.compare_arrows,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovementsScreen()),
                    ),
                  ),
                ],
              ),
            ),

            // Section actions rapides
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                ActionChip(
                  avatar: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Nouveau Produit'),
                  backgroundColor: Colors.blue.shade700,
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () {
                    // TODO: Naviguer vers l'écran d'ajout de produit
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text('Scanner Produit'),
                  backgroundColor: Colors.orange,
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () {
                    // TODO: Implémenter le scan de QR code
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.input, color: Colors.white),
                  label: const Text('Entrée Stock'),
                  backgroundColor: Colors.green,
                  labelStyle: const TextStyle(color: Colors.white),
                  onPressed: () {
                    // TODO: Naviguer vers l'écran d'entrée de stock
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le menu latéral (drawer) de l'application
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
                const SizedBox(height: 16),
                Text(
                  authProvider.user?.email ?? 'Utilisateur',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  authProvider.user?.role == 'administrateur'
                      ? 'Administrateur'
                      : 'Magasinier',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Éléments de menu de navigation
          ListTile(
            leading: Icon(Icons.dashboard, color: Colors.blue.shade700),
            title: const Text('Tableau de Bord'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory_2, color: Colors.blue.shade700),
            title: const Text('Produits'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.compare_arrows, color: Colors.blue.shade700),
            title: const Text('Mouvements'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovementsScreen()),
              );
            },
          ),
          const Divider(),

          // Menu admin (seulement pour les administrateurs)
          if (authProvider.user?.role == 'administrateur') ...[
            ListTile(
              leading: const Icon(Icons.people, color: Colors.orange),
              title: const Text('Gestion Utilisateurs'),
              onTap: () {
                // TODO: Naviguer vers la gestion des utilisateurs
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.orange),
              title: const Text('Rapports'),
              onTap: () {
                // TODO: Naviguer vers les rapports
                Navigator.pop(context);
              },
            ),
          ],
          const Divider(),

          // Menu secondaire
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Paramètres'),
            onTap: () {
              // TODO: Naviguer vers les paramètres
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Déconnexion'),
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