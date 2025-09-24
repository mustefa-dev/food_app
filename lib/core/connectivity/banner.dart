import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityBanner extends StatefulWidget {
  final String offlineText;
  final String refreshingText;
  const ConnectivityBanner({super.key, required this.offlineText, required this.refreshingText});
  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}
class _ConnectivityBannerState extends State<ConnectivityBanner> {
  StreamSubscription? sub;
  bool offline = false;
  @override
  void initState() {
    super.initState();
    sub = Connectivity().onConnectivityChanged.listen((r){
      setState(()=> offline = !r.contains(ConnectivityResult.wifi) && !r.contains(ConnectivityResult.mobile));
    });
  }
  @override
  void dispose() { sub?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    if (!offline) return const SizedBox.shrink();
    return Container(color: Colors.amber, padding: const EdgeInsets.all(8), child: Row(children: [
      const Icon(Icons.wifi_off), const SizedBox(width:8), Expanded(child: Text(widget.offlineText))
    ]));
  }
}
