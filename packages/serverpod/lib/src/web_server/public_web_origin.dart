import 'package:serverpod_shared/serverpod_shared.dart';

/// The public origin of the web server with [path] appended.
///
/// Scheme, host, and port come from [webServer] (`publicScheme` / `publicHost`
/// / `publicPort`). The port is omitted for `http` on 80 and `https` on 443.
/// [path] is the route path; it is never taken from the request, `Host`, or
/// `X-Forwarded-Host`.
Uri publicWebOrigin(ServerConfig webServer, String path) {
  final scheme = webServer.publicScheme;
  final port = webServer.publicPort;
  final omitPort =
      (scheme == 'http' && port == 80) || (scheme == 'https' && port == 443);
  final normalizedPath = path.startsWith('/') ? path : '/$path';
  return Uri(
    scheme: scheme,
    host: webServer.publicHost,
    port: omitPort ? null : port,
    path: normalizedPath,
  );
}
