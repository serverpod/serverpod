import 'package:relic/relic.dart';

/// Creates a handler that serves static files mounted at a specific [moutedPath].
///
/// This handler first checks if the incoming request's path starts with the
/// provided [moutedPath]. If it does, the static file handler will attempt to
/// serve a file from the specified [fileSystemPath].
///
/// If the file is found and its status code is not one of the specified [statusCodes],
/// it returns the response from the static handler. Otherwise, it falls back
/// to the [continueHandler], allowing the request to continue through the
/// server's other routes or middleware.
///
/// [fileSystemPath] - The path where the static files are located.
/// [moutedPath] - The URI path where static files should be served.
/// [continueHandler] - The handler to call if the static handler does not return a valid response.
/// [statusCodes] - A list of HTTP status codes (defaults to [404, 505]) that will trigger the fallback to [continueHandler].
Handler createMountedStaticHandler({
  required String fileSystemPath,
  required String mountedPath,
  required Handler continueHandler,
  List<int> statusCodes = const [404, 505],
}) {
  var staticHandler = createStaticHandler(fileSystemPath);

  return (Request request) async {
    var requestedPath = request.requestedUri.path;

    // Ensure the mountedPath has both leading and trailing slashes
    var normalizedMountedPath = mountedPath;
    if (!normalizedMountedPath.startsWith('/')) {
      normalizedMountedPath = '/$normalizedMountedPath';
    }
    if (!normalizedMountedPath.endsWith('/')) {
      normalizedMountedPath = '$normalizedMountedPath/';
    }

    // Check if the request path starts with the mounted path
    if (request.requestedUri.path.startsWith(normalizedMountedPath)) {
      // Safely replace the mounted path prefix
      var modifiedPath = requestedPath
          .replaceFirst(normalizedMountedPath, '/')
          // Prevent double slashes in the resulting path
          .replaceAll(RegExp(r'//+'), '/');

      // Create a new request with the modified path
      var modifiedRequest = request.copyWith(
        requestedUri: request.requestedUri.replace(path: modifiedPath),
      );
      // Serve the request using the static handler
      var response = await staticHandler(modifiedRequest);

      /// Return the response if its status code is not in the [statusCodes] list.
      if (!statusCodes.toSet().contains(response.statusCode)) {
        return response;
      }
    }
    // If the path does not match or the status code is in [statusCodes], continue with the next handler
    return continueHandler(request);
  };
}
