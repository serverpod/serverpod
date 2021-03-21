import 'package:serverpod/serverpod.dart';
import 'src/generated/protocol.dart';
import 'src/endpoints/simple.dart';
import 'src/endpoints/types_basic.dart';

void run(List<String> args) async {
  // Create serverpod
  final pod = Serverpod(
    args,
    Protocol(),
  );

  // Create endpoints
  pod.addEndpoint(SimpleEndpoint(), 'simple');
  pod.addEndpoint(BasicTypesEndpoint(), 'basicTypes');

  await pod.start();
}