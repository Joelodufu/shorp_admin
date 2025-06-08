import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionStatusBanner extends StatefulWidget {
  const ConnectionStatusBanner({super.key});

  @override
  State<ConnectionStatusBanner> createState() => _ConnectionStatusBannerState();
}

class _ConnectionStatusBannerState extends State<ConnectionStatusBanner> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isOffline = false;
  bool _showRecovered = false;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final hasConnection = result != ConnectivityResult.none;
      if (!hasConnection) {
        setState(() {
          _isOffline = true;
          _showRecovered = false;
        });
      } else if (_isOffline) {
        setState(() {
          _showRecovered = true;
          _isOffline = false;
        });
        // Hide the green banner after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showRecovered = false;
            });
          }
        });
      }
    });
    // Initial check
    Connectivity().checkConnectivity().then((result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          _isOffline = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return Container(
        width: double.infinity,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: const SafeArea(
          bottom: false,
          child: Center(
            child: Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    if (_showRecovered) {
      return Container(
        width: double.infinity,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: const SafeArea(
          bottom: false,
          child: Center(
            child: Text(
              'Connection Restored',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}