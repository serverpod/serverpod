/// The import url of the main serverpod package.
String serverpodUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/serverpod.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}

/// The import url of the serverpod protocol.
String serverpodProtocolUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/protocol.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}
