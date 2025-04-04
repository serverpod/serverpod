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

enum AuthMode {
  /// Project updating from Serverpod Auth v1 to v2
  updateProject,

  /// Project starting with the Auth2 modules
  freshProject,
}

var authMode = AuthMode.updateProject;

void run(List<String> args) async {
  final Serverpod pod;
  switch (authMode) {
    case AuthMode.updateProject:
      pod = Serverpod(
        args,
        Protocol(),
        Endpoints(),
        authenticationHandler: auth_session.authenticationHandlerWithMigration(
          auth_migration.sessionMigrationFunction,
        ),
      );

      // maybe put into config, where we might also handle lifetime
      // auth_session.Config.update(migrationCallback: auth_migration.sessionMigrationFunction);

      email_account.EmailAccountConfig.update(
          // TODO: Configure email sending etc.
          //   existingUserImportFunction: () {
          //   }
          // by default would be based on the profile (which the endpoint knows, but could be overwritten here)
          // TODO: This was kept out of the core "email account", so there is no user creation in there, just on the higher level, and users get linked to the core account
          // consolidateUser: auth_profile.findExistingUserByEmail,
          );

      auth_migration.AuthMigrationConfig.update(
        // TODO: Here we could switch to records and fully align the type, so the package can provide a nice, full default implementation without relying on the old modules
        afterAuthUserMigration: (session, authUser, userInfo) async {
          // TODO: get from package once types are aligned
          await auth_profile.createUserProfile(session,
              userId: authUser.id!,
              email: userInfo.email,
              fullName: userInfo.fullName /* … */
              );
        },

        // afterAuthUserMigration: auth_profile.createUserProfile,
      );

    // TODO: Support "background migration" for inactive accounts
    // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

    case AuthMode.freshProject:
      pod = Serverpod(
        args,
        Protocol(),
        Endpoints(),
        authenticationHandler: auth_session.authenticationHandler,

        ///
      );

      email_account.EmailAccountConfig.update(
          // TODO: Configure email sending
          );
  }

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
