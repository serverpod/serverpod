import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  int? serverId;
  late ServerConfig config;
  ConfigInfo(String runMode, {this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};
    config = ServerConfig(runMode, serverId ?? 0, passwords);
  }

  Client createServiceClient() {
    print('serviceSecret: ${config.serviceSecret}');
    var keyManager = ServiceKeyManager('CLI', config);
    return Client(
      '${config.publicScheme}://${config.publicHost}:${config.servicePort}/',
      authenticationKeyManager: keyManager,
    );
  }

  void printAddress() {
    // TODO: Fix
    // if (serverId != null) {
    //   print(config.cluster[serverId]!.address);
    // } else {
    //   for (var id in config.cluster.keys) {
    //     print(config.cluster[id]!.address);
    //   }
    // }
  }

  void printIds() {
    // TODO: Fix
    // for (var id in config.cluster.keys) {
    //   print('$id');
    // }
  }
}
