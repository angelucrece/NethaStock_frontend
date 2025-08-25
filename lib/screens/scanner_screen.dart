import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/scanner_service.dart';

class ScannerScreen extends StatefulWidget {
  /// Écran de scan de codes QR et codes-barres
  /// Utilise la caméra pour scanner les codes produits

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isTorchOn = false; // État de la torche
  bool _isCameraFront = false; // Type de caméra utilisée

  @override
  void initState() {
    super.initState();
    // Démarre le scanner quand l'écran est initialisé
    ScannerService.startScanner();
  }

  @override
  void dispose() {
    // Arrête le scanner et libère les ressources quand l'écran est fermé
    ScannerService.stopScanner();
    ScannerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner Produit'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          // Bouton pour activer/désactiver la torche
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleTorch,
            tooltip: 'Torche',
          ),
          // Bouton pour changer de caméra
          IconButton(
            icon: Icon(_isCameraFront ? Icons.camera_front : Icons.camera_rear),
            onPressed: _switchCamera,
            tooltip: 'Changer de caméra',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Vue du scanner camera
          MobileScanner(
            controller: ScannerService.controller,
            onDetect: (capture) {
              // Callback quand un code est détecté
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                _handleScannedCode(barcode.rawValue ?? '');
              }
            },
          ),

          // Overlay avec guide de scan
          _buildScannerOverlay(),
        ],
      ),
    );
  }

  /// Construit l'overlay du scanner avec le guide de cadrage
  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomPaint(
          painter: _ScannerOverlayPainter(),
        ),
      ),
    );
  }

  /// Active/désactive la torche
  void _toggleTorch() {
    ScannerService.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  /// Change entre caméra avant et arrière
  void _switchCamera() {
    ScannerService.switchCamera();
    setState(() {
      _isCameraFront = !_isCameraFront;
    });
  }

  /// Traite le code scanné
  void _handleScannedCode(String code) {
    // TODO: Implémenter le traitement du code scanné
    // Recherche du produit, navigation vers la fiche, etc.
    print('Code scanné: $code');

    // Affiche une snackbar de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit scanné: $code'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Painter personnalisé pour l'overlay du scanner
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Dessine le cadre de scan
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    // Dessine les coins arrondis
    const cornerLength = 20.0;

    // Coin supérieur gauche
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Coin supérieur droit
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Coin inférieur gauche
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Coin inférieur droit
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}