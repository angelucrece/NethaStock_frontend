import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  /// Widget pour afficher un état vide (aucune donnée)
  /// Utilisé quand les listes sont vides

  final String title; // Titre principal
  final String description; // Description détaillée
  final IconData icon; // Icône représentative
  final VoidCallback? onAction; // Callback pour l'action
  final String? actionText; // Texte du bouton d'action

  const EmptyState({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.onAction,
    this.actionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}