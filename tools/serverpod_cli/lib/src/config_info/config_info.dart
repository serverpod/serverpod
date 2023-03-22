import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  String? serverId;
  late ServerpodConfig config;
  ConfigInfo(String runMode, {this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};
    config = ServerpodConfig(runMode, serverId ?? 'undefined', passwords);
  }

  Client createServiceClient() {
    print('serviceSecret: ${config.serviceSecret}');
    var keyManager = ServiceKeyManager('CLI', config);
    return Client(
      '${config.insightsServer.publicScheme}://${config.insightsServer.publicHost}:${config.insightsServer.port}/',
      authenticationKeyManager: keyManager,
    );
  }
}
