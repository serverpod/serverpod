import 'package:serverpod/serverpod.dart';

class ConfigInfo {
  int serverId;
  ServerConfig config;
  ConfigInfo(String configFile, this.serverId) {
    config = ServerConfig(configFile, serverId ?? 0);
  }

  printAddress() {
    if (serverId != null) {
      print(config.cluster[serverId].address);
    }
    else {
      for (var id in config.cluster.keys)
        print(config.cluster[id].address);
    }
  }
}