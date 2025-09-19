import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CategoryChip({
    Key? key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category.name,
              style: TextStyle(
                color: selected ? Colors.white : color,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.close, size: 16),
                padding: EdgeInsets.zero, // réduit la zone de padding par défaut
                constraints: const BoxConstraints(), // supprime la taille minimale
                color: selected ? Colors.white : color,
                tooltip: "Supprimer la catégorie",
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Essaie de convertir la couleur hexadécimale en [Color].
  /// Exemple attendu: "#FF5733" ou "FF5733"
  Color _getCategoryColor() {
    if (category.color != null && category.color!.isNotEmpty) {
      try {
        final hex = category.color!.replaceFirst('#', '');
        return Color(int.parse('0xFF$hex'));
      } catch (_) {
        return Colors.grey; // fallback si la conversion échoue
      }
    }
    return Colors.grey; // fallback si aucune couleur définie
  }
}
