import 'dart:io';

/// Determine if a port is unused by trying to binding it.
Future<bool> isNetworkPortAvailable(int port) async {
  try {
    var socket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await socket.close();
    return true;
  } catch (e) {
    return false;
  }
}

/// Wait for a service on a port to be available.
Future<void> waitForServiceOnPort(int port) async {
  while (await isNetworkPortAvailable(port)) {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
