import 'package:flutter/material.dart';

/// Widget pour afficher les erreurs et permettre de réessayer
class ErrorRetryWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String retryButtonText;
  final String title;

  const ErrorRetryWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
    this.retryButtonText = 'Réessayer',
    this.title = 'Oups ! Une erreur est survenue',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône d'erreur
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade400,
            ),

            SizedBox(height: 16),

            // Titre
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            // Message d'erreur
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24),

            // Bouton de réessai
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh_rounded, size: 20),
              label: Text(retryButtonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Option de contact support
            TextButton(
              onPressed: () => _showSupportOptions(context),
              child: Text(
                'Contacter le support',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options de support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.email_rounded, color: Colors.blue),
                title: Text('Envoyer un email'),
                onTap: () => _sendSupportEmail(),
              ),
              ListTile(
                leading: Icon(Icons.phone_rounded, color: Colors.green),
                title: Text('Appeler le support'),
                onTap: () => _callSupport(),
              ),
              ListTile(
                leading: Icon(Icons.chat_rounded, color: Colors.orange),
                title: Text('Chat en direct'),
                onTap: () => _startChatSupport(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendSupportEmail() {
    // Implémentation pour envoyer un email
  }

  void _callSupport() {
    // Implémentation pour appeler le support
  }

  void _startChatSupport() {
    // Implémentation pour le chat support
  }
}

/// Variante pour les erreurs de connexion
class NoConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoConnectionWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorRetryWidget(
      errorMessage: 'Vérifiez votre connexion internet et réessayez.',
      onRetry: onRetry,
      title: 'Connexion perdue',
      retryButtonText: 'Réessayer la connexion',
    );
  }
}

/// Variante pour les erreurs de serveur
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ServerErrorWidget({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorRetryWidget(
      errorMessage: 'Le serveur rencontre des difficultés. Veuillez réessayer dans quelques instants.',
      onRetry: onRetry,
      title: 'Problème de serveur',
      retryButtonText: 'Réessayer',
    );
  }
}