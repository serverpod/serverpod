import 'dart:io';

import '../../server.dart';
import 'package:yaml/yaml.dart';

import '../generated/protocol.dart' as internal;

// TODO: Use this for statistics in the future. Also, add support for modules.

/// The [MethodLookup] maps [Endpoint] method calls to integer values. It's
/// designed to be persistent between server updates and consistent between
/// servers in the same cluster. It's used for minimizing storage when saving
/// server statistics.
class MethodLookup {
  final String _protocolPath;
  final Map<String, int> _lookup = <String, int>{};

  /// Creates a new lookup class using the generated protocol file.
  MethodLookup(this._protocolPath);

  /// Loads the lookup from database.
  Future<void> load(Session session) async {
    try {
      await _attemptLoad(session);
    } catch (e) {
      // It's possible that another server instance is booting up at the same
      // time, in which case a write can fail if they are happening
      // simultaneously. Make a second attempt to load after waiting a second.
      await Future<void>.delayed(const Duration(seconds: 1));
      await _attemptLoad(session);
    }
  }

  Future<void> _attemptLoad(Session session) async {
    // TODO: Use transactions for this.
    File file = File(_protocolPath);
    YamlMap endpoints = loadYaml(file.readAsStringSync());

    for (String endpoint in endpoints.keys) {
      List<dynamic>? methods = endpoints[endpoint];
      if (methods == null) continue;

      for (Map<String, dynamic> methodDef in methods) {
        String method = methodDef.keys.first;

        // Find in database
        internal.MethodInfo? methodInfo =
            await session.db.findSingleRow<internal.MethodInfo>(
          where: internal.MethodInfo.t.endpoint.equals(endpoint) &
              internal.MethodInfo.t.method.equals(method),
        );

        if (methodInfo == null) {
          // We don't know about this method, it's new
          methodInfo = internal.MethodInfo(
            endpoint: endpoint,
            method: method,
          );

          await session.db.insert(methodInfo);

          // Successfully inserted
          _lookup['$endpoint.$method'] = methodInfo.id!;
        } else {
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
