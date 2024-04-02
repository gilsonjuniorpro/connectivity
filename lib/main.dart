import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();

    // Adjust the stream subscription to handle a list of ConnectivityResult
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Here, we're arbitrarily choosing to display the first result.
      // You might want to handle this differently.
      _updateConnectionStatus(results.first);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Initialize connectivity listener
  Future<void> _initConnectivity() async {
    List<ConnectivityResult> connectivityResults = await _connectivity.checkConnectivity();
    // Similar to the stream, handle the list as needed. Showing the first result as an example.
    _updateConnectionStatus(connectivityResults.first);
  }

  // Update connection status
  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result.toString();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initConnectivity();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Connectivity Example'),
        ),
        body: Center(
          child: Text('Connection Status: ${getStatusFromConnection(_connectionStatus)}'),
        ),
      ),
    );
  }

  getStatusFromConnection(String connectionStatus) {
    switch (connectionStatus) {
      case 'ConnectivityResult.none':
        return 'You are offline.';
      case 'ConnectivityResult.mobile':
        return 'You are on mobile data.';
      case 'ConnectivityResult.wifi':
        return 'You are on WiFi.';
      default:
        return 'Failed to get connectivity.';
    }
  }
}
