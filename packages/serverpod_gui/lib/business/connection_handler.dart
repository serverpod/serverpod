import 'dart:io';
import 'package:yaml/yaml.dart';

import 'package:serverpod/src/server/config.dart';
import 'package:serverpod/src/authentication/certificates.dart';
import 'package:serverpod_service_client/protocol/protocol.dart';
import 'key_manager.dart';

class ConnectionHandler {
  Map<int, Client> _clients = <int, Client>{};
  ServiceKeyManager? _keyManager;
  int _defaultServerId;

  List<String> endpoints = [];
  Map<String, List<String>> methods = {};

  Client? get client => _clients[_defaultServerId];
  List<Client> get clients => _clients.values.toList();

  ConnectionHandler(String configFile, {int defaultServerId=0}) :
  _defaultServerId = defaultServerId {
    Directory.current = Directory('/Users/viktor/Projects/aspectorama');

    var config = ServerConfig(configFile, defaultServerId);
    _keyManager = ServiceKeyManager('GUI', config.serviceSecret);
    _defaultServerId = defaultServerId;

    for (int k in config.cluster.keys) {
      var context = SecurityContext();
      context.setTrustedCertificates(sslCertificatePath(configFile, k));
      _clients[k] = Client('https://${config.cluster[k]?.address}:${config.cluster[k]?.servicePort}/', authenticationKeyManager: _keyManager, context: context);
    }

    // Load protocol info
    try {
      var protocolFile = File('generated/protocol_info.yaml');
      String protocolYaml = protocolFile.readAsStringSync();
      Map doc = loadYaml(protocolYaml);
      for (String endpoint in doc.keys) {
        endpoints.add(endpoint);
        Map methodMap = doc[endpoint];
        methods[endpoint] = methodMap.keys.toList().cast<String>();
      }
    }
    catch (e) {}
  }
}