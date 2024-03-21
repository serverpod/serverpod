import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  String? serverId;
  late ServerpodConfig config;
  ConfigInfo(String runMode, {this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};
    config = ServerpodConfig.load(runMode, serverId ?? 'undefined', passwords);
  }

  Client createServiceClient() {
    var keyManager = ServiceKeyManager('CLI', config);

    var insightsServer = config.insightsServer;
    if (insightsServer == null) {
      throw StateError('Insights server not configured.');
    }

    return Client(
      '${insightsServer.publicScheme}://'
      '${insightsServer.publicHost}:${insightsServer.port}/',
      authenticationKeyManager: keyManager,
    );
  }
}
