import 'package:meta/meta_meta.dart';

/// Used to annotate endpoint classes and methods that should be ignored by the Serverpod code
/// analyzer and generator.
///
/// If an endpoint (class or method) is annotated with this annotation:
/// - No client code to call the endpoint will ge generated.
/// - No server code to handle requests towards the endpoint will be generated.
const doNotGenerate = _DoNotGenerate();

/// Used to annotate endpoint classes and methods that should not use authentication.
///
/// If an endpoint (class or method) is annotated with this annotation:
/// - No authentication will be added to the header on the client when calling it.
/// - The server will receive calls as if there is no user signed in.
const unauthenticatedClientCall = _UnauthenticatedClientCall();

/// Declares how an endpoint class or method is authenticated in the generated
/// OpenAPI specification.
///
/// [scheme] must match a key under `openapi.securitySchemes` in
/// `config/generator.yaml`. [scopes] lists the scopes required (used by OAuth2
/// and OpenID Connect schemes). An annotation on a method overrides the one on
/// its endpoint class.
///
/// This only affects documentation; it does not enforce anything at runtime.
/// Use `requireLogin` and `requiredScopes` on the endpoint for that.
///
/// ```dart
/// @OpenApiAuth('serverpodAuth', scopes: ['admin'])
/// class AdminEndpoint extends Endpoint {}
/// ```
@Target({
  TargetKind.classType,
  TargetKind.method,
})
class OpenApiAuth {
  /// The name of the security scheme, as declared in `generator.yaml`.
  final String scheme;

  /// The scopes required to call the annotated endpoint or method.
  final List<String> scopes;

  /// Creates an [OpenApiAuth] annotation.
  const OpenApiAuth(this.scheme, {this.scopes = const []});
}

/// Adds documentation to the generated OpenAPI operation for an endpoint class
/// or method. Values set here take precedence over the doc comment.
@Target({
  TargetKind.classType,
  TargetKind.method,
})
class OpenApiDoc {
  /// A short summary of the operation.
  final String? summary;

  /// A longer description of the operation.
  final String? description;

  /// Tags used to group the operation. Defaults to the endpoint name.
  final List<String> tags;

  /// Overrides the generated `operationId`.
  final String? operationId;

  /// Creates an [OpenApiDoc] annotation.
  const OpenApiDoc({
    this.summary,
    this.description,
    this.tags = const [],
    this.operationId,
  });
}

/// Documents an additional response of an endpoint method in the generated
/// OpenAPI specification, e.g. an error response. Can be repeated.
@Target({
  TargetKind.method,
})
class OpenApiResponse {
  /// The HTTP status code of the response.
  final int statusCode;

  /// A description of when this response is returned.
  final String description;

  /// Creates an [OpenApiResponse] annotation.
  const OpenApiResponse(this.statusCode, this.description);
}

/// Hides an endpoint class or method from the generated OpenAPI specification.
/// Unlike [doNotGenerate], client and server code is still generated.
const openApiExclude = _OpenApiExclude();

@Target({
  TargetKind.classType,
  TargetKind.method,
})
class _OpenApiExclude {
  const _OpenApiExclude();
}

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
