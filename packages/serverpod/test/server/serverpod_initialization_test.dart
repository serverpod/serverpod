import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group(
    'Given the internal serverpod Protocol class',
    () {
      test(
        'when passed as serializationManager to Serverpod '
        'then throws ArgumentError with informative message.',
        () {
          expect(
            () => Serverpod(
              [],
              internal.Protocol(),
              _EmptyEndpoints(),
              config: ServerpodConfig(
                apiServer: portZeroConfig,
                webServer: portZeroConfig,
              ),
            ),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                '''
The "Serverpod" class was initialized with the internal "Protocol" class
from "package:serverpod/protocol.dart", which is not allowed. Please import the "Protocol"
class generated for your project from "src/generated/protocol.dart".
''',
              ),
            ),
          );
        },
      );
    },
  );
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
