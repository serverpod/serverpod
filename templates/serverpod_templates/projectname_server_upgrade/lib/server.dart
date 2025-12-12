import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'package:projectname_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/future_calls.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints(), futureCalls);

  // Setup a default page at the web root.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');
  // Serve all files in the web/static relative directory under /.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root), '/**');

  // Start the server.
  await pod.start();

  // You can schedule future calls for a later time during startup. But you can
  // also schedule them in any endpoint or webroute using the global [futureCalls].
  // There is also [futureCalls.callAtTime] if you want to schedule a future call at a
  // specific time.
  await futureCalls
      .callWithDelay(Duration(seconds: 5))
      .birthdayReminder
      .invoke(
        Greeting(
          message: 'Hello!',
          author: 'Serverpod Server',
          timestamp: DateTime.now(),
        ),
      );
}
