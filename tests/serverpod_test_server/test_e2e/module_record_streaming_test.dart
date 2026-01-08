import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  test(
    'Given a module streaming endpoint that returns a stream of records with nullable int and nullable class, '
    'when the stream is listened to, '
    'then the records are returned verbatim',
    () async {
      final values = [
        (1, ModuleStreamingClass(name: 'test')),
        (null, ModuleStreamingClass(name: 'test')),
        (3, null),
        (null, null),
      ];

      var result = client.modules.module.recordStreaming.streamModuleClass(
        Stream.fromIterable(values),
      );

      expect(
        result,
        emitsInOrder([
          isA<(int, ModuleStreamingClass)>(),
          isA<(int?, ModuleStreamingClass?)>().having(
            (e) => e.$1,
            'int',
            isNull,
          ),
          isA<(int, ModuleStreamingClass?)>().having(
            (e) => e.$2,
            'object',
            isNull,
          ),
          isA<(int?, ModuleStreamingClass?)>()
              .having((e) => e.$1, 'int', isNull)
              .having((e) => e.$2, 'object', isNull),
        ]),
      );
    },
  );
}
