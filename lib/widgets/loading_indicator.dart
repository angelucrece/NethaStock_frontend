import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  /// Widget d'indicateur de chargement personnalisé
  /// Peut être utilisé partout dans l'app pour montrer un chargement

  final String? message; // Message optionnel à afficher
  final double size; // Taille de l'indicateur

  const LoadingIndicator({
    Key? key,
    this.message,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            strokeWidth: 3.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}