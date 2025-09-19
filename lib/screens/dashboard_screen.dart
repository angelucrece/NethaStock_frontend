// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/product_provider.dart';
// import '../widgets/dashboard_card.dart';
// import 'products_screen.dart';
// import 'movements_screen.dart';
//
// class DashboardScreen extends StatelessWidget {
//   /// Écran principal du tableau de bord après la connexion
//   /// Affiche les statistiques principales et sert de hub de navigation
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tableau de Bord NethaStock'),
//         backgroundColor: Colors.blue.shade700,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => authProvider.logout(),
//             tooltip: 'Déconnexion',
//           ),
//         ],
//       ),
//       drawer: _buildDrawer(context, authProvider), // Menu latéral
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // En-tête avec message de bienvenue
//             Text(
//               'Bonjour, ${authProvider.user?.email ?? ''}',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Bienvenue dans votre gestionnaire de stocks',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Grille de cartes de statistiques
//             Expanded(
//               child: GridView(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 1.2,
//                 ),
//                 children: [
//                   // Carte produits totaux
//                   DashboardCard(
//                     title: 'Produits',
//                     value: productProvider.products.length.toString(),
//                     icon: Icons.inventory_2,
//                     color: Colors.blue,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProductsScreen()),
//                     ),
//                   ),
//
//                   // Carte produits en alerte stock
//                   DashboardCard(
//                     title: 'Alertes Stock',
//                     value: productProvider.lowStockProducts.length.toString(),
//                     icon: Icons.warning,
//                     color: Colors.orange,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProductsScreen(showLowStock: true)),
//                     ),
//                   ),
//
//                   // Carte mouvements aujourd'hui
//                   DashboardCard(
//                     title: 'Mouvements Auj.',
//                     value: '12', // Donnée factice pour l'exemple
//                     icon: Icons.compare_arrows,
//                     color: Colors.green,
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MovementsScreen()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Section actions rapides
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Text(
//                 'Actions Rapides',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade700,
//                 ),
//               ),
//             ),
//             Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 ActionChip(
//                   avatar: const Icon(Icons.add, color: Colors.white),
//                   label: const Text('Nouveau Produit'),
//                   backgroundColor: Colors.blue.shade700,
//                   labelStyle: const TextStyle(color: Colors.white),
//                   onPressed: () {
//                     // TODO: Naviguer vers l'écran d'ajout de produit
//                   },
//                 ),
//                 ActionChip(
//                   avatar: const Icon(Icons.qr_code_scanner, color: Colors.white),
//                   label: const Text('Scanner Produit'),
//                   backgroundColor: Colors.orange,
//                   labelStyle: const TextStyle(color: Colors.white),
//                   onPressed: () {
//                     // TODO: Implémenter le scan de QR code
//                   },
//                 ),
//                 ActionChip(
//                   avatar: const Icon(Icons.input, color: Colors.white),
//                   label: const Text('Entrée Stock'),
//                   backgroundColor: Colors.green,
//                   labelStyle: const TextStyle(color: Colors.white),
//                   onPressed: () {
//                     // TODO: Naviguer vers l'écran d'entrée de stock
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Construit le menu latéral (drawer) de l'application
//   Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // En-tête du drawer avec infos utilisateur
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue.shade700,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   radius: 30,
//                   child: Icon(
//                     Icons.person,
//                     size: 30,
//                     color: Colors.blue.shade700,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   authProvider.user?.email ?? 'Utilisateur',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   authProvider.user?.role == 'administrateur'
//                       ? 'Administrateur'
//                       : 'Magasinier',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Éléments de menu de navigation
//           ListTile(
//             leading: Icon(Icons.dashboard, color: Colors.blue.shade700),
//             title: const Text('Tableau de Bord'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.inventory_2, color: Colors.blue.shade700),
//             title: const Text('Produits'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProductsScreen()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.compare_arrows, color: Colors.blue.shade700),
//             title: const Text('Mouvements'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => MovementsScreen()),
//               );
//             },
//           ),
//           const Divider(),
//
//           // Menu admin (seulement pour les administrateurs)
//           if (authProvider.user?.role == 'administrateur') ...[
//             ListTile(
//               leading: const Icon(Icons.people, color: Colors.orange),
//               title: const Text('Gestion Utilisateurs'),
//               onTap: () {
//                 // TODO: Naviguer vers la gestion des utilisateurs
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.bar_chart, color: Colors.orange),
//               title: const Text('Rapports'),
//               onTap: () {
//                 // TODO: Naviguer vers les rapports
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//           const Divider(),
//
//           // Menu secondaire
//           ListTile(
//             leading: const Icon(Icons.settings, color: Colors.grey),
//             title: const Text('Paramètres'),
//             onTap: () {
//               // TODO: Naviguer vers les paramètres
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Déconnexion'),
//             onTap: () {
//               Navigator.pop(context);
//               authProvider.logout();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/movement.dart';
// import '../models/user.dart';
// import '../providers/auth_provider.dart';
// import '../services/api_service.dart';
// import '../services/dashboard_service.dart';
// import '../widgets/dashboard_card.dart';
// import '../widgets/stat_item.dart';
// import '../widgets/movement_item.dart';
// import '../widgets/loading_shimmer.dart';
// import '../widgets/error_retry_widget.dart';
//
// class DashboardScreen extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   late Map<String, dynamic> _dashboardData;
//   bool _isLoading = true;
//   String _errorMessage = '';
//   int _currentIndex = 0;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     _dashboardData = {};
//     _loadDashboardData();
//   }
//
//   Future<void> _loadDashboardData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       final isAdmin = authProvider.user?.role == 'admin';
//
//       final response = await ApiService().getDashboardData(isAdmin: isAdmin);
//       if (response.success) {
//         setState(() {
//           _dashboardData = response.data as Map<String, dynamic>;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = response.message;
//           _isLoading = false;
//         });
//       }
//     } catch (error) {
//       setState(() {
//         _errorMessage = 'Erreur de chargement: $error';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _refreshData() async {
//     await _loadDashboardData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final currentUser = authProvider.user;
//     final isAdmin = currentUser?.role == 'admin';
//
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.grey.shade50,
//       appBar: _buildAppBar(currentUser),
//       drawer: _buildDrawer(context, currentUser, isAdmin),
//       body: _buildBodyContent(isAdmin),
//       bottomNavigationBar: _buildBottomNavigationBar(isAdmin),
//       floatingActionButton: _buildFloatingActionButton(isAdmin),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(User? currentUser) {
//     return AppBar(
//       title: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: 'NetHa',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.white,
//                 letterSpacing: 1.1,
//               ),
//             ),
//             TextSpan(
//               text: 'Stock',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w300,
//                 color: Colors.white.withOpacity(0.9),
//                 letterSpacing: 1.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.blue.shade800,
//       elevation: 3,
//       leading: IconButton(
//         icon: Icon(Icons.menu),
//         onPressed: () {
//           _scaffoldKey.currentState?.openDrawer();
//         },
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.refresh_rounded, size: 22),
//           onPressed: _refreshData,
//           tooltip: 'Rafraîchir',
//         ),
//         IconButton(
//           icon: Icon(Icons.logout_rounded, size: 22),
//           onPressed: () => _showLogoutDialog(context),
//           tooltip: 'Déconnexion',
//         ),
//       ],
//     );
//   }
//   /// Dialogue de déconnexion
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Déconnexion'),
//           content: Text('Êtes-vous sûr de vouloir vous déconnecter?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Provider.of<AuthProvider>(context, listen: false).logout();
//               },
//               child: Text('Déconnexion', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildDrawer(BuildContext context, User? currentUser, bool isAdmin) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue.shade800,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.person_rounded,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   isAdmin ? 'Administrateur' : 'Magasinier',
//                   style: TextStyle(
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Options communes
//           ListTile(
//             leading: Icon(Icons.dashboard, color: Colors.blue),
//             title: Text('Tableau de bord'),
//             onTap: () {
//               Navigator.pop(context);
//               setState(() {
//                 _currentIndex = 0;
//               });
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.inventory_2, color: Colors.blue),
//             title: Text('Mouvements'),
//             onTap: () {
//               Navigator.pop(context);
//               setState(() {
//                 _currentIndex = 1;
//               });
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.scanner, color: Colors.blue),
//             title: Text('Scanner produit'),
//             onTap: () {
//               Navigator.pop(context);
//               setState(() {
//                 _currentIndex = 2;
//               });
//             },
//           ),
//
//           // Options spécifiques admin
//           if (isAdmin) ...[
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.people, color: Colors.green),
//               title: Text('Gestion utilisateurs'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _currentIndex = 3;
//                 });
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.assessment, color: Colors.green),
//               title: Text('Rapports'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _currentIndex = 4;
//                 });
//               },
//             ),
//           ],
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app, color: Colors.red),
//             title: Text('Déconnexion'),
//             onTap: () => _showLogoutDialog(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigationBar(bool isAdmin) {
//     final List<BottomNavigationBarItem> navItems = [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.dashboard),
//         label: 'Dashboard',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.compare_arrows),
//         label: 'Mouvements',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.scanner),
//         label: 'Scanner',
//       ),
//     ];
//
//     if (isAdmin) {
//       navItems.addAll([
//         BottomNavigationBarItem(
//           icon: Icon(Icons.people),
//           label: 'Utilisateurs',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.assessment),
//           label: 'Rapports',
//         ),
//       ]);
//     }
//
//     final validIndex = _currentIndex < navItems.length ? _currentIndex : 0;
//
//     return BottomNavigationBar(
//       currentIndex: validIndex,
//       onTap: (index) {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: Colors.blue.shade800,
//       unselectedItemColor: Colors.grey.shade600,
//       items: navItems,
//     );
//   }
//
//   Widget _buildBodyContent(bool isAdmin) {
//     final List<Widget> contentScreens = [
//       _buildDashboardContent(isAdmin),
//       _buildMovementsContent(isAdmin),
//       _buildScannerContent(),
//     ];
//
//     if (isAdmin) {
//       contentScreens.addAll([
//         _buildUsersContent(),
//         _buildReportsContent(),
//       ]);
//     }
//
//     final validIndex = _currentIndex < contentScreens.length ? _currentIndex : 0;
//
//     return contentScreens[validIndex];
//   }
//
//   // MODIFICATIONS IMPORTANTES ICI - Dashboard différent selon le rôle
//   Widget _buildDashboardContent(bool isAdmin) {
//     if (_isLoading) {
//       return LoadingShimmer();
//     }
//
//     if (_errorMessage.isNotEmpty) {
//       return ErrorRetryWidget(
//         errorMessage: _errorMessage,
//         onRetry: _refreshData,
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       color: Colors.blue.shade800,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderSection(isAdmin),
//             SizedBox(height: 24),
//             _buildQuickStatsSection(isAdmin),
//             SizedBox(height: 24),
//             _buildDashboardGrid(isAdmin),
//             SizedBox(height: 24),
//             _buildRecentMovementsSection(),
//             if (isAdmin) ...[
//               SizedBox(height: 24),
//               _buildAdminStatsSection(),
//             ],
//             SizedBox(height: 24),
//             _buildStockAlertsSection(),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection(bool isAdmin) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final currentUser = authProvider.user;
//
//     return Row(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue.shade700,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.blue.shade300.withOpacity(0.4),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Icon(
//             Icons.person_rounded,
//             color: Colors.white,
//             size: 28,
//           ),
//         ),
//         SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Bonjour, ${currentUser?.firstName ?? 'Utilisateur'}',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.blue.shade800,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 isAdmin ? 'Tableau de bord Administrateur' : 'Tableau de bord Magasinier',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: Colors.blue.shade50,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.blue.shade100,
//               width: 1,
//             ),
//           ),
//           child: Text(
//             '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.blue.shade700,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildQuickStatsSection(bool isAdmin) {
//     final stockOverview = _dashboardData['stockOverview'] ?? {};
//     final movementSummary = _dashboardData['movementSummary'] ?? {};
//
//     List<Widget> statItems = [
//       StatItem(
//         icon: Icons.inventory_2_rounded,
//         value: stockOverview['total_products']?.toString() ?? '0',
//         label: 'Produits',
//         color: Colors.blue,
//       ),
//       StatItem(
//         icon: Icons.warning_amber_rounded,
//         value: stockOverview['low_stock_count']?.toString() ?? '0',
//         label: 'Alertes',
//         color: Colors.orange,
//       ),
//       StatItem(
//         icon: Icons.trending_up_rounded,
//         value: movementSummary['today_movements']?.toString() ?? '0',
//         label: 'Aujourd\'hui',
//         color: Colors.green,
//       ),
//     ];
//
//     // Ajouter des stats spécifiques admin
//     if (isAdmin) {
//       statItems.add(
//         StatItem(
//           icon: Icons.people_rounded,
//           value: _dashboardData['total_users']?.toString() ?? '0',
//           label: 'Utilisateurs',
//           color: Colors.purple,
//         ),
//       );
//     } else {
//       statItems.add(
//         StatItem(
//           icon: Icons.pending_actions_rounded,
//           value: movementSummary['my_pending_count']?.toString() ?? '0',
//           label: 'Mes en attente',
//           color: Colors.red,
//         ),
//       );
//     }
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade100.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: statItems,
//       ),
//     );
//   }
//
//   Widget _buildDashboardGrid(bool isAdmin) {
//     final stockOverview = _dashboardData['stockOverview'] ?? {};
//     final movementSummary = _dashboardData['movementSummary'] ?? {};
//
//     List<Widget> dashboardCards = [
//       DashboardCard(
//         title: 'Produits Total',
//         value: stockOverview['total_products']?.toString() ?? '0',
//         icon: Icons.inventory_2_rounded,
//         color: Colors.blue,
//         // onTap: () => _navigateToProductsScreen(),
//       ),
//       DashboardCard(
//         title: 'Alertes Stock',
//         value: stockOverview['low_stock_count']?.toString() ?? '0',
//         icon: Icons.warning_amber_rounded,
//         color: Colors.orange,
//         // onTap: () => _navigateToLowStockProducts(),
//       ),
//     ];
//
//     /// Méthodes de navigation
//     void _navigateToProductsScreen() {
//       Navigator.pushNamed(context, '/products');
//     }
//
//     void _navigateToMovementsScreen() {
//       Navigator.pushNamed(context, '/movements');
//     }
//
//     void _navigateToAddMovement() {
//       Navigator.pushNamed(context, '/add-movement');
//     }
//
//     void _navigateToPendingApprovals() {
//       Navigator.pushNamed(context, '/pending-approvals');
//     }
//
//     void _navigateToLowStockProducts() {
//       Navigator.pushNamed(context, '/products', arguments: {'showLowStock': true});
//     }
//
//     void _navigateToScanner() {
//       Navigator.pushNamed(context, '/scanner');
//     }
//
//     void _navigateToUserManagement() {
//       Navigator.pushNamed(context, '/users');
//     }
//
//     void _navigateToAddUser() {
//       Navigator.pushNamed(context, '/add-user');
//     }
//
//     void _navigateToReports() {
//       Navigator.pushNamed(context, '/reports');
//     }
//
//     void _navigateToGenerateReport() {
//       Navigator.pushNamed(context, '/generate-report');
//     }
//
//     void _navigateToSystemSettings() {
//       Navigator.pushNamed(context, '/settings');
//     }
//
//
//     if (isAdmin) {
//       // Dashboard admin
//       dashboardCards.addAll([
//         DashboardCard(
//           title: 'Mouvements Auj.',
//           value: movementSummary['today_movements']?.toString() ?? '0',
//           icon: Icons.compare_arrows_rounded,
//           color: Colors.green,
//           onTap: () => _navigateToMovementsScreen(),
//         ),
//         DashboardCard(
//           title: 'Utilisateurs',
//           value: _dashboardData['total_users']?.toString() ?? '0',
//           icon: Icons.people_rounded,
//           color: Colors.purple,
//           onTap: () => _navigateToUserManagement(),
//         ),
//         DashboardCard(
//           title: 'Validations',
//           value: movementSummary['pending_count']?.toString() ?? '0',
//           icon: Icons.pending_actions_rounded,
//           color: Colors.red,
//           onTap: () => _navigateToPendingApprovals(),
//         ),
//         DashboardCard(
//           title: 'Rapports',
//           value: _dashboardData['reports_count']?.toString() ?? '0',
//           icon: Icons.assessment_rounded,
//           color: Colors.teal,
//           onTap: () => _navigateToReports(),
//         ),
//       ]);
//     } else {
//       // Dashboard magasinier
//       dashboardCards.addAll([
//         DashboardCard(
//           title: 'Mes Mouvements',
//           value: movementSummary['my_movements']?.toString() ?? '0',
//           icon: Icons.compare_arrows_rounded,
//           color: Colors.green,
//           onTap: () => _navigateToMovementsScreen(),
//         ),
//         DashboardCard(
//           title: 'En Attente',
//           value: movementSummary['my_pending_count']?.toString() ?? '0',
//           icon: Icons.pending_actions_rounded,
//           color: Colors.red,
//           onTap: () => _navigateToMyPendingMovements(),
//         ),
//       ]);
//     }
//
//     return GridView(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.2,
//       ),
//       children: dashboardCards,
//     );
//   }
//
//   Widget _buildAdminStatsSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.purple.shade100.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.admin_panel_settings, color: Colors.purple, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'Statistiques Administrateur',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.purple.shade800,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               StatItem(
//                 icon: Icons.people_outline,
//                 value: _dashboardData['active_users']?.toString() ?? '0',
//                 label: 'Utilisateurs actifs',
//                 color: Colors.purple,
//                 size: 16,
//               ),
//               StatItem(
//                 icon: Icons.trending_up,
//                 value: _dashboardData['monthly_movements']?.toString() ?? '0',
//                 label: 'Mouvements/mois',
//                 color: Colors.green,
//                 size: 16,
//               ),
//               StatItem(
//                 icon: Icons.attach_money,
//                 value: _dashboardData['total_value']?.toString() ?? '0',
//                 label: 'Valeur stock',
//                 color: Colors.blue,
//                 size: 16,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToMovementsScreen() {
//     Navigator.pushNamed(context, '/movements');
//   }
//   Widget _buildMovementsContent(bool isAdmin) {
//     if (isAdmin) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.compare_arrows, size: 64, color: Colors.blue),
//             SizedBox(height: 16),
//             Text(
//               'Tous les mouvements',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text('Gestion de tous les mouvements de stock'),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _navigateToMovementsScreen(),
//               child: Text('Voir tous les mouvements'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade800,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.compare_arrows, size: 64, color: Colors.blue),
//             SizedBox(height: 16),
//             Text(
//               'Mes mouvements',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text('Gestion de mes mouvements de stock'),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => _navigateToAddMovement(),
//               child: Text('Nouveau mouvement'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue.shade800,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => _navigateToMyMovements(),
//               child: Text('Voir mes mouvements'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   /// Méthodes de navigation
//   void _navigateToProductsScreen() {
//     Navigator.pushNamed(context, '/products');
//   }
//
//   // void _navigateToMovementsScreen() {
//   //   Navigator.pushNamed(context, '/movements');
//   // }
//
//   void _navigateToAddMovement() {
//     Navigator.pushNamed(context, '/add-movement');
//   }
//
//   void _navigateToPendingApprovals() {
//     Navigator.pushNamed(context, '/pending-approvals');
//   }
//
//   void _navigateToLowStockProducts() {
//     Navigator.pushNamed(context, '/products', arguments: {'showLowStock': true});
//   }
//
//   void _navigateToScanner() {
//     Navigator.pushNamed(context, '/scanner');
//   }
//
//   void _navigateToUserManagement() {
//     Navigator.pushNamed(context, '/users');
//   }
//
//   void _navigateToAddUser() {
//     Navigator.pushNamed(context, '/add-user');
//   }
//
//   void _navigateToReports() {
//     Navigator.pushNamed(context, '/reports');
//   }
//
//   void _navigateToGenerateReport() {
//     Navigator.pushNamed(context, '/generate-report');
//   }
//
//   void _navigateToSystemSettings() {
//     Navigator.pushNamed(context, '/settings');
//   }
//
//
//   // Autres méthodes restent similaires mais adaptées...
//
//   Widget _buildScannerContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.scanner, size: 64, color: Colors.blue),
//           SizedBox(height: 16),
//           Text(
//             'Scanner un produit',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text('Utilisez la caméra pour scanner un code-barres'),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () => _navigateToScanner(),
//             child: Text('Ouvrir le scanner'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade800,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUsersContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.people, size: 64, color: Colors.green),
//           SizedBox(height: 16),
//           Text(
//             'Gestion des utilisateurs',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text('Administration des comptes et permissions'),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () => _navigateToUserManagement(),
//             child: Text('Gérer les utilisateurs'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildReportsContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.assessment, size: 64, color: Colors.orange),
//           SizedBox(height: 16),
//           Text(
//             'Rapports et statistiques',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text('Analyses et exports des données'),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () => _navigateToReports(),
//             child: Text('Générer un rapport'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecentMovementsSection() {
//     final recentMovements = _dashboardData['recentMovements'] as List<dynamic>? ?? [];
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.shade100.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.history_rounded, color: Colors.blue.shade800, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'Mouvements Récents',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.blue.shade800,
//                 ),
//               ),
//               Spacer(),
//               TextButton(
//                 onPressed: _navigateToMovementsScreen,
//                 child: Text(
//                   'Voir tout',
//                   style: TextStyle(
//                     color: Colors.blue.shade600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           if (recentMovements.isEmpty)
//             Text(
//               'Aucun mouvement récent',
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontStyle: FontStyle.italic,
//               ),
//             )
//           else
//             Column(
//               children: recentMovements.map<Widget>((jsonMovement) {
//                 final movement = Movement.fromJson(jsonMovement as Map<String, dynamic>);
//                 return MovementItem(movement: movement);
//               }).toList(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStockAlertsSection() {
//     final lowStockAlerts = _dashboardData['lowStockAlerts'] ?? [];
//
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.shade100.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'Alertes Stock Bas',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.orange.shade700,
//                 ),
//               ),
//               Spacer(),
//               TextButton(
//                 onPressed: _navigateToLowStockProducts,
//                 child: Text(
//                   'Voir tout',
//                   style: TextStyle(
//                     color: Colors.orange.shade600,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           if (lowStockAlerts.isEmpty)
//             Text(
//               'Aucune alerte de stock',
//               style: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontStyle: FontStyle.italic,
//               ),
//             )
//           else
//             Column(
//               children: lowStockAlerts.map<Widget>((product) =>
//                   ListTile(
//                     leading: Icon(Icons.inventory_2_rounded, color: Colors.orange),
//                     title: Text(product['name'] ?? 'Produit inconnu'),
//                     subtitle: Text(
//                       'Stock: ${product['quantity']} / Seuil: ${product['threshold']}',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                     trailing: Chip(
//                       label: Text(
//                         '${product['category_name'] ?? 'N/A'}',
//                         style: TextStyle(fontSize: 10, color: Colors.white),
//                       ),
//                       backgroundColor: Colors.blue.shade600,
//                     ),
//                   )
//               ).toList(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildFloatingActionButton(bool isAdmin) {
//   //   // Logique FAB adaptée au rôle...
//   //   // [Le reste du code FAB reste similaire mais adapté]
//   // }
//   /// Bouton flottant contextuel en fonction du rôle
//   Widget _buildFloatingActionButton(bool isAdmin) {
//     // Détermine l'action en fonction de l'onglet actif
//     VoidCallback? onPressed;
//     IconData icon;
//     String tooltip;
//
//     // Vérification que l'index est valide
//     final int validIndex = _currentIndex;
//     final int maxIndex = isAdmin ? 4 : 2;
//
//     if (validIndex > maxIndex) {
//       return SizedBox.shrink(); // Cacher le FAB si index invalide
//     }
//
//     switch (validIndex) {
//       case 0: // Dashboard
//         // onPressed = _showQuickActionsMenu;
//         icon = Icons.add_rounded;
//         tooltip = 'Actions rapides';
//         break;
//       case 1: // Mouvements
//         onPressed = () => _navigateToAddMovement();
//         icon = Icons.add_rounded;
//         tooltip = 'Nouveau mouvement';
//         break;
//       case 2: // Scanner
//         onPressed = () => _navigateToScanner();
//         icon = Icons.scanner;
//         tooltip = 'Scanner';
//         break;
//       case 3: // Utilisateurs (admin)
//         if (isAdmin) {
//           onPressed = () => _navigateToAddUser();
//           icon = Icons.person_add;
//           tooltip = 'Ajouter utilisateur';
//         } else {
//           return SizedBox.shrink(); // Cacher le FAB si pas admin
//         }
//         break;
//       case 4: // Rapports (admin)
//         if (isAdmin) {
//           onPressed = () => _navigateToGenerateReport();
//           icon = Icons.assignment;
//           tooltip = 'Générer rapport';
//         } else {
//           return SizedBox.shrink(); // Cacher le FAB si pas admin
//         }
//         break;
//       default:
//         // onPressed = _showQuickActionsMenu;
//         icon = Icons.add_rounded;
//         tooltip = 'Actions rapides';
//     }
//
//     return FloatingActionButton(
//       onPressed: onPressed,
//       backgroundColor: Colors.blue.shade800,
//       foregroundColor: Colors.white,
//       elevation: 4,
//       tooltip: tooltip,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Icon(icon, size: 28),
//     );
//   }
//
//   // Ajouter cette méthode pour les mouvements personnels du magasinier
//   void _navigateToMyMovements() {
//     Navigator.pushNamed(context, '/movements', arguments: {'showMineOnly': true});
//   }
//
//   void _navigateToMyPendingMovements() {
//     Navigator.pushNamed(context, '/movements', arguments: {'showPendingOnly': true});
//   }
//
// // Autres méthodes de navigation...
// }
//
//


