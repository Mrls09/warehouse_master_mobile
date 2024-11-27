import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (DefaultAssetBundle.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      } else if (DefaultAssetBundle.of(context).platform == TargetPlatform.iOS) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código QR', style: TextStyle(color: AppColors.lightGray),),
        backgroundColor: AppColors.rosePrimary,
      ),
      body: Column(
        children: [
          // Cámara para escanear el QR
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: AppColors.softPinkBackground,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          // Botones para reintentar o salir
          Expanded(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      controller?.resumeCamera();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Reintentar'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Pausar la cámara al detectar un QR
      Navigator.pop(context, scanData.code); // Retornar el código escaneado
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

extension on AssetBundle {
  get platform => null;
}