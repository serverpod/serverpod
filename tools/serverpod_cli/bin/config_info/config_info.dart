import 'package:serverpod_shared/config.dart';

class ConfigInfo {
  int? serverId;
  late ServerConfig config;
  ConfigInfo(String configFile, {this.serverId}) {
    config = ServerConfig(configFile, serverId ?? 0);
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