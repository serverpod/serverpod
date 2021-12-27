import 'dart:io';

import 'package:yaml/yaml.dart';

/// Parser for the server configuration file.
class ServerConfig {
  /// Path to the configuration file.
  final String file;

  /// The servers run mode.
  final String runMode;

  /// Id of the current server.
  final int serverId;

  /// Public facing host name.
  late final String publicHost;

  /// Public facing port number.
  late final int publicPort;

  /// Public facing scheme (typically http or https).
  late final String publicScheme;

  /// Port the server is running on.
  int? port;

  /// Service port of the server.
  int? servicePort;

  /// Max limit in bytes of requests to the server.
  late int maxRequestSize;

  /// Database host.
  String? dbHost;

  /// Database port.
  int? dbPort;

  /// Database user name.
  String? dbUser;

  /// Database password.
  String? dbPass;

  /// Database name.
  String? dbName;

  /// Authentication key for service protocol.
  String? serviceSecret;

  /// Configuration for other servers in the same cluster.
  Map<int, RemoteServerConfig> cluster = <int, RemoteServerConfig>{};

  /// Loads and parses a server configuration file. Picks config file depending
  /// on run mode.
  ServerConfig(this.runMode, this.serverId, Map<String, String>? passwords)
      : file = 'config/$runMode.yaml' {
    var data = File(file).readAsStringSync();
    var doc = loadYaml(data);

    publicHost = doc['public_host'];
    publicPort = doc['public_port'];
    publicScheme = doc['public_scheme'];

    // Get max request size (default to 512kb)
    maxRequestSize = doc['maxRequestSize'] ?? 524288;

    // Get Cluster
    Map clusterData = doc['cluster'];
    for (int id in clusterData.keys) {
      cluster[id] = RemoteServerConfig(id, clusterData[id]);
    }

    port = cluster[serverId]!.port;
    servicePort = cluster[serverId]!.servicePort;
    serviceSecret = doc['serviceSecret'] ?? '';
    if (passwords != null && passwords['serviceSecret'] != null) {
      serviceSecret = passwords['serviceSecret'];
    }

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

  /// Returns true if database is fully configured.
  bool get dbConfigured =>
      dbHost != null &&
      dbPort != null &&
      dbUser != null &&
      dbPass != null &&
      dbName != null;

  @override
  String toString() {
    var str = 'Config loaded from: $file';
    str += '\nport: $port';

    if (dbConfigured) {
      var displayPass = dbPass == null ? null : '********';

      str += '\ndatabase host: $dbHost';
      str += '\ndatabase port: $dbPort';
      str += '\ndatabase name: $dbName';
      str += '\ndatabase user: $dbUser';
      str += '\ndatabase pass: $displayPass';
    } else {
      str += '\nNo database configured';
    }

    return str;
  }
}

/// Represents a configuration of a server in the same cluster.
class RemoteServerConfig {
  /// Id of the server.
  final int serverId;

  /// Port the server is running on.
  int port;

  /// Service port of the server.
  int servicePort;

  /// Address through which the server can be accessed.
  String address;

  /// Creates a new [RemoteServerConfig].
  RemoteServerConfig(this.serverId, Map data)
      : port = data['port'] ?? 8080,
        servicePort = data['servicePort'] ?? 8081,
        address = data['address'] ?? 'localhost';
}
