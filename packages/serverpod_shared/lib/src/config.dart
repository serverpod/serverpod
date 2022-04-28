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
  late final int port;

  /// Service port of the server.
  late final int servicePort;

  /// Max limit in bytes of requests to the server.
  late int maxRequestSize;

  /// Database host.
  late final String dbHost;

  /// Database port.
  late final int dbPort;

  /// Database user name.
  late final String dbUser;

  /// Database password.
  late final String dbPass;

  /// Database name.
  late final String dbName;

  /// Redis host.
  late final String redisHost;

  /// Redis port.
  late final int redisPort;

  /// Redis user name (optional).
  late final String? redisUser;

  /// Redis password (optional, but recommended).
  late final String? redisPassword;

  /// Authentication key for service protocol.
  late final String serviceSecret;

  /// Loads and parses a server configuration file. Picks config file depending
  /// on run mode.
  ServerConfig(this.runMode, this.serverId, Map<String, String> passwords)
      : file = 'config/$runMode.yaml' {
    String data = File(file).readAsStringSync();
    YamlMap doc = loadYaml(data);

    publicHost = doc['publicHost']!;
    publicPort = doc['publicPort']!;
    publicScheme = doc['publicScheme']!;

    // Get max request size (default to 512kb)
    maxRequestSize = doc['maxRequestSize'] ?? 524288;

    port = doc['port']!;
    servicePort = doc['servicePort']!;
    serviceSecret = passwords['serviceSecret'] ?? '';

    // Get database setup
    assert(doc['database'] is Map, 'Database setup is missing in config');
    Map<String, dynamic> dbSetup = doc['database'];
    dbHost = dbSetup['host']!;
    dbPort = dbSetup['port']!;
    dbName = dbSetup['name']!;
    dbUser = dbSetup['user']!;
    dbPass = passwords['database'] ?? 'Missing database password';

    // Get Redis setup
    assert(doc['redis'] is Map, 'Redis setup is missing in config');
    Map<String, dynamic> redisSetup = doc['redis'];
    redisHost = redisSetup['host']!;
    redisPort = redisSetup['port']!;
    redisUser = redisSetup['user'];
    redisPassword = passwords['redis'];
  }

  @override
  String toString() {
    String str = 'Config loaded from: $file';
    str += '\napi port: $port';
    str += '\nservice port: $servicePort';

    str += '\npostgres host: $dbHost';
    str += '\npostgres port: $dbPort';
    str += '\npostgres name: $dbName';
    str += '\npostgres user: $dbUser';
    str += '\npostgres pass: ********';

    str += '\nredis host: $redisHost';
    str += '\nredis port: $redisPort';
    if (redisUser != null) {
      str += '\nredis user: $redisUser';
    }
    str += '\nredis pass: ********';

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
  RemoteServerConfig(this.serverId, Map<String, dynamic> data)
      : port = data['port'] ?? 8080,
        servicePort = data['servicePort'] ?? 8081,
        address = data['address'] ?? 'localhost';
}
