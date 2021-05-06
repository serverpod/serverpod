import 'package:serverpod/serverpod.dart';
import 'package:serverpod_relic/serverpod_relic.dart';
import 'package:serverpod_test_server/src/web/routes/root.dart';
import 'src/futureCalls/test_call.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  // Create serverpod
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Add future calls
  pod.registerFutureCall(TestCall(), 'testCall');

  // Start the server
  await pod.start();

  // Add relic / webserver
  final webserver = WebServer(serverpod: pod);
  webserver.addRoute(RouteRoot(), '/');
  webserver.start();
}