import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

import 'transport.dart';
import 'transport_listeners.dart';

/// State persisted to `<.serverpod>/embedded_postgres_state.json` on each
/// successful start, sufficient for [EmbeddedPostgres.attach] to rebuild
/// the public-API surface without re-receiving the original
/// [EmbeddedPostgresOptions].
///
/// The TCP password is not stored. An attaching process supplies its own.
class EmbeddedPostgresState {
  /// Resolved version (the running cluster's PG_VERSION major).
  final Version version;

  /// Resolved username (matches the role created by initdb).
  final String username;

  /// Database created on first start.
  final String databaseName;

  /// Transport the postmaster launched with.
  final Transport transport;

  /// Creates a state record.
  const EmbeddedPostgresState({
    required this.version,
    required this.username,
    required this.databaseName,
    required this.transport,
  });

  /// JSON form persisted to disk.
  Map<String, Object?> toJson() {
    assert(
      transport.tcpPort != 0,
      'only a transport with its ephemeral port resolved is persisted',
    );
    return {
      'version': version.toString(),
      'username': username,
      'databaseName': databaseName,
      'transport': {
        'kind': switch (transport) {
          UnixTransport() => 'unix',
          TcpTransport() => 'tcp',
          DualTransport() => 'dual',
        },
        'port': ?transport.tcpPort,
      },
    };
  }

  /// Inverse of [toJson], with the TCP password given as [tcpPassword].
  factory EmbeddedPostgresState.fromJson(
    Map<String, Object?> json, {
    String? tcpPassword,
  }) {
    var version = Version.parse(json['version']! as String);
    var username = json['username']! as String;
    var databaseName = json['databaseName']! as String;
    var transportJson = json['transport']! as Map<String, Object?>;
    var transport = switch (transportJson['kind']) {
      'unix' => const UnixTransport(),
      'tcp' => TcpTransport(
        port: transportJson['port']! as int,
        password: tcpPassword,
      ),
      'dual' => DualTransport(
        port: transportJson['port']! as int,
        password: tcpPassword,
      ),
      _ => throw FormatException(
        'unknown transport kind: ${transportJson['kind']}',
      ),
    };
    return EmbeddedPostgresState(
      version: version,
      username: username,
      databaseName: databaseName,
      transport: transport,
    );
  }

  /// Atomically writes [state] to [stateFile] (write `.tmp`, rename).
  static void writeAtomic(File stateFile, EmbeddedPostgresState state) {
    var tmp = File('${stateFile.path}.tmp');
    tmp.parent.createSync(recursive: true);
    tmp.writeAsStringSync(jsonEncode(state.toJson()));
    tmp.renameSync(stateFile.path);
  }

  /// Reads the state at [stateFile], or null if missing / malformed.
  /// [tcpPassword] is forwarded into the transport's password when the
  /// persisted transport listens on TCP.
  static EmbeddedPostgresState? read(
    File stateFile, {
    String? tcpPassword,
  }) {
    if (!stateFile.existsSync()) return null;
    try {
      var raw = jsonDecode(stateFile.readAsStringSync());
      if (raw is! Map) return null;
      return EmbeddedPostgresState.fromJson(
        raw.cast<String, Object?>(),
        tcpPassword: tcpPassword,
      );
    } on FormatException {
      return null;
    }
  }
}
