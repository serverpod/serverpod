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

/// The import url of the serverpod protocol.
String protocolUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/protocol.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}

/// The import url of the ByteData type.
String get byteDataUrl => 'dart:typed_data';

/// The import url of the UuidValue type.
String get uuidValueUrl => 'package:uuid/uuid_value.dart';
