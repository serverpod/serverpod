import 'package:meta/meta_meta.dart';

/// Used to annotate endpoint classes and methods that should be ignored by the Serverpod code
/// analyzer and generator.
///
/// If an endpoint (class or method) is annotated with this annotation:
/// - No client code to call the endpoint will ge generated.
/// - No server code to handle requests towards the endpoint will be generated.
const doNotGenerate = _DoNotGenerate();

/// Used to annotate endpoints that should be ignored by the Serverpod code
/// analyzer.
///
/// If an endpoint class is annotated with this annotation:
/// - No client code to call the endpoint will ge generated.
/// - No server code to handle requests towards the endpoint will be generated.
@Deprecated('Use `@doNotGenerate` instead')
const ignoreEndpoint = doNotGenerate;

/// Used to annotate endpoint classes and methods that should not use authentication.
///
/// If an endpoint (class or method) is annotated with this annotation:
/// - No authentication will be added to the header on the client when calling it.
/// - The server will receive calls as if there is no user signed in.
const unauthenticatedClientCall = _UnauthenticatedClientCall();

/// Names of annotations used by the Serverpod framework.
abstract final class ServerpodAnnotationClassNames {
  /// Name of the "do not generate" annotation class.
  /// Needs to be synchronized with the [_DoNotGenerate] annotation.
  static const String doNotGenerate = '_DoNotGenerate';

  /// Name of the "unauthenticatedClientCall" annotation class.
  /// Needs to be synchronized with the [_UnauthenticatedClientCall] annotation.
  static const String unauthenticatedClientCall = '_UnauthenticatedClientCall';
}

/// Name of the class needs to be synchronized with the
/// [ServerpodAnnotationClassNames.doNotGenerate] constant.
@Target({
  TargetKind.classType,
  TargetKind.method,
})
class _DoNotGenerate {
  const _DoNotGenerate();
}

/// Name of the class needs to be synchronized with the
/// [ServerpodAnnotationClassNames.unauthenticatedClientCall] constant.
@Target({
  TargetKind.classType,
  TargetKind.method,
})
class _UnauthenticatedClientCall {
  const _UnauthenticatedClientCall();
}
