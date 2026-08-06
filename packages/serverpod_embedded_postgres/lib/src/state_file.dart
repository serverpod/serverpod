import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

import 'transport.dart';

/// State persisted to `<.serverpod>/embedded_postgres_state.json` on each
/// successful start, sufficient for [EmbeddedPostgres.attach] to rebuild
/// the public-API surface without re-receiving the original
/// [EmbeddedPostgresOptions].
///
/// The TCP password is NOT persisted here - it lives in
/// `<.serverpod>/postgres.password` so the same file can be locked down
/// (chmod 0600) without restricting access to the structural state.
class EmbeddedPostgresState {
  /// Resolved version (the running cluster's PG_VERSION major).
  final Version version;

  /// Resolved username (matches the role created by initdb).
  final String username;

  /// Database created on first start.
  final String databaseName;

  /// Transport used for the running postmaster. For [TcpTransport] the
  /// [TcpTransport.port] field holds the resolved (non-zero) port.
  final Transport transport;

  /// Creates a state record.
  const EmbeddedPostgresState({
    required this.version,
    required this.username,
    required this.databaseName,
    required this.transport,
  });

  /// JSON form persisted to disk.
  Map<String, Object?> toJson() => {
    'version': version.toString(),
    'username': username,
    'databaseName': databaseName,
    'transport': switch (transport) {
      UnixTransport() => {'kind': 'unix'},
      TcpTransport(:final port) => {'kind': 'tcp', 'port': port},
    },
  };

  /// Inverse of [toJson]. The TCP password isn't part of the JSON; it's
  /// reattached separately by the caller from [pwFile].
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
  /// [tcpPassword] is forwarded into [TcpTransport.password] when the
  /// persisted transport is TCP.
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
