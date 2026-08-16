import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as m;

/// An abstract endpoint with a virtual method.
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

  /// This body should not be present in the generated abstract class.
  Stream<String> abstractBaseStreamMethod(Session session) async* {
    yield 'abstractBaseStream';
  }
}

/// A concrete endpoint that extends the abstract endpoint.
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

/// An abstract endpoint that extends a concrete endpoint. Should override all
/// methods, since abstract generated class have all methods as abstract.
abstract class AbstractSubClassEndpoint extends ConcreteBaseEndpoint {
  Future<String> subClassVirtualMethod(Session session);
}

/// A concrete endpoint that extends an abstract endpoint with concrete parent.
class ConcreteSubClassEndpoint extends AbstractSubClassEndpoint {
  @override
  Future<String> subClassVirtualMethod(Session session) async {
    return 'subClassVirtualMethod';
  }

  /// This method should no longer be present in the generated class.
  @doNotGenerate
  @override
  Future<String> ignoredMethod(Session session) async {
    throw UnimplementedError();
  }
}

/// A class that should not be generated and breaks the inheritance chain.
@doNotGenerate
class BrokenInheritanceEndpoint extends ConcreteSubClassEndpoint {}

/// A class that carries all methods from the inheritance chain, but do not
/// extend any of the classes. Should inherit [Endpoint] directly.
class IndependentEndpoint extends BrokenInheritanceEndpoint {}

/// An abstract endpoint that extends an abstract endpoint from another module.
abstract class AbstractModuleBaseEndpoint extends m.AbstractBaseEndpoint {}

/// A concrete endpoint that extends an abstract endpoint from another module.
class ConcreteFromModuleAbstractBaseEndpoint extends m.AbstractBaseEndpoint {
  @override
  Future<String> virtualMethod(Session session) async {
    return 'virtualMethod';
  }
}

/// A concrete endpoint that extends a concrete endpoint from another module.
class ConcreteModuleBaseEndpoint extends m.ConcreteBaseEndpoint {}

/// An abstract endpoint that extends a concrete endpoint from another module.
abstract class AbstractModuleSubClassEndpoint extends m.ConcreteBaseEndpoint {}
