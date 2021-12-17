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
    var data = File(file).readAsStringSync();
    var doc = loadYaml(data);

    Map clusterData = doc['cluster'];
    Map serverData = clusterData[serverId];

    port = serverData['port'];
    hostname = serverData['hostname'];
  }
}
