import 'dart:io';

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  String? serverId;
  late ServerpodConfig config;
  ConfigInfo(String runMode, {this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords();
    config = ServerpodConfig.load(
      runMode,
      serverId,
      passwords,
    );
  }

  /// Like the default constructor, but reads `config/<runMode>.yaml` and
  /// `config/passwords.yaml` relative to [serverDir] rather than the
  /// caller's working directory. Briefly chdirs into [serverDir] while
  /// loading and restores the previous cwd afterwards.
  ///
  /// TODO: replace this with a base-directory parameter on
  /// [ServerpodConfig.load] / [PasswordManager]. Mutating
  /// [Directory.current] is racy with anything else in the isolate that
  /// reads cwd while this call is in flight.
  factory ConfigInfo.fromDir({
    required String serverDir,
    required String runMode,
    String? serverId,
  }) {
    final originalCwd = Directory.current;
    Directory.current = Directory(serverDir);
    try {
      return ConfigInfo(runMode, serverId: serverId);
    } finally {
      Directory.current = originalCwd;
    }
  }

  Client createServiceClient() {
    var keyManager = ServiceAuthKeyProvider('CLI', config);

    var insightsServer = config.insightsServer;
    if (insightsServer == null) {
      throw StateError('Insights server not configured.');
    }

    return Client(
      '${insightsServer.publicScheme}://'
      '${insightsServer.publicHost}:${insightsServer.port}/',
    )..authKeyProvider = keyManager;
  }
}
