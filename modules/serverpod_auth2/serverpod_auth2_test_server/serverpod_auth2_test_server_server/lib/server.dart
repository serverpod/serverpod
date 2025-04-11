import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth2_test_server_server/src/web/routes/root.dart';
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as email_account;
import 'package:serverpod_auth_migration_server/serverpod_auth_migration_server.dart'
    as auth_migration;
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as auth_profile;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as auth_session;

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth_session.authenticationHandlerWithMigration(
      auth_migration.sessionMigrationFunction,
    ),
  );

  // create helpers for the migration, like `withFoo`? Then those could be chained, and the final value `set`
  email_account.EmailAccountConfig.set(
    email_account.EmailAccountConfig(
      existingUserImportFunction: auth_migration.emailAccountImportFunction,
    ),
  );
  // TODO: Check migration with email account, where this endpoint should always create a profile, but only when it has not been migrated 🙈
  auth_migration.AuthMigrationConfig.set(
    auth_migration.AuthMigrationConfig(
      afterAuthUserMigration: (session, authUser, userInfo) async {
        await auth_profile.UserProfile.db.insertRow(
          session,
          auth_profile.UserProfile(
            userId: authUser.id!,
            created: userInfo.created,
            userName: userInfo.userName,
            fullName: userInfo.fullName,
            email: userInfo.email,
            imageUrl: userInfo.imageUrl,
          ),
        );
      },
    ),
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  pod.webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
    '/*',
  );

  if (DateTime.now().microsecondsSinceEpoch < 0) {
    AuthenticationInfo x = null as dynamic;
    // Just showcasing how `dynamic` should be fine here to keep using the user ID,
    // at least while staying on the legacy auth package.
    // When migration to the new users, some code that would still compile would need modification
    // (as otherwise it might pass a UUID where and int is expected).
    await auth.UserInfo.db.findById(await pod.createSession(), x.userId);
  }

  // Start the server.
  await pod.start();
}
