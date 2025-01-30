import 'dart:io';
import 'package:pubspec_parse/pubspec_parse.dart';
// import 'package:sentry/sentry.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_cloud_storage_s3/serverpod_cloud_storage_s3.dart'
    as s3;
import 'package:serverpod_test_server/src/web/routes/root.dart';

import 'src/futureCalls/test_call.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

final pubspec = File('pubspec.yaml').readAsStringSync();
final parsedPubspec = Pubspec.parse(pubspec);

void run(List<String> args) async {
  // Create serverpod
  var pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
    eventHandlers: [
      SentryExceptionHandler(),
      AsEventHandler(_printExceptionEvent),
    ],
  );

  // Add future calls
  pod.registerFutureCall(TestCall(), 'testCall');

  // Add S3 storage
  pod.addCloudStorage(s3.S3CloudStorage(
      serverpod: pod,
      storageId: 's3',
      public: true,
      region: 'us-west-2',
      bucket: 'serverpod-test-storage'));

  // Callbacks for auth
  auth.AuthConfig.set(auth.AuthConfig(
    onUserWillBeCreated: (session, userInfo, authMethod) async {
      return (userInfo.email!.endsWith('.bar'));
    },
    sendValidationEmail: (session, email, validationCode) async {
      print('Sending validation email to $email with code $validationCode');
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, resetCode) async {
      print('Sending reset email to ${userInfo.email} with code $resetCode');
      return true;
    },
    userCanEditFullName: true,
  ));

  // Add route to web server
  pod.webServer.addRoute(RouteRoot(), '/');

  await _initSentrySdk(pod);

  // Start the server
  await pod.start();
}

Future<void> _initSentrySdk(final Serverpod pod) async {
  // See also env vars:
  // SENTRY_DSN
  // SENTRY_RELEASE
  // SENTRY_ENVIRONMENT

  // final environmentType = pod.runMode.toLowerCase();

  // await Sentry.init(
  //   (final options) => options
  //     ..dsn =
  //         'https://6c64648b94d5221bc1ef287cef162dc1@o4508681651421184.ingest.de.sentry.io/4508681657122896'
  //     ..release = '${parsedPubspec.name}@${parsedPubspec.version}'
  //     ..environment = environmentType
  //     ..tracesSampleRate = 1.0,
  // );
}

class SentryExceptionHandler extends ExceptionHandler {
  @override
  Future<void> handleTypedEvent(
    ExceptionEvent event,
    OriginSpace space, {
    required EventContext context,
  }) async {
    // await Sentry.captureException(
    //   event.exception,
    //   stackTrace: event.stackTrace,
    //   withScope: (scope) {
    //     scope.setTag('serverpod', 'serverpod-test-server');
    //     scope.setTag('origin-space', space.toString());

    //     var message = event.message;
    //     if (message != null) scope.setTag('event-message', message);

    //     context.toMap().forEach((key, value) {
    //       scope.setTag('context-$key', value);
    //     });
    //   },
    // );
  }
}

Future<void> _printExceptionEvent(
  ExceptionEvent event,
  OriginSpace space, {
  required EventContext context,
}) async {
  stderr.writeln(
    '@@@@@@@@@@@@@@@@@@@@@@ ${event.exception}'
    ' $space'
    ' $context',
  );
}
