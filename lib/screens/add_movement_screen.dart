import 'package:flutter/material.dart';

class AddMovementScreen extends StatelessWidget {
  final String type;

  const AddMovementScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter ${type == 'entry' ? 'Entrée' : 'Sortie'}')),
      body: const Center(child: Text('Écran d\'ajout de mouvement')),
    );
  }
}