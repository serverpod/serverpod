import 'package:magic_recipe_server/src/birthday_reminder.dart';
import 'package:serverpod/serverpod.dart';

import 'package:magic_recipe_server/src/web/routes/root.dart';

import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      //TODO: This is where you would send the validation email to the user.
      // We are using print here instead of logging to avoid keeping this in
      // production
      print('Validation code: $validationCode');
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      //TODO: This is where you would send the password reset email to the user.
      // We are using print here instead of logging to avoid keeping this in
      // production
      print('Validation code: $validationCode');
      return true;
    },
    onUserCreated: (Session session, auth.UserInfo userInfo) async {
      if (userInfo.email?.endsWith('serverpod.dev') ?? false) {
        // Add admin scope to the user
        await auth.Users.updateUserScopes(session, userInfo.id!, {Scope.admin});
        session.log(
          'User ${userInfo.email} created with admin scope',
          level: LogLevel.info,
        );
      }
    },
  ));
  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  // Start the server.
  await pod.start();

  // After starting the server, you can register future calls. Future calls are
  // tasks that need to happen in the future, or independently of the request/response
  // cycle. For example, you can use future calls to send emails, or to schedule
  // tasks to be executed at a later time. Future calls are executed in the
  // background. Their schedule is persisted to the database, so you will not
  // lose them if the server is restarted.

  pod.registerFutureCall(
    BirthdayReminder(),
    FutureCallNames.birthdayReminder.name,
  );

  // You can schedule future calls for a later time during startup. But you can also
  // schedule them in any endpoint or webroute through the session object.
  // there is also [futureCallAtTime] if you want to schedule a future call at a
  // specific time.
  await pod.futureCallWithDelay(
    FutureCallNames.birthdayReminder.name,
    Greeting(
      message: 'Hello!',
      author: 'Serverpod Server',
      timestamp: DateTime.now(),
    ),
    Duration(seconds: 5),
  );
}

/// Names of all future calls in the server.
///
/// This is better than using a string literal, as it will reduce the risk of
/// typos and make it easier to refactor the code.
enum FutureCallNames {
  birthdayReminder,
}
