import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart';

/// Plain extension of the existing endpoint
class ModuleEndpointSubclass extends IgnoredModuleEndpoint {}

class ModuleEndpointAdaptation extends IgnoredModuleEndpoint {
  @override
  Future<String> echoString(Session sesion, String value) {
    return super.echoString(sesion, 're-exposed: $value');
  }

  /// Extended `echoRecord` which takes an optional argument for a multiplier
  ///
  /// This shows a backwards-compatible extension of the method, which is enforced by the Dart type system.
  @override
  Future<(int, BigInt)> echoRecord(
    Session sesion,
    (int, BigInt) value, [
    int? multiplier,
  ]) async {
    multiplier ??= 1;
    return super.echoRecord(
      sesion,
      (value.$1 * multiplier, value.$2 * BigInt.from(multiplier)),
    );
  }

  @override
  Future<Set<int>> echoContainer(Session sesion, Set<int> value) {
    return super.echoContainer(sesion, value);
  }

  @override
  Future<ModuleClass> echoModel(Session sesion, ModuleClass value) {
    return super.echoModel(sesion, value);
  }
}

class ModuleEndpointReduction extends IgnoredModuleEndpoint {
  /// Hide the `echoString` endpoint
  ///
  /// Since this requires an implementation on the Dart-level, we throw `UnimplementedError` by convention,
  /// even though this would never be called via the protocol.
  @ignoreEndpoint
  Future<String> echoString(Session sesion, String value) {
    throw UnimplementedError();
  }
}

/// Subclass inheriting all base class methods and adding a furhter method itself
class ModuleEndpointExtension extends IgnoredModuleEndpoint {
  Future<String> greet(Session session, String name) async {
    return 'Hello $name';
  }

  @override
  Future<void> ignoredMethod(Session session) async {}
}
