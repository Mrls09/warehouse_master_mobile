import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onQRScanned;

  const QRScannerScreen({
    Key? key,
    required this.onQRScanned,
  }) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código QR'),
      ),
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.takePicture,
        onCapture: (Result result) {
          if (_isScanning) {
            setState(() {
              _isScanning = false; // Detener el escaneo después de leer el QR
            });

            // Validación del contenido del QR
            if (result.text != null && result.text.isNotEmpty) {
              widget.onQRScanned(result
                  .text); // Pasar la información del QR a la función que manejas.
              _showScanResultDialog(result.text); // Mostrar el resultado.
            } else {
              _showScanResultDialog("No se pudo leer el código QR.");
            }
          }
        },
        formats: const [
          BarcodeFormat.qrCode,
          BarcodeFormat.aztec,
        ],
       child: _isScanning
    ? const Center(
        child: Text(
          'Escanea un código QR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isScanning = true;  // Permitir nuevo escaneo
              });
            },
            child: const Text('Escanear otro código QR'),
          ),
        ],
      ),

      ),
    );
  }

  void _showScanResultDialog(String? scanData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado del Escaneo'),
          content: Text(
            scanData != null && scanData.isNotEmpty
                ? 'Código leído: $scanData'
                : 'Error: No se pudo leer el código.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (scanData != null && scanData.isNotEmpty) {
                  widget.onQRScanned(scanData);
                }
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
