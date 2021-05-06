import 'package:serverpod/serverpod.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Create serverpod
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Add any future calls
  // pod.registerFutureCall(MyFutureCall(), 'myFutureCall');

  // Start the server
  await pod.start();
}