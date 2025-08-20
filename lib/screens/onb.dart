import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockMaster Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0D47A1),
          secondary: Color(0xFF1565C0),
          surface: Color(0xFFF5F9FF),
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D47A1),
            height: 1.2,
          ),
          bodyLarge: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFF37474F),
            height: 1.6,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      title: 'Gestion de Stock\nProfessionnelle',
      description: 'Optimisez votre inventaire avec des outils avancés de suivi et de gestion des produits.',
      imageAsset: 'assets/images/inventory_management.svg', // SVG d'illustration
      color: Color(0xFF0D47A1),
    ),
    OnboardingPage(
      title: 'Scanner Intégré\nCode-Barres',
      description: 'Numérisez vos produits instantanément et ajoutez-les à votre inventaire en quelques secondes.',
      imageAsset: 'assets/images/barcode_scanner.svg', // SVG d'illustration
      color: Color(0xFF1565C0),
    ),
    OnboardingPage(
      title: 'Alertes Intelligentes\nen Temps Réel',
      description: 'Recevez des notifications proactives pour éviter les ruptures de stock et optimiser vos commandes.',
      imageAsset: 'assets/images/notifications.svg', // SVG d'illustration
      color: Color(0xFF1976D2),
    ),
    OnboardingPage(
      title: 'Analyses Détaillées\net Rapports',
      description: 'Générez des rapports détaillés et visualisez vos données avec des graphiques professionnels.',
      imageAsset: 'assets/images/data_analytics.svg', // SVG d'illustration
      color: Color(0xFF1E88E5),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFBBDEFB),
              Color(0xFFF5F9FF),
            ],
            stops: [0.0, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Contenu des pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingPages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildOnboardingPage(_onboardingPages[index]),
                    );
                  },
                ),
              ),

              // Boutons de navigation
              _buildNavigationButtons(),

              // Indicateurs de progression
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_onboardingPages.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == index ? 28 : 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _currentPage == index
                  ? _onboardingPages[index].color
                  : _onboardingPages[index].color.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration avec image SVG
          Container(
            width: 280, // Légèrement plus grand pour les images détaillées
            height: 280,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Effet d'ondulation subtil
                ...List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 1800 + index * 500),
                    curve: Curves.easeOut,
                    width: 240 + index * 40,
                    height: 240 + index * 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: page.color.withOpacity(0.15 - index * 0.05),
                        width: 1.2,
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
                // Conteneur principal pour l'image
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: page.color.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    // Utilisation d'une image SVG - en attendant, on utilise un placeholder
                    child: _buildImagePlaceholder(page),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Titre
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D47A1),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF546E7A),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(OnboardingPage page) {
    // Placeholder en attendant les vraies images SVG
    // En production, remplacez par: SvgPicture.asset(page.imageAsset, width: 120, height: 120);

    return Icon(
      _getIconForPage(page),
      size: 80,
      color: page.color,
    );
  }

  IconData _getIconForPage(OnboardingPage page) {
    // Mapping des icônes de remplacement en attendant les images
    if (page.imageAsset.contains('inventory')) return Icons.inventory_2_rounded;
    if (page.imageAsset.contains('barcode')) return Icons.qr_code_scanner_rounded;
    if (page.imageAsset.contains('notifications')) return Icons.notifications_active_rounded;
    if (page.imageAsset.contains('analytics')) return Icons.analytics_rounded;
    return Icons.help_rounded;
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40),
      child: Row(
        children: [
          // Bouton Passer (sur les premières pages)
          if (_currentPage < _onboardingPages.length - 1)
            TextButton(
              onPressed: () {
                _pageController.jumpToPage(_onboardingPages.length - 1);
              },
              child: const Text(
                'Passer',
                style: TextStyle(
                  color: Color(0xFF546E7A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const Spacer(),

          // Indicateur de page
          Text(
            '${_currentPage + 1}/${_onboardingPages.length}',
            style: const TextStyle(
              color: Color(0xFF90A4AE),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          // Bouton Suivant/Commencer
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _onboardingPages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Action à effectuer à la fin de l'onboarding
                  print('Onboarding terminé!');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _onboardingPages[_currentPage].color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: _onboardingPages[_currentPage].color.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage < _onboardingPages.length - 1 ? 'Suivant' : 'Commencer',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _currentPage < _onboardingPages.length - 1
                        ? Icons.arrow_forward_rounded
                        : Icons.check_rounded,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imageAsset; // Chemin vers l'image SVG
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.color,
  });
}