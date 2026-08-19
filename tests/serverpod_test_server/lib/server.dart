import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_cloud_storage_s3/serverpod_cloud_storage_s3.dart'
    as s3;
import 'package:serverpod_test_server/src/web/routes/root.dart';

import 'src/generated/serverpod.dart';

void run(List<String> args) async {
  // Create serverpod using the generated Serverpod class, which comes
  // pre-configured with the generated Protocol and Endpoints.
  var pod = Serverpod(
    args,
    authenticationHandler: auth.authenticationHandler,
  );

  // Add S3 storage
  pod.addCloudStorage(
    s3.S3CloudStorage(
      serverpod: pod,
      storageId: 's3',
      public: true,
      region: 'us-west-2',
      bucket: 'serverpod-test-storage',
    ),
  );

  // Callbacks for auth
  auth.AuthConfig.set(
    auth.AuthConfig(
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
    ),
  );

  // Add route to web server
  pod.webServer.addRoute(RootRoute(), '/');

  // Start the server
  await pod.start();
}
