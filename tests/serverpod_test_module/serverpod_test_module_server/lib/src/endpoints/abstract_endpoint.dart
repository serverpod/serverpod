import 'package:serverpod/serverpod.dart';

/// An abstract endpoint with a virtual method.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
abstract class AbstractBaseEndpoint extends Endpoint {
  /// This is a virtual method that must be overriden.
  Future<String> virtualMethod(Session session);

  /// This method should not be present in the any generated class.
  @doNotGenerate
  Future<String> ignoredMethod(Session session) async {
    return 'ignoredMethod';
  }

  /// This body should not be present in the generated abstract class.
  Future<String> abstractBaseMethod(Session session) async {
    return 'abstractBaseMethod';
  }
}

/// A concrete endpoint that extends the abstract endpoint.
///
/// Uses same name and path than the endpoint on `serverpod_test_server` to
/// enure classes are not being matched by name only.
class ConcreteBaseEndpoint extends AbstractBaseEndpoint {
  @override
  Future<String> virtualMethod(Session session) async {
    return 'virtualMethod';
  }

  /// A concrete method that should be present in the generated class.
  Future<String> concreteMethod(Session session) async {
    return 'concreteMethod';
  }
}
