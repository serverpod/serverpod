import 'package:serverpod/serverpod.dart';

/// Middleware that adds WebAssembly multi-threading headers to responses.
///
/// Adds the following headers required for SharedArrayBuffer and WASM
/// multi-threading:
/// - `Cross-Origin-Opener-Policy: same-origin`
/// - `Cross-Origin-Embedder-Policy: require-corp`
///
/// These headers enable Flutter web apps to use WebAssembly multi-threading
/// features by establishing cross-origin isolation.
///
/// ## Usage with FlutterRoute
///
/// FlutterRoute automatically applies this middleware, so you typically
/// don't need to use it directly:
///
/// ```dart
/// pod.webServer.addRoute(FlutterRoute(Directory('web/app')));
/// ```
///
/// ## Standalone Usage
///
/// You can also apply it manually to any route:
///
/// ```dart
/// pod.webServer.addMiddleware(WasmHeadersMiddleware(), '/app');
/// ```
///
/// ## How It Works
///
/// The middleware intercepts all Response objects and adds COOP/COEP headers.
/// Other Result types (Hijack, WebSocketUpgrade) pass through unchanged.
/// Existing headers are preserved.
class WasmHeadersMiddleware extends MiddlewareObject {
  /// Creates a new WasmHeadersMiddleware
  const WasmHeadersMiddleware();

  @override
  Handler call(Handler next) {
    return (Request req) async {
      final result = await next(req);

      // Only modify Response objects
      if (result is Response) {
        return result.copyWith(
          headers: result.headers.transform((mh) {
            mh.crossOriginOpenerPolicy =
                CrossOriginOpenerPolicyHeader.sameOrigin;
            mh.crossOriginEmbedderPolicy =
                CrossOriginEmbedderPolicyHeader.requireCorp;
          }),
        );
      }

      return result;
    };
  }
}
