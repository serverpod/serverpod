import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  String? serverId;
  late ServerpodConfig config;

  ConfigInfo(String runMode, {required String serverDir, this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords(
      serverDir: serverDir,
    );
    config = ServerpodConfig.load(
      runMode,
      serverId,
      passwords,
      serverDir: serverDir,
    );
  }

  /// The insights server address the config file names.
  ///
  /// A running pod can listen elsewhere, so prefer the address it reported.
  String get configuredInsightsAddress {
    var insightsServer = config.insightsServer;
    if (insightsServer == null) {
      throw StateError('Insights server not configured.');
    }

    return '${insightsServer.publicScheme}://'
        '${insightsServer.publicHost}:${insightsServer.port}/';
  }

  /// Service client for the insights server at [address].
  Client createServiceClientFor(String address) =>
      Client(address)..authKeyProvider = ServiceAuthKeyProvider('CLI', config);
}
