import 'package:flutter/material.dart';

/// Widget pour afficher une statistique individuelle avec icône
class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const StatItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.size = 40.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container pour l'icône avec fond arrondi
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1), // Fond semi-transparent
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.withOpacity(0.3), // Bordure subtile
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: size * 0.5, // Taille proportionnelle
              ),
            ),

            SizedBox(height: 8), // Espacement entre l'icône et le texte

            // Valeur numérique en gros
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Label descriptif
            Text(
              label.toUpperCase(), // En majuscules pour plus de visibilité
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Variante avec animation pour les changements de valeur
class AnimatedStatItem extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final Duration animationDuration;

  const AnimatedStatItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _AnimatedStatItemState createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _oldValue = '0';

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedStatItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _animation.value) * 10),
            child: StatItem(
              icon: widget.icon,
              value: widget.value,
              label: widget.label,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}