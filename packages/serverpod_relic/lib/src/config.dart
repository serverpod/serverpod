import 'dart:io';
import 'package:yaml/yaml.dart';

class WebserverConfig {
  final String file;
  final String runMode;
  final int serverId;

  int? port;
  String? hostname;

  WebserverConfig({required this.runMode, required this.serverId}) : file = 'config/${runMode}_web.yaml' {
    var data = File(file).readAsStringSync();
    var doc = loadYaml(data);

    Map clusterData = doc['cluster'];
    Map serverData = clusterData[serverId];

    port = serverData['port'];
    hostname = serverData['hostname'];
  }
}