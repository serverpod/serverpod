import 'package:serverpod/serverpod.dart';

int globalInt = 0;

/// A simple endpoint that modifies a global integer. This class is meant for
/// testing and the documentation has multiple lines.
class SimpleEndpoint extends Endpoint {
  /// Sets a global integer.
  Future<void> setGlobalInt(Session session, int? value,
      [int? secondValue]) async {
    globalInt = value!;
  }

  /// Adds 1 to the global integer.
  Future<void> addToGlobalInt(Session session) async {
    globalInt += 1;
  }

  /// Retrieves a global integer.
  Future<int> getGlobalInt(Session session) async {
    return globalInt;
  }

  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
}
