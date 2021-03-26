import 'dart:io';
import 'package:yaml/yaml.dart';

class ServerConfig {
  final String file;
  final String runMode;
  final int serverId;

  int? port;
  int? servicePort;
  int? maxRequestSize;

  String? dbHost;
  int? dbPort;
  String? dbUser;
  String? dbPass;
  String? dbName;

  String? serviceSecret;

  Map<int, RemoteServerConfig> cluster = <int, RemoteServerConfig>{};

  ServerConfig(this.runMode, this.serverId) : file = 'config/$runMode.yaml' {
    String data = File(file).readAsStringSync();
    var doc = loadYaml(data);

    // Get max request size (default to 100kb)
    maxRequestSize = doc['maxRequestSize'] ?? 102400;

    // Get Cluster
    Map clusterData = doc['cluster'];
    for (int id in clusterData.keys) {
      cluster[id] = RemoteServerConfig(id, clusterData[id]);
    }

    port = cluster[serverId]!.port;
    servicePort = cluster[serverId]!.servicePort;
    serviceSecret = doc['serviceSecret'] ?? '';

    // Get database setup
    if (doc['database'] != null) {
      var dbSetup = doc['database'];
      dbHost = dbSetup['host'];
      dbPort = dbSetup['port'];
      dbName = dbSetup['name'];
      dbUser = dbSetup['user'];
      dbPass = dbSetup['pass'];
    }
  }

  bool get dbConfigured => dbHost != null && dbPort != null && dbUser != null && dbPass != null && dbName != null;

  @override
  String toString() {
    String str = 'Config loaded from: $file';
    str += '\nport: $port';

    if (dbConfigured) {
      String? displayPass = dbPass == null ? null : '********';

      str += '\ndatabase host: $dbHost';
      str += '\ndatabase port: $dbPort';
      str += '\ndatabase name: $dbName';
      str += '\ndatabase user: $dbUser';
      str += '\ndatabase pass: $displayPass';
    }
    else {
      str += '\nNo database configured';
    }

    return str;
  }
}

class RemoteServerConfig {
  final int serverId;
  int port;
  int servicePort;
  String address;

  RemoteServerConfig(this.serverId, Map data) :
        port = data['port'] ?? 8080,
        servicePort = data['servicePort'] ?? 8081,
        address = data['address'] ?? 'localhost'
  ;
}