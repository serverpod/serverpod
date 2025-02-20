import 'dart:io';
import 'package:serverpod/serverpod.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.

  // You can set the serverId using either:
  // 1. A command-line flag: --server-id=<value>
  // 2. The 'SERVERPOD_SERVER_ID' environment variable
  //
  // If both are set, the command-line flag takes precedence.
  // If neither is set, the default value 'default' will be used.
  final serverId = Platform.environment['SERVERPOD_SERVER_ID'] ?? 'default';
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    serverId: serverId,
  );

  // Start the server.
  await pod.start();
}
