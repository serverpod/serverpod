import 'package:serverpod/serverpod.dart';

/// Middleware that adds WebAssembly multi-threading headers to responses.
///
/// Adds the following headers required for SharedArrayBuffer and WASM
/// multi-threading:
/// - `Cross-Origin-Opener-Policy` (defaults to `same-origin`)
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
/// ## Cross-Origin-Opener-Policy and popup-based sign-in flows
///
/// The default `same-origin` policy achieves full cross-origin isolation,
/// which is required for `SharedArrayBuffer`/WASM multi-threading, but it
/// also prevents `window.postMessage`-based popup flows (such as
/// "Sign in with Google") from communicating back with the opening window.
///
/// If your app needs those popup-based flows, set
/// [crossOriginOpenerPolicy] to
/// [CrossOriginOpenerPolicyHeader.sameOriginAllowPopups]. This keeps
/// `SharedArrayBuffer` and other cross-origin-isolation-only APIs disabled,
/// so only do this if your app does not rely on WASM multi-threading.
///
/// ## How It Works
///
/// The middleware intercepts all Response objects and adds COOP/COEP headers.
/// Other Result types (Hijack, WebSocketUpgrade) pass through unchanged.
/// Existing headers are preserved.
class WasmHeadersMiddleware extends MiddlewareObject {
  /// The `Cross-Origin-Opener-Policy` header value to add to responses.
  ///
  /// Defaults to [CrossOriginOpenerPolicyHeader.sameOrigin], which is
  /// required for full cross-origin isolation (`SharedArrayBuffer`/WASM
  /// multi-threading) but blocks popup-based sign-in flows.
  final CrossOriginOpenerPolicyHeader crossOriginOpenerPolicy;

  /// Creates a new WasmHeadersMiddleware
  const WasmHeadersMiddleware({
    this.crossOriginOpenerPolicy = CrossOriginOpenerPolicyHeader.sameOrigin,
  });

  @override
  Handler call(Handler next) {
    return (Request req) async {
      final result = await next(req);

      // Only modify Response objects
      if (result is Response) {
        return result.copyWith(
          headers: result.headers.transform((mh) {
            mh.crossOriginOpenerPolicy = crossOriginOpenerPolicy;
            mh.crossOriginEmbedderPolicy =
                CrossOriginEmbedderPolicyHeader.requireCorp;
          }),
        );
      }

      return result;
    };
  }
}
