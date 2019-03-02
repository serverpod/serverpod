import 'dart:io';
import 'package:yaml/yaml.dart';

class ServerConfig {
  String file;
  int port;

  String dbHost;
  int dbPort;
  String dbUser;
  String dbPass;
  String dbName;

  ServerConfig(String _file) {
    file = _file;
    String data = File(file).readAsStringSync();
    var doc = loadYaml(data);

    // Get port
    port = doc['port'] ?? 1234;

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
      String displayPass = dbPass == null ? null : '********';

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