import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;
import 'package:serverpod_cloud_storage_s3/serverpod_cloud_storage_s3.dart'
    as s3;
import 'package:serverpod_test_server/src/web/routes/root.dart';

import 'src/futureCalls/test_call.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

void run(List<String> args) async {
  // Create serverpod
  var pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Add future calls
  pod.registerFutureCall(TestCall(), 'testCall');

  // Add S3 storage
  pod.addCloudStorage(s3.S3CloudStorage(
      serverpod: pod,
      storageId: 's3',
      public: true,
      region: '',
      bucket: 'serverpod-test-storage',
      publicHost: 'localhost:9000'));

  // Callbacks for auth
  auth.AuthConfig.set(auth.AuthConfig(
    onUserWillBeCreated: (session, userInfo, authMethod) async {
      return (userInfo.email!.endsWith('.bar'));
    },
  ));

  // Add route to web server
  pod.webServer.addRoute(RouteRoot(), '/');

  // Start the server
  await pod.start();
}
