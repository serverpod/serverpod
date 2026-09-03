// {{#webapp}}
import 'dart:io';
// {{/webapp}}

// {{#auth}}
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
// {{/auth}}
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

// {{#webserver}}
import 'src/cache_busting.dart';
// {{/webserver}}
import 'src/generated/serverpod.dart';
// {{#webapp}}
import 'src/web/routes/app_config_route.dart';
// {{/webapp}}
// {{#website}}
import 'src/web/routes/root.dart';

// {{/website}}

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // {{#auth}}
  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      // The default setup works with Serverpod Cloud without configuration. In
      // development the verification codes are logged to the console, and in
      // staging and production they are sent through the Serverpod Cloud email
      // service. If you want to use a custom provider for sending emails, use
      // `EmailIdpConfigFromPasswords`.
      ServerpodCloudEmailIdpConfig(
        appDisplayName: 'projectname',
      ),
    ],
  );
  // {{/auth}}

  // {{#website}}
  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // {{/website}}

  // {{#webserver}}
  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );
  // {{/webserver}}

  // {{#webapp}}
  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    // {{#website}}
    '/app/assets/assets/config.json',
    // {{/website}}
    // {{^website}}
    '/assets/assets/config.json',
    // {{/website}}
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // {{#website}}
    // Serve the flutter web app under the /app path.
    // {{/website}}
    // {{^website}}
    // Serve the flutter web app under /.
    // {{/website}}
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      // {{#website}}
      '/app',
      // {{/website}}
      // {{^website}}
      '/',
      // {{/website}}
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    // {{^website}}
    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );
    // {{/website}}

    pod.webServer.addRoute(
      defaultRoute,
      // {{#website}}
      '/app/**',
      // {{/website}}
      // {{^website}}
      '/**',
      // {{/website}}
    );
  }
  // {{/webapp}}

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();
}
