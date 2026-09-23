import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:serverpod_push_store_server/serverpod_push_store_server.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/push_test/controllable_fcm_provider.dart';
import 'src/push_test_endpoint.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under /.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addMiddleware(
      FallbackMiddleware(
        fallback: defaultRoute,
        on: (response) => response.statusCode == 404,
      ).call,
      '/',
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/**',
    );
  }

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

  final fcm = FcmPushProvider(
    credentials: FirebaseServiceAccountCredentials.fromJsonFile(
      File('config/firebase_service_account_key.json'),
    ),
  );
  final controllable = ControllableFcmProvider(fcm);
  PushTestEndpoint.controllable = controllable;

  final providers = <PushProviderBuilder>[
    PreBuiltPushProviderBuilder(controllable),
  ];

  // Optional: add config/onesignal.json with {"appId":"...","restApiKey":"..."}.
  // sendTimeout stays under claimTimeout/2 (example claimTimeout is 5s).
  final oneSignalFile = File('config/onesignal.json');
  if (oneSignalFile.existsSync()) {
    final decoded =
        jsonDecode(oneSignalFile.readAsStringSync()) as Map<String, dynamic>;
    providers.add(
      OneSignalPushProviderBuilder(
        appId: decoded['appId'] as String,
        restApiKey: decoded['restApiKey'] as String,
        sendTimeout: const Duration(seconds: 2),
      ),
    );
  }

  // Optional: add config/sns.json with region, accessKeyId, secretAccessKey,
  // and platform application ARNs. sendTimeout stays under claimTimeout/2.
  final snsFile = File('config/sns.json');
  if (snsFile.existsSync()) {
    final decoded =
        jsonDecode(snsFile.readAsStringSync()) as Map<String, dynamic>;
    String? optional(final String key) {
      final value = decoded[key];
      if (value is! String || value.isEmpty) return null;
      return value;
    }

    providers.add(
      SnsPushProviderBuilder(
        region: decoded['region'] as String,
        accessKeyId: decoded['accessKeyId'] as String,
        secretAccessKey: decoded['secretAccessKey'] as String,
        sessionToken: optional('sessionToken'),
        androidPlatformApplicationArn: optional(
          'androidPlatformApplicationArn',
        ),
        iosPlatformApplicationArn: optional('iosPlatformApplicationArn'),
        macosPlatformApplicationArn: optional('macosPlatformApplicationArn'),
        apnsEnvironment: decoded['apnsSandbox'] == true
            ? SnsApnsEnvironment.sandbox
            : SnsApnsEnvironment.production,
        sendTimeout: const Duration(seconds: 2),
      ),
    );
  }

  PushService.set(providers: providers);

  // Start the server.
  await pod.start();

  await pod.initializePushStore(
    config: const PushStoreConfig(
      scanInterval: Duration(seconds: 1),
      // Keep interactive retry/timeout cases snappy.
      maxAttempts: 3,
      maxClaims: 3,
      baseBackoff: Duration(milliseconds: 50),
      maxBackoff: Duration(seconds: 1),
      backoffJitter: 0,
      claimTimeout: Duration(seconds: 5),
    ),
  );
}
