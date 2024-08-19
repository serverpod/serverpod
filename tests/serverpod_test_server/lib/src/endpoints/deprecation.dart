import 'package:serverpod/serverpod.dart';

double globalDouble = 0;

/// A simple endpoint for testing deprecated endpoint methods.
class DeprecationEndpoint extends Endpoint {
  /// A method with a simple "@deprecated" annotation.
  @deprecated
  Future<void> setGlobalDouble(Session session, double? value) async {
    globalDouble = value!;
  }

  /// A method with a "@Deprecated(..)" annotation.
  @Deprecated('Marking endpoint method as deprecated')
  Future<double> getGlobalDouble(Session session) async {
    return globalDouble;
  }
}
