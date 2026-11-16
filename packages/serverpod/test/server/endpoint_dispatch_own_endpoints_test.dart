import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  late Serverpod pod;

  setUp(() {
    pod = Serverpod(
      [],
      internal.Protocol(),
      EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        ),
      ),
    );
  });

  tearDown(() async {
    await pod.shutdown(exitProcess: false);
  });

  test(
    'Given endpoints generated before initializeOwnEndpoints existed, '
    'when initializing their own endpoints, '
    'then the endpoints of initializeEndpoints are connected.',
    () {
      final endpoints = _EarlierGeneratedEndpoints();

      endpoints.initializeOwnEndpoints(pod.server);

      expect(endpoints.connectors.keys, ['example']);
    },
  );
}

class _ExampleEndpoint extends Endpoint {}

/// Only overrides [initializeEndpoints], like the endpoints generated before
/// [EndpointDispatch.initializeOwnEndpoints] existed.
class _EarlierGeneratedEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    connectors['example'] = EndpointConnector(
      name: 'example',
      endpoint: _ExampleEndpoint()..initialize(server, 'example', null),
      methodConnectors: {},
    );
  }
}
