import 'dart:io';
import 'package:yaml/yaml.dart';
import '../database/database_connection.dart';
import '../generated/protocol.dart' as internal;

class MethodLookup {
  final String protocolPath;
  final Map<String, int> _lookup = {};

  MethodLookup(this.protocolPath);

  Future<void> load(DatabaseConnection dbConn) async {
    try {
      _attemptLoad(dbConn);
    }
    catch(e) {
      // It's possible that another server instance is booting up at the same
      // time, in which case a write can fail if they are happening
      // simultaneously. Make a second attempt to load after waiting a second.
      print('Failed to load method lookup. Making second attempt in 1 second');
      Future.delayed(Duration(seconds: 1));
      _attemptLoad(dbConn);
    }
  }

  Future<void> _attemptLoad(DatabaseConnection dbConn) async {
    var file = File(protocolPath);
    Map endpoints = loadYaml(file.readAsStringSync());

    for (String endpoint in endpoints.keys) {
      List methods = endpoints[endpoint];
      for (Map methodDef in methods) {
        String method = methodDef.keys.first;

        // Find in database
        internal.MethodInfo? methodInfo = await dbConn.findSingleRow(
          internal.tMethodInfo,
          where: internal.tMethodInfo.endpoint.equals(endpoint) & internal.tMethodInfo.method.equals(method),
        ) as internal.MethodInfo?;

        if (methodInfo == null) {
          // We don't know about this method, it's new
          methodInfo = internal.MethodInfo(
            endpoint: endpoint,
            method: method,
          );

          if (await dbConn.insert(methodInfo)) {
            // Successfully inserted
            _lookup['$endpoint.$method'] = methodInfo.id!;
          }
          else {
            throw Exception('Failed insert method');
          }
        }
        else {
          // We found a method info
          _lookup['$endpoint.$method'] = methodInfo.id!;
        }
      }
    }

    print('lookup: $_lookup');
  }

  int? lookupMethod(String endpoint, String method) {
    return _lookup['$endpoint.$method'];
  }
}