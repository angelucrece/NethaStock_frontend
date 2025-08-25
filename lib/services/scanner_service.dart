import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerService {
  static final MobileScannerController controller = MobileScannerController();

  static void startScanner() {
    controller.start();
  }

  static void stopScanner() {
    controller.stop();
  }

  static void toggleTorch() {
    controller.toggleTorch();
  }

  static void switchCamera() {
    controller.switchCamera();
  }

  static void dispose() {
    controller.dispose();
  }
}