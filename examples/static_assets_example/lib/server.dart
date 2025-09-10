import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' show AuthSessions;

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

void run(final List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: AuthSessions.authenticationHandler,
  );

  // Configure static assets
  pod.configureStaticAssets(StaticAssetsConfig(
    staticDirectories: ['web/static', 'web/assets'],
    cdnUrlPrefix: 'https://mycdn.com/static', // Optional CDN
    enableCacheBusting: true,
  ));

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve static files with cache busting
  pod.webServer.addRoute(
    RouteStaticDirectory(
      serverDirectory: 'static',
      basePath: '/',
      enableAutomaticCacheBusting: true,
      pathCachePatterns: [
        // Cache images for 1 year
        PathCacheMaxAge(
          pathPattern: RegExp(r'.*\.(png|jpg|jpeg|gif|svg|ico)$'),
          maxAge: Duration(days: 365),
        ),
        // Cache CSS and JS for 1 year
        PathCacheMaxAge(
          pathPattern: RegExp(r'.*\.(css|js)$'),
          maxAge: Duration(days: 365),
        ),
        // Don't cache HTML files
        PathCacheMaxAge(
          pathPattern: RegExp(r'.*\.html$'),
          maxAge: PathCacheMaxAge.noCache,
        ),
      ],
    ),
    '/*',
  );

  // Start the server.
  await pod.start();
}
