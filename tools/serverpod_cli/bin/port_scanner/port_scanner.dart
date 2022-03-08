import 'dart:io';

class PortScanner {
  static Future<bool> isPortOpen(String host, int port) async {
    try {
      var connection = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );
      await connection.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> waitForPort(
    String host,
    int port, {
    Duration timeout = const Duration(minutes: 1),
    bool printProgress = false,
  }) async {
    var endTime = DateTime.now().add(timeout);
    while (DateTime.now().compareTo(endTime) < 0) {
      if (await isPortOpen(host, port)) {
        return true;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    return false;
  }
}
