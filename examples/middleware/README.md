# Custom middleware example

This examples shows how to implement a custom middleware and add it to the server to process all the request and response.

This middleware logs information about each HTTP request including:
- Request method and URI
- Response status code
- Request duration
- Request and response headers (when verbose mode is enabled)

The middleware logs to stdout by default, but accepts an optional
`logger` function for custom logging implementations.

## Basic Usage

 ```dart
void run(List<String> args) async {
   final pod = Serverpod(
     args,
     Protocol(),
     Endpoints(),
   );

   // Add middleware before starting
   pod.server.addMiddleware(loggingMiddleware());

   await pod.start();
 }
 ```

 ## Verbose Mode

Enable verbose mode to log request and response headers:

 ```dart
 pod.server.addMiddleware(loggingMiddleware(verbose: true));
 ```

 ## Custom Logger

Provide a custom logger function to integrate with your logging system:

 ```dart
 pod.server.addMiddleware(
   loggingMiddleware(
     logger: (message) => myCustomLogger.info(message),
     errorLogger: (message) => myCustomLogger.error(message),
   ),
 );
 ```

If only `logger` is provided, errors will also use that logger.
If `errorLogger` is provided, errors will use it instead of `logger`.
If neither is provided, normal logs go to stdout and errors go to stderr.

 ## Output Format

Normal mode:
 ```
 2025-10-30 12:34:56.789Z GET /api/users - 200 (125ms)
 ```

Verbose mode:
 ```
 2025-10-30 12:34:56.789Z GET /api/users
 Request headers: {content-type: application/json, ...}
 Response: 200 (125ms)
 Response headers: {content-type: application/json, ...}
```

## Error Handling

Errors that occur during request processing are logged and re-thrown to
maintain the error propagation chain. Error logging follows the same
routing as normal logs:
- If [errorLogger] is provided, errors use it
- Otherwise, if [logger] is provided, errors use it
- Otherwise, errors go to stderr (default behavior)

