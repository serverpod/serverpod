import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';

class FlutterConnectivityMonitor extends ConnectivityMonitor {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _receivedFirstEvent = false;

  FlutterConnectivityMonitor() {
    WidgetsFlutterBinding.ensureInitialized();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      if (!_receivedFirstEvent) {
        _receivedFirstEvent = true;
        if (event == ConnectivityResult.none) {
          return;
        }
      }
      notifyListeners(event != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
