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

@Target({
  TargetKind.classType,
  TargetKind.method,
})
class _DoNotGenerate {
  const _DoNotGenerate();
}

@Target({
  TargetKind.classType,
  TargetKind.method,
})
class _UnauthenticatedClientCall {
  const _UnauthenticatedClientCall();
}
