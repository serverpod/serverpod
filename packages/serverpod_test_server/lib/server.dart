import 'package:serverpod/serverpod.dart';
import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';
import 'src/endpoints/simple.dart';
import 'src/endpoints/basic_types.dart';

void run(List<String> args) async {
  // Create serverpod
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );
//
//  // Create endpoints
//  pod.addEndpoint(SimpleEndpoint(), 'simple');
//  pod.addEndpoint(BasicTypesEndpoint(), 'basicTypes');

  await pod.start();
}