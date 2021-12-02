import 'dart:io';
import 'package:serverpod/server.dart';
import 'package:yaml/yaml.dart';
import '../generated/protocol.dart' as internal;

// TODO: Use this for statistics in the future. Also, add support for modules.

/// The [MethodLookup] maps [Endpoint] method calls to integer values. It's
/// designed to be persistent between server updates and consistent between
/// servers in the same cluster. It's used for minimizing storage when saving
/// server statistics.
class MethodLookup {
  final String _protocolPath;
  final Map<String, int> _lookup = {};

  /// Creates a new lookup class using the generated protocol file.
  MethodLookup(this._protocolPath);

  /// Loads the lookup from database.
  Future<void> load(Session session) async {
    try {
      await _attemptLoad(session);
    }
    catch(e) {
      // It's possible that another server instance is booting up at the same
      // time, in which case a write can fail if they are happening
      // simultaneously. Make a second attempt to load after waiting a second.
      print('Failed to load method lookup. Making second attempt in 1 second');
      await Future.delayed(Duration(seconds: 1));
      await _attemptLoad(session);
    }
  }

  Future<void> _attemptLoad(Session session) async {
    // TODO: Use transactions for this.
    var file = File(_protocolPath);
    Map endpoints = loadYaml(file.readAsStringSync());

    for (String endpoint in endpoints.keys) {
      List? methods = endpoints[endpoint];
      if (methods == null)
        continue;

      for (Map methodDef in methods) {
        String method = methodDef.keys.first;

        // Find in database
        var methodInfo = await session.db.findSingleRow(
          internal.tMethodInfo,
          where: internal.tMethodInfo.endpoint.equals(endpoint) & internal.tMethodInfo.method.equals(method),
        ) as internal.MethodInfo?;

        if (methodInfo == null) {
          // We don't know about this method, it's new
          methodInfo = internal.MethodInfo(
            endpoint: endpoint,
            method: method,
          );

          if (await session.db.insert(methodInfo)) {
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
  }

  /// Lookup the id of a specified method.
  int? lookupMethod(String endpoint, String method) {
    return _lookup['$endpoint.$method'];
  }
}