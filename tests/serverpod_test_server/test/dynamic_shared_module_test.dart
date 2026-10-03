import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as shared_module;
import 'package:test/test.dart';

void main() {
  group(
    'Given a recognized shared module model with malformed dynamic field data,',
    () {
      final protocol = shared_module.Protocol();
      final payload = {
        'className': 'SharedModuleTable',
        'data': {
          'name': 'test',
          'data': 'not-a-dynamic-field-payload',
        },
      };

      test(
        'when deserializing through the module protocol, '
        'then a FormatException is thrown.',
        () {
          expect(
            () => protocol.deserializeByClassName(payload),
            throwsA(
              isA<FormatException>().having(
                (exception) => exception.message,
                'message',
                'Dynamic fields are encoded as a Map with className and data, '
                    'but got String instead.',
              ),
            ),
          );
        },
      );
    },
  );
}
