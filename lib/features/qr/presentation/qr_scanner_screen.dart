import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../favorites/providers/favorites_providers.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});
  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool handled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: QRView(
        key: qrKey,
        onQRViewCreated: (c) {
          controller = c;
          c.scannedDataStream.listen((scanData) async {
            if (handled) return;
            handled = true;
            try {
              final data = scanData.code ?? '';
              final id = data.contains('=') ? Uri.splitQueryString(data)['restaurantId'] ?? data : data;
              if (id.isEmpty) throw Exception('Invalid QR');
              await ref.read(favoritesProvider.notifier).addFavoriteById(id);
              if (context.mounted) context.go('/restaurant/$id');
            } catch (e) {
              log('QR error: $e');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid QR')));
                Navigator.of(context).pop();
              }
            }
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
