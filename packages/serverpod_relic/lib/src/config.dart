import 'dart:io';

import 'package:yaml/yaml.dart';

/// The webserver configuration as read from config/{runMode}_web.yaml.
class WebserverConfig {
  /// Relative path of the configuration file.
  final String file;

  /// The current run mode (development, staging, or production).
  final String runMode;

  /// The server id of this server.
  final int serverId;

  /// The port the webserver is running on.
  int? port;

  /// The hostname of the webserver.
  String? hostname;

  /// Loads a webserver configuration.
  WebserverConfig({required this.runMode, required this.serverId})
      : file = 'config/${runMode}_web.yaml' {
    String data = File(file).readAsStringSync();
    YamlMap doc = loadYaml(data);

    Map<String, dynamic> clusterData = doc['cluster'];
    Map<String, dynamic> serverData = clusterData[serverId];

    port = serverData['port'];
    hostname = serverData['hostname'];
  }
}
