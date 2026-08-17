part of 'serverpod_client_exception.dart';

/// Thrown if not able to get an endpoint on the client by type.
class ServerpodClientGetEndpointException extends ServerpodClientException {
  /// Creates an Endpoint Missing Exception.
  const ServerpodClientGetEndpointException(super.message);

  @override
  String toString() => message;
}

/// Thrown if the client tries to call an endpoint that was not generated.
/// This will typically happen if getting the endpoint by type while the user
/// has not defined the endpoint in their project.
final class ServerpodClientEndpointNotFound
    extends ServerpodClientGetEndpointException {
  /// Creates an Endpoint Missing Exception.
  const ServerpodClientEndpointNotFound(Type type, {String? name})
    : super(
        'No endpoint of type "$type" '
        '${name != null ? 'with name "$name" ' : ''}found.',
      );
}

/// Thrown if the client tries to call an endpoint by type, but multiple
/// endpoints of that type exists. The user should disambiguate by using the
/// name parameter.
final class ServerpodClientMultipleEndpointsFound
    extends ServerpodClientGetEndpointException {
  /// Creates an Multiple Endpoints Found Exception.
  ServerpodClientMultipleEndpointsFound(
    Type type,
    Iterable<EndpointRef> endpoints,
  ) : super(
        'Found ${endpoints.length} endpoints of type "$type": '
        '${endpoints.map((e) => '"${e.name}"').join(', ')}. '
        'Use the name parameter to disambiguate.',
      );
}
