import 'package:serverpod/serverpod.dart';
import 'package:serverpod_relic/serverpod_relic.dart';

import 'package:projectname_server/src/web/routes/root.dart';

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
  );

  // If you are using any future calls, they need to be registered here.
  // pod.registerFutureCall(ExampleFutureCall(), 'exampleFutureCall');

  // Start the server.
  await pod.start();

  // Setup the Relic web server. If you prefer to not use the Serverpod web
  // server, you can safely remove this section.
  final webServer = WebServer(serverpod: pod);

  // Setup a default page at the web root.
  webServer.addRoute(
    RouteRoot(),
    '/',
  );
  // Serve anything under the /static directory statically.
  webServer.addRoute(
    RouteStaticDirectory(serverDirectory: 'static'),
    '/static/*',
  );

  await webServer.start();
}
