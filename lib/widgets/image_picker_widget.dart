import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  /// Widget pour sélectionner une image depuis la galerie ou l'appareil photo
  /// Affiche un aperçu et des boutons d'action

  final ValueChanged<XFile?> onImageSelected; // Callback quand une image est sélectionnée
  final String? initialImageUrl; // URL de l'image existante (pour l'édition)
  final String label; // Label descriptif

  const ImagePickerWidget({
    Key? key,
    required this.onImageSelected,
    this.initialImageUrl,
    required this.label,
  }) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? _selectedImage; // Image sélectionnée
  String? _imageUrl; // URL de l'image existante

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.initialImageUrl; // Initialise avec l'URL existante
  }

  /// Ouvre le sélecteur d'image (galerie ou caméra)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _imageUrl = null; // Efface l'URL existante si nouvelle image
        });
        widget.onImageSelected(image); // Notifie le parent
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  /// Supprime l'image sélectionnée
  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
    });
    widget.onImageSelected(null); // Notifie le parent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Aperçu de l'image
        if (_selectedImage != null || _imageUrl != null)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: _selectedImage != null
                ? Image.file(
              File(_selectedImage!.path),
              fit: BoxFit.cover,
            )
                : Image.network(
              _imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error),
            ),
          ),

        const SizedBox(height: 12),

        // Boutons d'action
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Galerie'),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Caméra'),
            ),
            if (_selectedImage != null || _imageUrl != null) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Supprimer l\'image',
              ),
            ],
          ],
        ),
      ],
    );
  }
}