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

/// The import url of the serverpod test package.
const String serverpodTestUrl = 'package:serverpod_test/serverpod_test.dart';
const String serverpodTestPublicExportsUrl =
    'package:serverpod_test/serverpod_test_public_exports.dart';
