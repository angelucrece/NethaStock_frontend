// // import 'package:flutter/material.dart';
// // import 'package:nethastock/models/user.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter/scheduler.dart' show timeDilation;
// // import '../providers/auth_provider.dart';
// // import '../providers/product_provider.dart';
// // import '../providers/movement_provider.dart';
// // import '../providers/user_provider.dart';
// // import '../widgets/dashboard_card.dart';
// // import 'products_screen.dart';
// // import 'movements_screen.dart';
// // import 'users_screen.dart';
// // import 'reports_screen.dart';
// // import 'pending_approvals_screen.dart';
// // import 'profile_screen.dart';
// //
// // class DashboardAdminScreen extends StatefulWidget {
// //   @override
// //   _DashboardAdminScreenState createState() => _DashboardAdminScreenState();
// // }
// //
// // class _DashboardAdminScreenState extends State<DashboardAdminScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _fadeAnimation;
// //   late Animation<double> _scaleAnimation;
// //   late Animation<Offset> _slideAnimation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // Configuration des animations
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: Duration(milliseconds: 1200),
// //     );
// //
// //     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _animationController,
// //         curve: Interval(0.2, 1.0, curve: Curves.easeOutCubic),
// //       ),
// //     );
// //
// //     _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
// //       CurvedAnimation(
// //         parent: _animationController,
// //         curve: Curves.easeOutBack,
// //       ),
// //     );
// //
// //     _slideAnimation = Tween<Offset>(
// //       begin: Offset(0, 0.1),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: _animationController,
// //         curve: Curves.easeOutQuint,
// //       ),
// //     );
// //
// //     // Démarrage de l'animation
// //     Future.delayed(Duration(milliseconds: 200), () {
// //       _animationController.forward();
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final productProvider = Provider.of<ProductProvider>(context);
// //     final movementProvider = Provider.of<MovementProvider>(context);
// //     final userProvider = Provider.of<UserProvider>(context);
// //     final authProvider = Provider.of<AuthProvider>(context);
// //
// //     final User = authProvider.user;
// //     final pendingMovements = movementProvider.pendingMovements.length;
// //     final todayMovements = movementProvider.movements
// //         .where((m) => m.date.day == DateTime.now().day).length;
// //     final activeUsers = userProvider.users.where((user) => user.isActive).length;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: _buildAppBar(authProvider),
// //       drawer: _buildDrawer(context, authProvider),
// //       body: AnimatedBuilder(
// //         animation: _animationController,
// //         builder: (context, child) {
// //           return Transform(
// //             transform: Matrix4.identity()
// //               ..scale(_scaleAnimation.value),
// //             alignment: Alignment.center,
// //             child: Opacity(
// //               opacity: _fadeAnimation.value,
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   gradient: RadialGradient(
// //                     center: Alignment.topRight,
// //                     radius: 1.5,
// //                     colors: [
// //                       Colors.blue.shade50.withOpacity(0.3),
// //                       Colors.grey.shade100.withOpacity(0.7),
// //                     ],
// //                     stops: [0.1, 0.9],
// //                   ),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(20),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       // Header Section
// //                       _buildHeaderSection(User),
// //
// //                       SizedBox(height: 30),
// //
// //                       // Quick Stats Cards
// //                       _buildQuickStatsSection(
// //                           productProvider.products.length,
// //                           productProvider.lowStockProducts.length,
// //                           todayMovements,
// //                           pendingMovements,
// //                           activeUsers
// //                       ),
// //
// //                       SizedBox(height: 30),
// //
// //                       // Main Dashboard Grid
// //                       Expanded(
// //                         child: SlideTransition(
// //                           position: _slideAnimation,
// //                           child: _buildDashboardGrid(
// //                               context,
// //                               productProvider,
// //                               pendingMovements,
// //                               todayMovements,
// //                               activeUsers
// //                           ),
// //                         ),
// //                       ),
// //
// //                       SizedBox(height: 25),
// //
// //                       // Admin Actions
// //                       _buildAdminActionsSection(context),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //
// //       // Floating Action Button for Quick Actions
// //       floatingActionButton: _buildFloatingActionButton(context),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
// //     );
// //   }
// //
// //   /// Premium AppBar with Glass Morphism Effect
// //   PreferredSizeWidget _buildAppBar(AuthProvider authProvider) {
// //     return AppBar(
// //       title: RichText(
// //         text: TextSpan(
// //           children: [
// //             TextSpan(
// //               text: 'NetHa',
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.w800,
// //                 color: Colors.white,
// //                 letterSpacing: 1.2,
// //               ),
// //             ),
// //             TextSpan(
// //               text: 'Stock',
// //               style: TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.w300,
// //                 color: Colors.white.withOpacity(0.9),
// //                 letterSpacing: 1.1,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       backgroundColor: Colors.blue.shade800,
// //       elevation: 0,
// //       flexibleSpace: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [
// //               Colors.blue.shade800,
// //               Colors.blue.shade600,
// //             ],
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.blue.shade900.withOpacity(0.4),
// //               blurRadius: 15,
// //               offset: Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //       ),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.only(
// //           bottomLeft: Radius.circular(25),
// //           bottomRight: Radius.circular(25),
// //         ),
// //       ),
// //       actions: [
// //         IconButton(
// //           icon: Container(
// //             padding: EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: Colors.white.withOpacity(0.2),
// //             ),
// //             child: Icon(Icons.notifications_active_rounded, size: 22),
// //           ),
// //           onPressed: () {},
// //           tooltip: 'Notifications',
// //         ),
// //         IconButton(
// //           icon: Container(
// //             padding: EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: Colors.white.withOpacity(0.2),
// //             ),
// //             child: Icon(Icons.logout_rounded, size: 22),
// //           ),
// //           onPressed: () => _showLogoutDialog(context, authProvider),
// //           tooltip: 'Déconnexion',
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Enhanced Header with Glass Morphism
// //   Widget _buildHeaderSection(User? currentUser) {
// //     return Container(
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.9),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.blue.shade100.withOpacity(0.6),
// //             blurRadius: 20,
// //             offset: Offset(0, 5),
// //           ),
// //         ],
// //         border: Border.all(
// //           color: Colors.white.withOpacity(0.5),
// //           width: 1,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           // Animated Avatar
// //           Container(
// //             width: 60,
// //             height: 60,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //                 colors: [
// //                   Colors.blue.shade600,
// //                   Colors.blue.shade400,
// //                 ],
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.blue.shade300.withOpacity(0.4),
// //                   blurRadius: 15,
// //                   spreadRadius: 2,
// //                   offset: Offset(0, 3),
// //                 ),
// //               ],
// //             ),
// //             child: Icon(
// //               Icons.admin_panel_settings_rounded,
// //               color: Colors.white,
// //               size: 30,
// //             ),
// //           ),
// //
// //           SizedBox(width: 16),
// //
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 RichText(
// //                   text: TextSpan(
// //                     text: 'Bonjour, ',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.w500,
// //                       color: Colors.grey.shade700,
// //                     ),
// //                     children: [
// //                       TextSpan(
// //                         text: currentUser?.firstName ?? 'Admin',
// //                         style: TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.w700,
// //                           color: Colors.blue.shade800,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 SizedBox(height: 4),
// //                 Text(
// //                   'Gérez votre inventaire en toute simplicité',
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.grey.shade600,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Date and Time Badge
// //           Container(
// //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //             decoration: BoxDecoration(
// //               color: Colors.blue.shade50,
// //               borderRadius: BorderRadius.circular(12),
// //               border: Border.all(
// //                 color: Colors.blue.shade100,
// //                 width: 1,
// //               ),
// //             ),
// //             child: Text(
// //               '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //                 color: Colors.blue.shade700,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Glass Morphism Quick Stats Section
// //   Widget _buildQuickStatsSection(int totalProducts, int lowStock, int todayMovements, int pending, int activeUsers) {
// //     return Container(
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.8),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.blue.shade100.withOpacity(0.5),
// //             blurRadius: 15,
// //             offset: Offset(0, 5),
// //           ),
// //         ],
// //         border: Border.all(
// //           color: Colors.white.withOpacity(0.6),
// //           width: 1,
// //         ),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //         children: [
// //           _buildGlassStatItem(Icons.inventory_2_rounded, totalProducts, 'Produits', Colors.blue),
// //           _buildGlassStatItem(Icons.warning_amber_rounded, lowStock, 'Alertes', Colors.orange),
// //           _buildGlassStatItem(Icons.trending_up_rounded, todayMovements, 'Mouvements', Colors.green),
// //           _buildGlassStatItem(Icons.pending_actions_rounded, pending, 'En attente', Colors.red),
// //           _buildGlassStatItem(Icons.people_alt_rounded, activeUsers, 'Utilisateurs', Colors.purple),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Glass Morphism Stat Item
// //   Widget _buildGlassStatItem(IconData icon, int value, String label, Color color) {
// //     return Column(
// //       children: [
// //         Container(
// //           width: 50,
// //           height: 50,
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.1),
// //             shape: BoxShape.circle,
// //             border: Border.all(
// //               color: color.withOpacity(0.3),
// //               width: 1.5,
// //             ),
// //           ),
// //           child: Icon(icon, color: color, size: 24),
// //         ),
// //         SizedBox(height: 8),
// //         Text(
// //           value.toString(),
// //           style: TextStyle(
// //             fontSize: 16,
// //             fontWeight: FontWeight.w800,
// //             color: Colors.grey.shade800,
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 11,
// //             color: Colors.grey.shade600,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Enhanced Dashboard Grid with Neumorphism Effect
// //   Widget _buildDashboardGrid(
// //       BuildContext context,
// //       ProductProvider productProvider,
// //       int pendingMovements,
// //       int todayMovements,
// //       int activeUsers
// //       ) {
// //     return GridView(
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
// //         crossAxisSpacing: 20,
// //         mainAxisSpacing: 20,
// //         childAspectRatio: 1.1,
// //       ),
// //       children: [
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Produits Total',
// //             value: productProvider.products.length.toString(),
// //             icon: Icons.inventory_2_rounded,
// //             color: Colors.blue,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.blue.shade400, Colors.blue.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, ProductsScreen()),
// //           ),
// //           0,
// //         ),
// //
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Alertes Stock',
// //             value: productProvider.lowStockProducts.length.toString(),
// //             icon: Icons.warning_amber_rounded,
// //             color: Colors.orange,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.orange.shade400, Colors.orange.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, ProductsScreen(showLowStock: true)),
// //           ),
// //           1,
// //         ),
// //
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Mouvements Auj.',
// //             value: todayMovements.toString(),
// //             icon: Icons.compare_arrows_rounded,
// //             color: Colors.green,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.green.shade400, Colors.green.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, MovementsScreen()),
// //           ),
// //           2,
// //         ),
// //
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Validations',
// //             value: pendingMovements.toString(),
// //             icon: Icons.pending_actions_rounded,
// //             color: Colors.red,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.red.shade400, Colors.red.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, PendingApprovalsScreen()),
// //           ),
// //           3,
// //         ),
// //
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Utilisateurs',
// //             value: activeUsers.toString(),
// //             icon: Icons.people_alt_rounded,
// //             color: Colors.purple,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.purple.shade400, Colors.purple.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, UsersScreen()),
// //           ),
// //           4,
// //         ),
// //
// //         _buildNeumorphicCard(
// //           context,
// //           DashboardCard(
// //             title: 'Rapports',
// //             value: 'Voir',
// //             icon: Icons.analytics_rounded,
// //             color: Colors.indigo,
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Colors.indigo.shade400, Colors.indigo.shade600],
// //             ),
// //             onTap: () => _navigateWithAnimation(context, ReportsScreen()),
// //           ),
// //           5,
// //         ),
// //       ],
// //     );
// //   }
// //
// //   /// Neumorphic Card with Animation
// //   Widget _buildNeumorphicCard(BuildContext context, Widget child, int index) {
// //     final animationDelay = index * 0.15;
// //
// //     return AnimatedOpacity(
// //       opacity: _animationController.value > animationDelay ? 1 : 0,
// //       duration: Duration(milliseconds: 600),
// //       curve: Curves.easeOutBack,
// //       child: Transform.translate(
// //         offset: Offset(0, _animationController.value > animationDelay ? 0 : 30),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(20),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.white,
// //                 offset: Offset(-4, -4),
// //                 blurRadius: 8,
// //                 spreadRadius: 1,
// //               ),
// //               BoxShadow(
// //                 color: Colors.grey.shade300,
// //                 offset: Offset(4, 4),
// //                 blurRadius: 8,
// //                 spreadRadius: 1,
// //               ),
// //             ],
// //           ),
// //           child: ClipRRect(
// //             borderRadius: BorderRadius.circular(20),
// //             child: child,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Enhanced Admin Actions with Glass Buttons
// //   Widget _buildAdminActionsSection(BuildContext context) {
// //     return Container(
// //       padding: EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.8),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.blue.shade100.withOpacity(0.4),
// //             blurRadius: 15,
// //             offset: Offset(0, 5),
// //           ),
// //         ],
// //         border: Border.all(
// //           color: Colors.white.withOpacity(0.6),
// //           width: 1,
// //         ),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(Icons.rocket_launch_rounded, color: Colors.blue.shade800, size: 24),
// //               SizedBox(width: 8),
// //               Text(
// //                 'Actions Rapides',
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w700,
// //                   color: Colors.blue.shade800,
// //                   letterSpacing: 0.5,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 16),
// //           Wrap(
// //             spacing: 12,
// //             runSpacing: 12,
// //             children: [
// //               _buildGlassButton(
// //                 context: context,
// //                 icon: Icons.people_rounded,
// //                 label: 'Utilisateurs',
// //                 color: Colors.blue,
// //                 onPressed: () => _navigateWithAnimation(context, UsersScreen()),
// //               ),
// //               _buildGlassButton(
// //                 context: context,
// //                 icon: Icons.category_rounded,
// //                 label: 'Catégories',
// //                 color: Colors.teal,
// //                 onPressed: () {},
// //               ),
// //               _buildGlassButton(
// //                 context: context,
// //                 icon: Icons.inventory_2_rounded,
// //                 label: 'Produits',
// //                 color: Colors.green,
// //                 onPressed: () => _navigateWithAnimation(context, ProductsScreen()),
// //               ),
// //               _buildGlassButton(
// //                 context: context,
// //                 icon: Icons.analytics_rounded,
// //                 label: 'Rapports',
// //                 color: Colors.orange,
// //                 onPressed: () => _navigateWithAnimation(context, ReportsScreen()),
// //               ),
// //               _buildGlassButton(
// //                 context: context,
// //                 icon: Icons.approval_rounded,
// //                 label: 'Validations',
// //                 color: Colors.red,
// //                 onPressed: () => _navigateWithAnimation(context, PendingApprovalsScreen()),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   /// Glass Morphism Button
// //   Widget _buildGlassButton({
// //     required BuildContext context,
// //     required IconData icon,
// //     required String label,
// //     required Color color,
// //     required VoidCallback onPressed,
// //   }) {
// //     return Material(
// //       color: Colors.transparent,
// //       child: InkWell(
// //         onTap: onPressed,
// //         borderRadius: BorderRadius.circular(15),
// //         child: Container(
// //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.1),
// //             borderRadius: BorderRadius.circular(15),
// //             border: Border.all(
// //               color: color.withOpacity(0.3),
// //               width: 1.5,
// //             ),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.white.withOpacity(0.6),
// //                 offset: Offset(-2, -2),
// //                 blurRadius: 4,
// //               ),
// //               BoxShadow(
// //                 color: color.withOpacity(0.1),
// //                 offset: Offset(2, 2),
// //                 blurRadius: 4,
// //               ),
// //             ],
// //           ),
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Icon(icon, color: color, size: 18),
// //               SizedBox(width: 6),
// //               Text(
// //                 label,
// //                 style: TextStyle(
// //                   color: Colors.grey.shade800,
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 13,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   /// Premium Floating Action Button
// //   Widget _buildFloatingActionButton(BuildContext context) {
// //     return FloatingActionButton(
// //       onPressed: () {
// //         // Quick action menu
// //       },
// //       backgroundColor: Colors.blue.shade800,
// //       foregroundColor: Colors.white,
// //       elevation: 8,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: Icon(Icons.add_rounded, size: 28),
// //     );
// //   }
// //
// //   void _navigateWithAnimation(BuildContext context, Widget page) {
// //     Navigator.push(context, PageRouteBuilder(
// //       pageBuilder: (context, animation, secondaryAnimation) => page,
// //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
// //         return FadeTransition(
// //           opacity: animation,
// //           child: child,
// //         );
// //       },
// //       transitionDuration: Duration(milliseconds: 300),
// //     ));
// //   }
// //
// //   void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           backgroundColor: Colors.transparent,
// //           child: Container(
// //             padding: EdgeInsets.all(24),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(24),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.2),
// //                   blurRadius: 20,
// //                   offset: Offset(0, 10),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(
// //                   Icons.logout_rounded,
// //                   color: Colors.blue.shade800,
// //                   size: 48,
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'Déconnexion',
// //                   style: TextStyle(
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.w800,
// //                     color: Colors.grey.shade800,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   'Êtes-vous sûr de vouloir vous déconnecter?',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Colors.grey.shade600,
// //                   ),
// //                 ),
// //                 SizedBox(height: 24),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                   children: [
// //                     TextButton(
// //                       onPressed: () => Navigator.pop(context),
// //                       child: Text('Annuler', style: TextStyle(color: Colors.grey.shade600)),
// //                       style: TextButton.styleFrom(
// //                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //                       ),
// //                     ),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.pop(context);
// //                         authProvider.logout();
// //                       },
// //                       child: Text('Déconnexion'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.blue.shade800,
// //                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   /// Premium Drawer with Glass Morphism
// //   Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
// //     return Drawer(
// //       backgroundColor: Colors.transparent,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [
// //               Colors.blue.shade50.withOpacity(0.9),
// //               Colors.grey.shade100.withOpacity(0.9),
// //             ],
// //           ),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 20,
// //               offset: Offset(-5, 0),
// //             ),
// //           ],
// //         ),
// //         child: ListView(
// //           padding: EdgeInsets.zero,
// //           children: [
// //             _buildDrawerHeader(),
// //             // ... Drawer items (similar to previous implementation but with glass effect)
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDrawerHeader() {
// //     return Container(
// //       height: 200,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [
// //             Colors.blue.shade800,
// //             Colors.blue.shade600,
// //           ],
// //         ),
// //         borderRadius: BorderRadius.only(
// //           bottomRight: Radius.circular(30),
// //         ),
// //       ),
// //       child: Stack(
// //         children: [
// //           Positioned(
// //             top: -30,
// //             right: -30,
// //             child: Icon(
// //               Icons.admin_panel_settings_rounded,
// //               size: 150,
// //               color: Colors.white.withOpacity(0.1),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.all(20),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   width: 70,
// //                   height: 70,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.white,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.blue.shade300.withOpacity(0.4),
// //                         blurRadius: 15,
// //                         spreadRadius: 2,
// //                       ),
// //                     ],
// //                   ),
// //                   child: Icon(
// //                     Icons.admin_panel_settings_rounded,
// //                     color: Colors.blue.shade800,
// //                     size: 35,
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 Text(
// //                   'Espace Admin',
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w800,
// //                   ),
// //                 ),
// //                 Text(
// //                   'Gestion complète',
// //                   style: TextStyle(
// //                     color: Colors.white.withOpacity(0.9),
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:nethastock/models/user.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/product_provider.dart';
// import '../providers/movement_provider.dart';
// import '../providers/user_provider.dart';
// import '../widgets/dashboard_card.dart';
// import 'products_screen.dart';
// import 'movements_screen.dart';
// import 'users_screen.dart';
// import 'reports_screen.dart';
// import 'pending_approvals_screen.dart';
// import 'profile_screen.dart';
//
// class DashboardAdminScreen extends StatefulWidget {
//   @override
//   _DashboardAdminScreenState createState() => _DashboardAdminScreenState();
// }
//
// class _DashboardAdminScreenState extends State<DashboardAdminScreen> {
//   int _currentIndex = 0;
//   final PageController _pageController = PageController();
//
//   // Liste des écrans accessibles via la bottom navigation
//   final List<Widget> _screens = [
//     DashboardContent(),
//     ProductsScreen(),
//     MovementsScreen(),
//     UsersScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: _currentIndex == 0 ? _buildAppBar() : null,
//       body: PageView(
//         controller: _pageController,
//         physics: NeverScrollableScrollPhysics(), // Désactive le swipe
//         children: _screens,
//         onPageChanged: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }
//
//   /// AppBar uniquement pour le dashboard
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       title: Text(
//         'NetHaStock Admin',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: Colors.blue.shade800,
//       elevation: 1,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.notifications, size: 22),
//           onPressed: () {},
//           tooltip: 'Notifications',
//         ),
//       ],
//     );
//   }
//
//   /// Bottom Navigation Bar optimisée pour mobile
//   Widget _buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             _pageController.jumpToPage(index);
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.blue.shade800,
//         unselectedItemColor: Colors.grey.shade600,
//         selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//         unselectedLabelStyle: TextStyle(fontSize: 11),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_rounded, size: 24),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory_2_rounded, size: 24),
//             label: 'Produits',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.compare_arrows_rounded, size: 24),
//             label: 'Mouvements',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people_rounded, size: 24),
//             label: 'Utilisateurs',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_rounded, size: 24),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Contenu principal du Dashboard (allégé pour mobile)
// class DashboardContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final productProvider = Provider.of<ProductProvider>(context);
//     final movementProvider = Provider.of<MovementProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     final User = authProvider.user;
//     final pendingMovements = movementProvider.pendingMovements.length;
//     final todayMovements = movementProvider.movements
//         .where((m) => m.date.day == DateTime.now().day)
//         .length;
//     final activeUsers = userProvider.users.where((user) => user.isActive).length;
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header simplifié
//           _buildHeaderSection(User),
//
//           SizedBox(height: 20),
//
//           // Statistiques rapides en ligne simple
//           _buildQuickStatsRow(
//             productProvider.products.length,
//             productProvider.lowStockProducts.length,
//             todayMovements,
//             pendingMovements,
//           ),
//
//           SizedBox(height: 24),
//
//           // Grille de cartes (2 colonnes sur mobile)
//           _buildDashboardGrid(
//               context,
//               productProvider,
//               pendingMovements,
//               todayMovements,
//               activeUsers
//           ),
//
//           SizedBox(height: 20),
//
//           // Actions rapides simplifiées
//           _buildAdminActionsSection(context),
//
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   /// Header simplifié pour mobile
//   Widget _buildHeaderSection(User? currentUser) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Bonjour, ${currentUser?.firstName ?? 'Admin'}',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: Colors.blue.shade800,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           'Tableau de bord administrateur',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Statistiques rapides optimisées pour mobile
//   Widget _buildQuickStatsRow(int totalProducts, int lowStock, int todayMovements, int pending) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildSimpleStatItem(Icons.inventory_2, totalProducts, 'Produits', Colors.blue),
//           _buildSimpleStatItem(Icons.warning, lowStock, 'Alertes', Colors.orange),
//           _buildSimpleStatItem(Icons.trending_up, todayMovements, 'Aujourd\'hui', Colors.green),
//           _buildSimpleStatItem(Icons.pending, pending, 'En attente', Colors.red),
//         ],
//       ),
//     );
//   }
//
//   /// Élément de statistique simplifié
//   Widget _buildSimpleStatItem(IconData icon, int value, String label, Color color) {
//     return Column(
//       children: [
//         Icon(icon, color: color, size: 20),
//         SizedBox(height: 4),
//         Text(
//           value.toString(),
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         SizedBox(height: 2),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Grille de cartes optimisée pour mobile
//   Widget _buildDashboardGrid(
//       BuildContext context,
//       ProductProvider productProvider,
//       int pendingMovements,
//       int todayMovements,
//       int activeUsers
//       ) {
//     return GridView(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.1,
//       ),
//       children: [
//         DashboardCard(
//           title: 'Produits',
//           value: productProvider.products.length.toString(),
//           icon: Icons.inventory_2,
//           color: Colors.blue,
//           onTap: () => _navigateTo(context, ProductsScreen()),
//         ),
//
//         DashboardCard(
//           title: 'Alertes',
//           value: productProvider.lowStockProducts.length.toString(),
//           icon: Icons.warning,
//           color: Colors.orange,
//           onTap: () => _navigateTo(context, ProductsScreen(showLowStock: true)),
//         ),
//
//         DashboardCard(
//           title: 'Mouvements',
//           value: todayMovements.toString(),
//           icon: Icons.compare_arrows,
//           color: Colors.green,
//           onTap: () => _navigateTo(context, MovementsScreen()),
//         ),
//
//         DashboardCard(
//           title: 'Validations',
//           value: pendingMovements.toString(),
//           icon: Icons.pending_actions,
//           color: Colors.red,
//           onTap: () => _navigateTo(context, PendingApprovalsScreen()),
//         ),
//       ],
//     );
//   }
//
//   /// Actions administratives simplifiées
//   Widget _buildAdminActionsSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Actions Rapides',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.blue.shade800,
//           ),
//         ),
//         SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             _buildSimpleActionChip(
//               icon: Icons.people,
//               label: 'Utilisateurs',
//               color: Colors.blue,
//               onPressed: () => _navigateTo(context, UsersScreen()),
//             ),
//             _buildSimpleActionChip(
//               icon: Icons.inventory_2,
//               label: 'Produits',
//               color: Colors.green,
//               onPressed: () => _navigateTo(context, ProductsScreen()),
//             ),
//             _buildSimpleActionChip(
//               icon: Icons.bar_chart,
//               label: 'Rapports',
//               color: Colors.orange,
//               onPressed: () => _navigateTo(context, ReportsScreen()),
//             ),
//             _buildSimpleActionChip(
//               icon: Icons.approval,
//               label: 'Validations',
//               color: Colors.red,
//               onPressed: () => _navigateTo(context, PendingApprovalsScreen()),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   /// Bouton d'action simplifié
//   Widget _buildSimpleActionChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return ActionChip(
//       avatar: Icon(icon, color: Colors.white, size: 16),
//       label: Text(
//         label,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       backgroundColor: color,
//       onPressed: onPressed,
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }
//
//   /// Navigation simple sans animation lourde
//   void _navigateTo(BuildContext context, Widget page) {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }
// }
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
//   // États pour gérer le chargement, les erreurs et les données
//   late Map<String, dynamic> _dashboardData;
//   bool _isLoading = true;
//   String _errorMessage = '';
//   int _currentIndex = 0; // Index pour la bottom navigation
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialisation des données
//     _dashboardData = {};
//     // Chargement des données au démarrage
//     _loadDashboardData();
//   }
//
//   // Méthode pour charger les données du dashboard
//   Future<void> _loadDashboardData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       final response = await ApiService().getDashboardData();
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
//   // Méthode pour rafraîchir les données
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
//   /// Construction de l'AppBar avec menu hamburger
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
//
//   /// Construction du menu latéral (hamburger)
//   Widget _buildDrawer(BuildContext context, User? currentUser, bool isAdmin) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           // En-tête du drawer avec infos utilisateur
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
//           // Options du menu pour le magasinier
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
//             title: Text('Mes mouvements'),
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
//               _navigateToScanner();
//             },
//           ),
//           // Options spécifiques à l'admin
//           if (isAdmin) ...[
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.people, color: Colors.green),
//               title: Text('Gestion utilisateurs'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _currentIndex = 3; // Index pour la gestion des utilisateurs
//                 });
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.assessment, color: Colors.green),
//               title: Text('Rapports'),
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   _currentIndex = 4; // Index pour les rapports
//                 });
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings, color: Colors.green),
//               title: Text('Paramètres système'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _navigateToSystemSettings();
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
//   /// Construction de la barre de navigation inférieure
//   Widget _buildBottomNavigationBar(bool isAdmin) {
//     // Définition des éléments de navigation en fonction du rôle
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
//     // Ajout des éléments admin si nécessaire
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
//     // Vérification que l'index courant est valide
//     if (_currentIndex >= navItems.length) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           _currentIndex = 0; // Réinitialiser à l'index 0 si invalide
//         });
//       });
//     }
//
//     return BottomNavigationBar(
//       currentIndex: _currentIndex < navItems.length ? _currentIndex : 0,
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
//   /// Construction du corps principal en fonction de l'onglet sélectionné
//   Widget _buildBodyContent(bool isAdmin) {
//     // Vérification que l'index est valide
//     final List<Widget> contentScreens = [
//       _buildDashboardContent(),
//       _buildMovementsContent(),
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
//     // Si l'index courant est invalide, on le réinitialise
//     if (_currentIndex >= contentScreens.length) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           _currentIndex = 0;
//         });
//       });
//       return contentScreens[0];
//     }
//
//     return contentScreens[_currentIndex];
//   }
//
//   /// Contenu du tableau de bord principal
//   Widget _buildDashboardContent() {
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
//             _buildHeaderSection(),
//             SizedBox(height: 24),
//             _buildQuickStatsSection(),
//             SizedBox(height: 24),
//             _buildDashboardGrid(),
//             SizedBox(height: 24),
//             _buildRecentMovementsSection(),
//             SizedBox(height: 24),
//             _buildStockAlertsSection(),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Contenu des mouvements (spécifique au magasinier)
//   Widget _buildMovementsContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.compare_arrows, size: 64, color: Colors.blue),
//           SizedBox(height: 16),
//           Text(
//             'Gestion des mouvements',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 8),
//           Text('Entrées et sorties de stock'),
//           SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () => _navigateToAddMovement(),
//             child: Text('Nouveau mouvement'),
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
//   /// Contenu du scanner
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
//   /// Contenu de gestion des utilisateurs (admin seulement)
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
//   /// Contenu des rapports (admin seulement)
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
//   /// Header avec avatar et informations utilisateur
//   Widget _buildHeaderSection() {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final currentUser = authProvider.user;
//     final isAdmin = currentUser?.role == 'admin';
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
//                 'Tableau de bord ${isAdmin ? 'Administrateur' : 'Magasinier'}',
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
//   /// Section des statistiques rapides
//   Widget _buildQuickStatsSection() {
//     final stockOverview = _dashboardData['stockOverview'] ?? {};
//     final movementSummary = _dashboardData['movementSummary'] ?? {};
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
//         children: [
//           StatItem(
//             icon: Icons.inventory_2_rounded,
//             value: stockOverview['total_products']?.toString() ?? '0',
//             label: 'Produits',
//             color: Colors.blue,
//           ),
//           StatItem(
//             icon: Icons.warning_amber_rounded,
//             value: stockOverview['low_stock_count']?.toString() ?? '0',
//             label: 'Alertes',
//             color: Colors.orange,
//           ),
//           StatItem(
//             icon: Icons.trending_up_rounded,
//             value: movementSummary['today_movements']?.toString() ?? '0',
//             label: 'Aujourd\'hui',
//             color: Colors.green,
//           ),
//           StatItem(
//             icon: Icons.pending_actions_rounded,
//             value: movementSummary['pending_count']?.toString() ?? '0',
//             label: 'En attente',
//             color: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Grille des cartes principales du dashboard
//   Widget _buildDashboardGrid() {
//     final stockOverview = _dashboardData['stockOverview'] ?? {};
//     final movementSummary = _dashboardData['movementSummary'] ?? {};
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
//       children: [
//         DashboardCard(
//           title: 'Produits Total',
//           value: stockOverview['total_products']?.toString() ?? '0',
//           icon: Icons.inventory_2_rounded,
//           color: Colors.blue,
//           onTap: () => _navigateToProductsScreen(),
//         ),
//         DashboardCard(
//           title: 'Alertes Stock',
//           value: stockOverview['low_stock_count']?.toString() ?? '0',
//           icon: Icons.warning_amber_rounded,
//           color: Colors.orange,
//           onTap: () => _navigateToLowStockProducts(),
//         ),
//         DashboardCard(
//           title: 'Mouvements Auj.',
//           value: movementSummary['today_movements']?.toString() ?? '0',
//           icon: Icons.compare_arrows_rounded,
//           color: Colors.green,
//           onTap: () => _navigateToMovementsScreen(),
//         ),
//         DashboardCard(
//           title: 'Validations',
//           value: movementSummary['pending_count']?.toString() ?? '0',
//           icon: Icons.pending_actions_rounded,
//           color: Colors.red,
//           onTap: () => _navigateToPendingApprovals(),
//         ),
//       ],
//     );
//   }
//
//   /// Section des mouvements récents
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
//   /// Section des alertes de stock
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
//         onPressed = _showQuickActionsMenu;
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
//         onPressed = _showQuickActionsMenu;
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
//   /// Méthodes de navigation
//   void _navigateToProductsScreen() {
//     Navigator.pushNamed(context, '/products');
//   }

//   void _navigateToMovementsScreen() {
//     Navigator.pushNamed(context, '/movements');
//   }
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
//   /// Menu des actions rapides
//   void _showQuickActionsMenu() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.add_rounded, color: Colors.blue),
//                 title: Text('Nouveau Produit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/add-product');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.compare_arrows_rounded, color: Colors.green),
//                 title: Text('Nouveau Mouvement'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/add-movement');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.bar_chart_rounded, color: Colors.orange),
//                 title: Text('Générer Rapport'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/reports');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }