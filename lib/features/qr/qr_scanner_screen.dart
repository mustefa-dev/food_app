import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../favorites/favorites_provider.dart';
import '../restaurant/restaurant_screen.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});
  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> with WidgetsBindingObserver {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool handled = false;
  bool controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller != null && controllerInitialized) {
      if (state == AppLifecycleState.paused) {
        controller?.pauseCamera();
      } else if (state == AppLifecycleState.resumed) {
        controller?.resumeCamera();
      }
    }
  }

  void _onQRViewCreated(QRViewController c) {
    if (controllerInitialized) return;
    controller = c;
    controllerInitialized = true;
    c.scannedDataStream.listen((scan) async {
      if (handled) return;
      handled = true;
      await controller?.pauseCamera();
      try {
        final data = scan.code ?? '';
        final id = data.contains('=') ? Uri.splitQueryString(data)['restaurantId'] ?? data : data;
        if (id.isEmpty) throw Exception('Invalid QR');
        final error = await ref.read(favoritesProvider.notifier).addById(id, context: context);
        if (mounted) {
          if (error == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to favorites')));
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RestaurantScreen(restaurantId: id)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        log('QR error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR')));
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