import 'package:flutter/material.dart';
import 'package:nethastock/screens/add_user_screen.dart';
import 'package:nethastock/screens/movements_screen.dart';
import 'package:nethastock/screens/pending_approvals_screen.dart';
import 'package:nethastock/screens/product_form_screen.dart';
import 'package:nethastock/screens/products_screen.dart';
import 'package:nethastock/screens/profile_screen.dart';
import 'package:nethastock/screens/reports_export_screen.dart';
import 'package:nethastock/screens/reports_generate_screen.dart';
import 'package:nethastock/screens/reports_overview_screen.dart';
import 'package:nethastock/screens/reports_screen.dart';
import 'package:nethastock/screens/barcode_scan_screen.dart';
import 'package:nethastock/screens/userStatsScreen.dart';
import 'package:nethastock/screens/users_screen.dart';
import 'package:nethastock/screens/categories_screen.dart';
import 'package:nethastock/screens/notifications_screen.dart';
import 'package:provider/provider.dart';
import '../models/movement.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/stat_item.dart';
import '../widgets/movement_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_retry_widget.dart';
import 'package:nethastock/utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // États pour la gestion des données
  late Map<String, dynamic> _dashboardData;
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Définition des couleurs de l'application (corrige l'erreur avecOpacity)
  final Color _primaryColor = Color(0xFF2196F3);
  final Color _secondaryColor = Color(0xFFFF9800);
  final Color _accentColor = Color(0xFFFF9800);
  final Color _successColor = Color(0xFF10B981);
  final Color _warningColor = Color(0xFFF59E0B);
  final Color _dangerColor = Color(0xFFEF4444);
  final Color _infoColor = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _dashboardData = {};
    _loadDashboardData();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserStats();

  }

  /// Charge les données du tableau de bord depuis l'API
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getDashboardData();
      if (response.success) {
        setState(() {
          _dashboardData = response.data as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $error';
        _isLoading = false;
      });
    }
  }

  /// Rafraîchit les données du tableau de bord
  Future<void> _refreshData() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    final isAdmin = currentUser?.role == 'administrateur';


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(currentUser),
      drawer: _buildDrawer(context, currentUser, isAdmin),
      body: _buildBodyContent(isAdmin),
      bottomNavigationBar: _buildBottomNavigationBar(isAdmin),
      floatingActionButton: _buildFloatingActionButton(isAdmin),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Construit l'AppBar avec le titre et les actions
  PreferredSizeWidget _buildAppBar(User? currentUser) {
    return AppBar(
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'NetHa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
            TextSpan(
              text: 'Stock',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.9),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: _primaryColor,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      leading: IconButton(
        icon: Icon(Icons.menu, size: 26),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded, size: 24),
          onPressed: _refreshData,
          tooltip: 'Rafraîchir',
        ),
        IconButton(
          icon: Icon(Icons.person_2_outlined, size: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen()),
            );
          },
          tooltip: 'Mon Profil',
        ),
        IconButton(
          icon: Icon(Icons.notifications, size: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NotificationsScreen()),
            );
          },
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: Icon(Icons.logout_rounded, size: 24),
          onPressed: () => _showLogoutDialog(context),
          tooltip: 'Déconnexion',
        ),
      ],
    );
  }

  /// Construit le menu latéral (drawer) avec navigation
  Widget _buildDrawer(BuildContext context, User? currentUser, bool isAdmin) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du drawer avec informations utilisateur
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.person_rounded, color: _primaryColor, size: 32),
                ),
                SizedBox(height: 16),
                Text(
                  '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAdmin ? 'Administrateur' : 'Magasinier',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Options de navigation communes
          _buildDrawerItem(Icons.dashboard_rounded, 'Tableau de bord', 0),
          _buildDrawerItem(Icons.compare_arrows_rounded, 'Mouvements', 1),
          _buildDrawerItem(Icons.qr_code_scanner_rounded, 'Scanner produit', 2),
          _buildDrawerItem(Icons.inventory_2_rounded, 'Produits', -2),
          _buildDrawerItem(Icons.category_rounded, 'Catégories produits', -3),
          _buildDrawerItem(Icons.notifications_rounded, 'Mes notifications', -4),

          // Options spécifiques administrateur
          if (isAdmin) ...[
            Divider(indent: 16, endIndent: 16, color: Colors.grey.shade300),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Text(
                'ADMINISTRATION',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 1.2
                ),
              ),
            ),
            _buildDrawerItem(Icons.people_rounded, 'Gestion utilisateurs', 3, color: _successColor),
            _buildDrawerItem(Icons.assessment_rounded, 'Rapports', 4, color: _accentColor),
            _buildDrawerItem(Icons.bar_chart_rounded, 'Stats utilisateurs', -5, color: _infoColor),
          ],

          Divider(indent: 16, endIndent: 16, color: Colors.grey.shade300),
          _buildDrawerItem(Icons.person_rounded, 'Mon profil', -6, color: _primaryColor),
          _buildDrawerItem(Icons.exit_to_app_rounded, 'Déconnexion', -1, color: _dangerColor, isLogout: true),

          // Version de l'application en bas du drawer
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper pour construire les items du drawer
  Widget _buildDrawerItem(IconData icon, String title, int index, {Color? color, bool isLogout = false}) {
    final bool isSelected = _currentIndex == index;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? (isSelected ? _primaryColor : Colors.grey.shade700)),
        title: Text(
          title,
          style: TextStyle(
              color: isSelected ? _primaryColor : Colors.grey.shade800,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal
          ),
        ),
        trailing: isSelected ? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _primaryColor) : null,
        onTap: () {
          Navigator.pop(context);
          if (isLogout) {
            _showLogoutDialog(context);
          } else if (index < 0) {
            // Gestion des options spéciales (négatives)
            _handleSpecialDrawerOptions(index);
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }

  /// Gère les options spéciales du drawer (index négatifs)
  void _handleSpecialDrawerOptions(int index) {
    switch (index) {
      case -1: // Déconnexion
        _showLogoutDialog(context);
        break;
      case -2: // Produits
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductsScreen()));
        break;
      case -3: // Catégories
        Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesScreen()));
        break;
      case -4: // Notifications
        Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
        break;
      case -5: // Stats utilisateurs
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserStatsScreen()));
        break;
      case -6: // Mon profil
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        break;
    }
  }

  /// Construit la barre de navigation inférieure
  Widget _buildBottomNavigationBar(bool isAdmin) {
    final List<BottomNavigationBarItem> navItems = [
      BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard_rounded),
          label: 'Accueil'
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows_outlined),
          activeIcon: Icon(Icons.compare_arrows_rounded),
          label: 'Mouvements'
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_outlined),
          activeIcon: Icon(Icons.qr_code_scanner_rounded),
          label: 'Scanner'
      ),
    ];

    if (isAdmin) {
      navItems.addAll([
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people_rounded),
            label: 'Utilisateurs'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment_rounded),
            label: 'Rapports'
        ),
      ]);
    }

    final validIndex = _currentIndex < navItems.length ? _currentIndex : 0;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2)
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: validIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: navItems,
      ),
    );
  }

  /// Construit le contenu principal en fonction de l'onglet sélectionné
  Widget _buildBodyContent(bool isAdmin) {
    final List<Widget> contentScreens = [
      _buildDashboardContent(isAdmin),
      _buildMovementsContent(isAdmin),
      _buildScannerContent(),
    ];

    if (isAdmin) {
      contentScreens.addAll([
        _buildUsersContent(),
        _buildReportsContent(),
      ]);
    }

    final validIndex = _currentIndex < contentScreens.length ? _currentIndex : 0;
    return contentScreens[validIndex];
  }

  /// ==========================================================================
  /// CONTENU DES DIFFÉRENTS ONGLETS
  /// ==========================================================================

  /// Construit le contenu principal du tableau de bord
  Widget _buildDashboardContent(bool isAdmin) {
    if (_isLoading) return _buildLoadingScreen();
    if (_errorMessage.isNotEmpty) {
      return ErrorRetryWidget(
        errorMessage: _errorMessage,
        onRetry: _refreshData,

      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: _primaryColor,
      backgroundColor: Colors.white,
      displacement: 40,
      edgeOffset: 20,
      child: CustomScrollView(
        slivers: [
          // En-tête avec informations utilisateur
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _buildHeaderSection(isAdmin),
            ),
          ),

          // Section des statistiques rapides
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildQuickStatsSection(isAdmin),
            ),
          ),

          // Grille des cartes du tableau de bord
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildDashboardGrid(isAdmin),
            ),
          ),

          // Section des catégories de produits
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildCategoriesSection(),
            ),
          ),

          // Section des mouvements récents
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildRecentMovementsSection(),
            ),
          ),

          // Section des statistiques administrateur (si admin)
          if (isAdmin) SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildAdminStatsSection(),
            ),
          ),

          // Section des statistiques utilisateurs (si admin)
          if (isAdmin) SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _buildUserStatsSection(),
            ),
          ),

          // Section des alertes de stock
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _buildStockAlertsSection(),
            ),
          ),
        ],
      ),
    );
  }

  /// Écran de chargement avec shimmer effect
  Widget _buildLoadingScreen() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildHeaderSectionShimmer(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _buildQuickStatsSectionShimmer(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: _buildDashboardGridShimmer(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: _buildRecentMovementsSectionShimmer(),
          ),
        ),
      ],
    );
  }

  /// Construit le contenu de l'onglet Mouvements
  Widget _buildMovementsContent(bool isAdmin) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.compare_arrows_rounded, size: 64, color: _primaryColor),
          SizedBox(height: 16),
          Text(
            isAdmin ? 'Tous les mouvements' : 'Mes mouvements',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800
            ),
          ),
          SizedBox(height: 8),
          Text(
            isAdmin ? 'Gestion de tous les mouvements de stock' : 'Gestion de mes mouvements de stock',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateToAddMovement(),
                child: Text('Nouveau mouvement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovementsScreen()),
                  );
                },
                child: Text(isAdmin ? 'Voir tous les mouvements' : 'Voir mes mouvements'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit le contenu de l'onglet Scanner
  Widget _buildScannerContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.qr_code_scanner_rounded, size: 64, color: _primaryColor),
          ),
          SizedBox(height: 24),
          Text(
            'Scanner un produit',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Utilisez la caméra pour scanner un code-barres et gérer rapidement votre stock',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BarcodeScanScreen(onBarcodeScanned: (String p1) {  },)),
              );
            },
            icon: Icon(Icons.camera_alt_rounded),
            label: Text('Ouvrir le scanner'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => _navigateToManualEntry(),
            child: Text('Saisie manuelle'),
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le contenu de l'onglet Utilisateurs (admin seulement)
  Widget _buildUsersContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.people_rounded, size: 64, color: _successColor),
          ),
          SizedBox(height: 24),
          Text(
            'Gestion des utilisateurs',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Administration des comptes utilisateurs et des permissions d\'accès',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UsersScreen()),
                  );
                },
                child: Text('Gérer les utilisateurs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _successColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleRoute(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddUserScreen()),
                  );
                },
                child: Text('Ajouter un utilisateur'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: _navigateToUserStats,
                child: Text('Voir les statistiques'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _infoColor,
                  side: BorderSide(color: _infoColor),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit le contenu de l'onglet Rapports (admin seulement)
  Widget _buildReportsContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assessment_rounded, size: 64, color: _accentColor),
          ),
          SizedBox(height: 24),
          Text(
            'Rapports et statistiques',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Analyses détaillées, exports de données et indicateurs de performance',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsViewScreen()),
                  );
                },
                child: Text('Voir les rapports'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsGenerateScreen()),
                  );
                },
                child: Text('Générer un rapport'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsExportScreen(baseUrl: '',)),
                  );
                },
                child: Text('Exporter les données'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// SECTIONS DU TABLEAU DE BORD
  /// ==========================================================================

  /// Header avec informations utilisateur
  Widget _buildHeaderSection(bool isAdmin) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _primaryColor,
            boxShadow: [
              BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3)
              )
            ],
          ),
          child: Icon(Icons.person_rounded, color: Colors.white, size: 28),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bonjour, ${currentUser?.firstName ?? 'Utilisateur'}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800
                  )),
              SizedBox(height: 4),
              Text('Tableau de bord ${isAdmin ? 'Administrateur' : 'Magasinier'}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _primaryColor.withOpacity(0.2), width: 1),
          ),
          child: Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor
              )),
        ),
      ],
    );
  }

  /// Version shimmer du header section (pour le loading)
  Widget _buildHeaderSectionShimmer() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 20,
                color: Colors.grey.shade300,
              ),
              SizedBox(height: 8),
              Container(
                width: 120,
                height: 16,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  /// Section des statistiques rapides
  Widget _buildQuickStatsSection(bool isAdmin) {
    final stockOverview = _dashboardData['stockOverview'] ?? {};
    final movementSummary = _dashboardData['movementSummary'] ?? {};

    List<Widget> statItems = [
      StatItem(
          icon: Icons.inventory_2_rounded,
          value: stockOverview['total_products']?.toString() ?? '0',
          label: 'Produits',
          color: _primaryColor
      ),
      StatItem(
          icon: Icons.warning_amber_rounded,
          value: stockOverview['low_stock_count']?.toString() ?? '0',
          label: 'Alertes',
          color: _warningColor
      ),
      StatItem(
          icon: Icons.trending_up_rounded,
          value: movementSummary['today_movements']?.toString() ?? '0',
          label: 'Aujourd\'hui',
          color: _successColor
      ),
    ];

    // Statistiques spécifiques selon le rôle
    if (isAdmin) {
      statItems.add(StatItem(
          icon: Icons.people_rounded,
          value: movementSummary['pending_count']?.toString() ?? '0',
          label: 'À valider',
          color: _infoColor
      ));
    } else {
      statItems.add(StatItem(
          icon: Icons.pending_actions_rounded,
          //value: movementSummary['pending_count']?.toString() || '0',
          label: 'En attente',
          color: _dangerColor, value: '',
      ));
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: statItems
      ),
    );
  }

  /// Version shimmer de la section des statistiques rapides
  Widget _buildQuickStatsSectionShimmer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) => Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        )),
      ),
    );
  }

  /// Grille des cartes du tableau de bord
  Widget _buildDashboardGrid(bool isAdmin) {
    final stockOverview = _dashboardData['stockOverview'] ?? {};
    final movementSummary = _dashboardData['movementSummary'] ?? {};
    final categories = _dashboardData['categories'] as List<dynamic>? ?? [];

    List<Widget> dashboardCards = [
      DashboardCard(
          title: 'Produits Total',
          value: stockOverview['total_products']?.toString() ?? '0',
          icon: Icons.inventory_2_rounded,
          color: _primaryColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductsScreen()),
            );
          }
      ),
      DashboardCard(
          title: 'Catégories',
          value: categories.length.toString(),
          icon: Icons.category_rounded,
          color: _accentColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CategoriesScreen()),
            );
          }
      ),
    ];

    if (isAdmin) {
      // Cartes spécifiques administrateur
      dashboardCards.addAll([
        DashboardCard(
            title: 'Mouvements Auj.',
            value: movementSummary['today_movements']?.toString() ?? '0',
            icon: Icons.compare_arrows_rounded,
            color: _successColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovementsScreen()),
              );
            }
        ),
        DashboardCard(
            title: 'À Valider',
            value: movementSummary['pending_count']?.toString() ?? '0',
            icon: Icons.pending_actions_rounded,
            color: _infoColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PendingApprovalsScreen()),
              );
            }
        ),
      ]);
    } else {
      // Cartes spécifiques magasinier
      dashboardCards.addAll([
        DashboardCard(
            title: 'Mes Mouvements',
            value: movementSummary['total_movements']?.toString() ?? '0',
            icon: Icons.compare_arrows_rounded,
            color: _successColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovementsScreen()),
              );
            }
        ),
        DashboardCard(
            title: 'En Attente',
            value: movementSummary['pending_count']?.toString() ?? '0',
            icon: Icons.pending_actions_rounded,
            color: _dangerColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovementsScreen()),
              );
            }
        ),
      ]);
    }

    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: dashboardCards,
    );
  }

  /// Version shimmer de la grille du tableau de bord
  Widget _buildDashboardGridShimmer() {
    return GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      children: List.generate(4, (index) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
      )),
    );
  }

  /// Section des catégories de produits
  Widget _buildCategoriesSection() {
    final categories = _dashboardData['categories'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.category_rounded, color: _accentColor, size: 22),
            SizedBox(width: 8),
            Text(
                'Catégories de produits',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800
                )
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoriesScreen()),
                  );
                },
                child: Text(
                    'Voir tout',
                    style: TextStyle(
                        color: _accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    )
                )
            ),
          ]),
          SizedBox(height: 12),
          if (categories.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.category_rounded, size: 48, color: Colors.grey.shade300),
                  SizedBox(height: 8),
                  Text(
                      'Aucune catégorie',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic
                      )
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map<Widget>((category) => FilterChip(
                label: Text('${category['name']} (${category['product_count']})'),
                onSelected: (bool value) {
                  _navigateToProductsByCategory(category['id']);
                },
                backgroundColor: _accentColor.withOpacity(0.1),
                selectedColor: _accentColor.withOpacity(0.2),
                labelStyle: TextStyle(color: Colors.grey.shade800),
                showCheckmark: false,
                selected: false,
              )).toList(),
            ),
        ],
      ),
    );
  }

  /// Section des statistiques administrateur
  Widget _buildAdminStatsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.purple.shade100.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.admin_panel_settings_rounded, color: _infoColor, size: 22),
            SizedBox(width: 8),
            Text(
                'Vue Administrateur',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _infoColor
                )
            ),
          ]),
          SizedBox(height: 12),
          Text(
            'Fonctionnalités réservées aux administrateurs',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: Icon(Icons.people_rounded, size: 18, color: _infoColor),
                label: Text('Utilisateurs'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UsersScreen()),
                  );
                },
                backgroundColor: _infoColor.withOpacity(0.1),
              ),
              ActionChip(
                avatar: Icon(Icons.assessment_rounded, size: 18, color: _infoColor),
                label: Text('Rapports'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportsScreen()),
                  );
                },
                backgroundColor: _infoColor.withOpacity(0.1),
              ),
              ActionChip(
                avatar: Icon(Icons.bar_chart_rounded, size: 18, color: _infoColor),
                label: Text('Stats utilisateurs'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserStatsScreen()),
                  );
                },
                backgroundColor: _infoColor.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section des statistiques utilisateurs (admin seulement)
  Widget _buildUserStatsSection() {
    final userProvider = Provider.of<UserProvider>(context);
    final stats = userProvider.userStats;

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: Colors.blue, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Statistiques Utilisateurs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserStatsScreen()),
                  );
                }, // naviguer vers détails
                child: const Text('Voir détail', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('${stats['totalUsers'] ?? 0}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Text('Utilisateurs', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text('${stats['activeUsers'] ?? 0}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                  const Text('Actifs', style: TextStyle(color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Text('${stats['newUsers'] ?? 0}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange)),
                  const Text('Nouveaux (30j)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Admins: ${stats['admins'] ?? 0}'),
                ],
              ),
              Column(
                children: [
                  Text('Magasiniers: ${stats['magasiniers'] ?? 0}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  /// Section des mouvements récents
  Widget _buildRecentMovementsSection() {
    final recentMovements = _dashboardData['recentMovements'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.history_rounded, color: _primaryColor, size: 22),
            SizedBox(width: 8),
            Text(
                'Mouvements Récents',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800
                )
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MovementsScreen()),
                  );
                },
                child: Text(
                    'Voir tout',
                    style: TextStyle(
                        color: _primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    )
                )
            ),
          ]),
          SizedBox(height: 12),
          if (recentMovements.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.history_rounded, size: 48, color: Colors.grey.shade300),
                  SizedBox(height: 8),
                  Text(
                      'Aucun mouvement récent',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic
                      )
                  ),
                ],
              ),
            )
          else
            Column(
              children: recentMovements.map<Widget>((jsonMovement) {
                final movement = Movement.fromJson(jsonMovement as Map<String, dynamic>);
                return MovementItem(movement: movement);
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Version shimmer de la section des mouvements récents
  Widget _buildRecentMovementsSectionShimmer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 22,
              height: 22,
              color: Colors.grey.shade300,
            ),
            SizedBox(width: 8),
            Container(
              width: 150,
              height: 18,
              color: Colors.grey.shade300,
            ),
            Spacer(),
            Container(
              width: 60,
              height: 18,
              color: Colors.grey.shade300,
            ),
          ]),
          SizedBox(height: 12),
          Column(
            children: List.generate(3, (index) => Container(
              margin: EdgeInsets.only(bottom: 8),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            )),
          ),
        ],
      ),
    );
  }

  /// Section des alertes de stock
  Widget _buildStockAlertsSection() {
    final lowStockAlerts = _dashboardData['lowStockAlerts'] ?? [];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.orange.shade100.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 3)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.warning_amber_rounded, color: _warningColor, size: 22),
            SizedBox(width: 8),
            Text(
                'Alertes Stock Bas',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800
                )
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductsScreen()),
                  );
                },
                child: Text(
                    'Voir tout',
                    style: TextStyle(
                        color: _warningColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                    )
                )
            ),
          ]),
          SizedBox(height: 12),
          if (lowStockAlerts.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.inventory_2_rounded, size: 48, color: Colors.grey.shade300),
                  SizedBox(height: 8),
                  Text(
                      'Aucune alerte de stock',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic
                      )
                  ),
                ],
              ),
            )
          else
            Column(
              children: lowStockAlerts.map<Widget>((product) => ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _warningColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.inventory_2_rounded, color: _warningColor, size: 20),
                ),
                title: Text(
                  product['name'] ?? 'Produit inconnu',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                    'Stock: ${product['quantity']} / Seuil: ${product['threshold']}',
                    style: TextStyle(color: _dangerColor)
                ),
                trailing: Chip(
                    label: Text(
                        '${product['category_name'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 10, color: Colors.white)
                    ),
                    backgroundColor: _primaryColor
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  /// ==========================================================================
  /// BOUTON FLOTTANT ET NAVIGATION
  /// ==========================================================================

  /// Construit le bouton flottant contextuel
  Widget _buildFloatingActionButton(bool isAdmin) {
    final int validIndex = _currentIndex;
    final int maxIndex = isAdmin ? 4 : 2;

    if (validIndex > maxIndex) return SizedBox.shrink();

    VoidCallback? onPressed;
    IconData icon;
    String tooltip;
    Color? backgroundColor;

    switch (validIndex) {
    case 0: // Dashboard
    onPressed = _showQuickActionsMenu;
    icon = Icons.add_rounded;
    tooltip = 'Actions rapides';
    backgroundColor = _primaryColor;
    break;
    case 1: // Mouvements
    onPressed = _navigateToAddMovement;
    icon = Icons.add_rounded;
    tooltip = 'Nouveau mouvement';
    backgroundColor = _primaryColor;
    break;
    case 2: // Scanner
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => BarcodeScanScreen(onBarcodeScanned: (String p1) {  },)),
    );
    };
    icon = Icons.qr_code_scanner_rounded;
    tooltip = 'Scanner';
    backgroundColor = _primaryColor;
    break;
    case 3: // Utilisateurs (admin)
    onPressed = isAdmin ? () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => AddUserScreen()),
    );
    } : null;
    icon = Icons.person_add_rounded;
    tooltip = 'Ajouter utilisateur';
    backgroundColor = _successColor;
    break;
    case 4: // Rapports (admin)
    onPressed = isAdmin ? _navigateToGenerateReport : null;
    icon = Icons.assignment_rounded;
    tooltip = 'Générer rapport';
    backgroundColor = _accentColor;
    break;
    default:
    onPressed = _showQuickActionsMenu;
    icon = Icons.add_rounded;
    tooltip = 'Actions rapides';
    backgroundColor = _primaryColor;
    }

    if (onPressed == null) return SizedBox.shrink();

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      elevation: 4,
      tooltip: tooltip,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Icon(icon, size: 28),
    );
  }

  /// Affiche le menu des actions rapides
  void _showQuickActionsMenu() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAdmin = authProvider.user?.role == 'administrateur';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Text(
              'Actions Rapides',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_rounded, color: _primaryColor),
              ),
              title: Text('Nouveau Produit', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Ajouter un nouveau produit au stock'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductFormScreen()),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.compare_arrows_rounded, color: _successColor),
              ),
              title: Text('Nouveau Mouvement', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Enregistrer une entrée/sortie de stock'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddMovement();
              },
            ),
            if (isAdmin) ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _infoColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_add_rounded, color: _infoColor),
              ),
              title: Text('Nouvel Utilisateur', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Créer un compte utilisateur'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddUserScreen()),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bar_chart_rounded, color: _accentColor),
              ),
              title: Text('Générer Rapport', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Créer un rapport d\'activité'),
              onTap: () {
                Navigator.pop(context);
                _navigateToReports();
              },
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fermer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  /// ==========================================================================
  /// MÉTHODES DE NAVIGATION
  /// ==========================================================================

  void _navigateToProductsScreen() => Navigator.pushNamed(context, '/products');
  void _navigateToMovementsScreen({bool isAdmin = true}) => Navigator.pushNamed(context, '/movements', arguments: {'isAdmin': isAdmin});
  void _navigateToAddMovement() => Navigator.pushNamed(context, '/add-movement');
  void _navigateToPendingApprovals() => Navigator.pushNamed(context, '/pending-approvals');
  void _navigateToMyPendingMovements() => Navigator.pushNamed(context, '/movements', arguments: {'showPendingOnly': true});
  void _navigateToLowStockProducts() => Navigator.pushNamed(context, '/products', arguments: {'showLowStock': true});
  void _navigateToScanner() => Navigator.pushNamed(context, '/scanner');
  void _navigateToManualEntry() => Navigator.pushNamed(context, '/manual-entry');
  void _navigateToUserManagement() => Navigator.pushNamed(context, '/users');
  void _navigateToAddUser() => Navigator.pushNamed(context, '/add-user');
  void _navigateToReports() => Navigator.pushNamed(context, '/reports');
  void _navigateToGenerateReport() => Navigator.pushNamed(context, '/generate-report');
  void _navigateToExportData() => Navigator.pushNamed(context, '/export-data');
  void _navigateToAddProduct() => Navigator.pushNamed(context, '/add-product');
  void _navigateToNotifications() => Navigator.pushNamed(context, '/notifications');
  void _navigateToSettings() => Navigator.pushNamed(context, '/settings');
  void _navigateToCategories() => Navigator.pushNamed(context, '/categories');
  void _navigateToUserStats() => Navigator.pushNamed(context, '/user-stats');
  void _navigateToProductsByCategory(int categoryId) => Navigator.pushNamed(context, '/products', arguments: {'categoryId': categoryId});

  /// Affiche le dialogue de déconnexion
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout_rounded, size: 48, color: _dangerColor),
              SizedBox(height: 16),
              Text(
                'Déconnexion',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Êtes-vous sûr de vouloir vous déconnecter?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Annuler'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<AuthProvider>(context, listen: false).logout();
                      },
                      child: Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dangerColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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

  OutlinedBorder? RoundedRectangleRoute({required BorderRadius borderRadius}) {}
}