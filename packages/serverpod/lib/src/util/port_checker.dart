import 'dart:io';

/// A class that can be used to check if a port is available.
abstract class PortChecker {
  /// Determine if a port is unused by trying to binding it.
  static Future<bool> isNetworkPortAvailable(int port) async {
    try {
      var socket = await ServerSocket.bind(InternetAddress.anyIPv6, port);
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}
