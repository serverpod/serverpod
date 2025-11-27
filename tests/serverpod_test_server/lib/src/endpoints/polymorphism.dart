import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

/// Endpoint for testing polymorphism functionality.
class InheritancePolymorphismTestEndpoint extends Endpoint {
  /// Receives a PolymorphicParent object for testing serialization.
  ///
  /// Returns the runtime type and the object itself. The object must retain
  /// its class when received by the client.
  Future<(String, PolymorphicParent)> polymorphicRoundtrip(
    Session session,
    PolymorphicParent parent,
  ) async {
    var runtimeType = parent.runtimeType.toString();
    return (runtimeType, parent);
  }

  /// Receives a PolymorphicParent object through streaming for testing.
  ///
  /// Yields the runtime type and the object itself. The object must retain its
  /// class when received by the client.
  Stream<(String, PolymorphicParent)> polymorphicStreamingRoundtrip(
    Session session,
    Stream<PolymorphicParent> stream,
  ) async* {
    await for (var parent in stream) {
      yield (parent.runtimeType.toString(), parent);
    }
  }

  /// Receives a PolymorphicChildContainer object for testing serialization.
  ///
  /// Returns the container object itself. All nested polymorphic objects must
  /// retain their runtime types when received by the client.
  Future<PolymorphicChildContainer> polymorphicContainerRoundtrip(
    Session session,
    PolymorphicChildContainer container,
  ) async {
    return container;
  }

  /// Receives a ModulePolymorphicChildContainer object for testing serialization.
  ///
  /// Returns the container object itself. All nested polymorphic objects must
  /// retain their runtime types when received by the client.
  Future<ModulePolymorphicChildContainer> polymorphicModuleContainerRoundtrip(
    Session session,
    ModulePolymorphicChildContainer container,
  ) async {
    return container;
  }
}
