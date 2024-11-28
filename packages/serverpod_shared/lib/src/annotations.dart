/// Used to annotate endpoints that should be ignored by the Serverpod code
/// analyzer.
///
/// If an endpoint class is annotated with this annotation:
/// - No client code to call the endpoint will ge generated.
/// - No server code to handle requests towards the endpoint will be generated.
const ignoreEndpoint = _IgnoreEndpoint();

/// Names of annotations used by the Serverpod framework.
abstract final class ServerpodAnnotationClassNames {
  /// Name of the ignore endpoint annotation class.
  /// Needs to be synchronized with the [_ignoreEndpoint] annotation.
  static const String ignoreEndpoint = '_IgnoreEndpoint';
}

/// Name of the class needs to be synchronized with the
/// [ServerpodAnnotationClassNames.ignoreEndpoint] constant.
class _IgnoreEndpoint {
  const _IgnoreEndpoint();
}
