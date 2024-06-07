import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';

/// Concrete implementation of [ConnectivityMonitor] for use with Flutter.
class FlutterConnectivityMonitor extends ConnectivityMonitor {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _receivedFirstEvent = false;

  /// Creates a new connectivity monitor.
  FlutterConnectivityMonitor() {
    WidgetsFlutterBinding.ensureInitialized();
    const warmupDuration = Duration(seconds: 1);
    var connectionTime = DateTime.now();

    // Start listening to connection status changes.
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) {
      final bool hasConnectivity =
          !(event.length == 1 && event.first == ConnectivityResult.none);

      if (!_receivedFirstEvent) {
        // Skip the first event if it happens immediately on launch as it may
        // not be correct on some platforms.
        _receivedFirstEvent = true;
        var durationSinceStart = DateTime.now().difference(connectionTime);
        if (!hasConnectivity && durationSinceStart < warmupDuration) {
          return;
        }
      }
      notifyListeners(hasConnectivity);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }
}
