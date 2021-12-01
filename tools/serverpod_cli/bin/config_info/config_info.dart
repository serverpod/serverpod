import 'package:serverpod_shared/serverpod_shared.dart';

class ConfigInfo {
  int? serverId;
  late ServerConfig config;
  ConfigInfo(String runMode, {this.serverId}) {
    var passwords = PasswordManager(runMode: runMode).loadPasswords() ?? {};
    config = ServerConfig(runMode, serverId ?? 0, passwords);
  }

  void printAddress() {
    if (serverId != null) {
      print(config.cluster[serverId]!.address);
    }
    else {
      for (var id in config.cluster.keys)
        print(config.cluster[id]!.address);
    }
  }

  void printIds() {
    for (var id in config.cluster.keys)
      print('$id');
  }
}