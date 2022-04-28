import 'dart:io';

/// Determine if a port is unused by trying to binding it.
Future<bool> isNetworkPortAvailable(int port) async {
  try {
    ServerSocket socket =
        await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await socket.close();
    return true;
  } catch (e) {
    return false;
  }
}
