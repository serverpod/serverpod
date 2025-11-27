import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group(
    'Given an endpoint which extends the base class without any overrides, ',
    () {
      test(
        'when calling `echoString`, then the input value is returned verbatim.',
        () async {
          var response = await client.moduleEndpointSubclass.echoString(
            'hello',
          );

          expect(response, 'hello');
        },
      );

      test(
        'when calling `echoRecord`, then the input value is returned verbatim.',
        () async {
          var response = await client.moduleEndpointSubclass.echoRecord((
            5,
            BigInt.from(100),
          ));

          expect(response, (5, BigInt.from(100)));
        },
      );

      test(
        'when calling `echoContainer`, then the input value is returned verbatim.',
        () async {
          var response = await client.moduleEndpointSubclass.echoContainer({
            1,
            2,
            3,
          });

          expect(response, {1, 2, 3});
        },
      );

      test(
        'when calling `echoModel`, then the input value is returned verbatim.',
        () async {
          var response = await client.moduleEndpointSubclass.echoModel(
            ModuleClass(name: 'test', data: 1),
          );

          expect(
            response,
            isA<ModuleClass>()
                .having((c) => c.name, 'name', 'test')
                .having((c) => c.data, 'data', 1),
          );
        },
      );

      test(
        'when trying to call `ignoredMethod`, then this fails because the method is ignored in the base class and not generated.',
        () async {
          expect(
            () => (client.moduleEndpointSubclass as dynamic).ignoredMethod(),
            throwsA(isA<NoSuchMethodError>()),
          );
        },
      );
    },
  );

  group('Given an endpoint which overrides a few methods of the base class, ', () {
    test(
      'when calling `echoString`, then the input value is returned verbatim (re-using the `super` implementation).',
      () async {
        var response = await client.moduleEndpointAdaptation.echoString(
          'hello',
        );

        expect(response, 're-exposed: hello');
      },
    );

    test(
      'when calling `echoRecord`, then the request supports the optional parameter and returns the modified value.',
      () async {
        var response = await client.moduleEndpointAdaptation.echoRecord(
          (5, BigInt.from(100)),
          2,
        );

        expect(response, (10, BigInt.from(200)));
      },
    );

    test(
      'when calling `echoContainer`, then the input value is returned verbatim (re-using the `super` implementation).',
      () async {
        var response = await client.moduleEndpointAdaptation.echoContainer({
          1,
          2,
          3,
        });

        expect(response, {1, 2, 3});
      },
    );

    test(
      'when calling `echoModel`, then the input value is returned verbatim (re-using the `super` implementation).',
      () async {
        var response = await client.moduleEndpointAdaptation.echoModel(
          ModuleClass(name: 'test', data: 1),
        );

        expect(
          response,
          isA<ModuleClass>()
              .having((c) => c.name, 'name', 'test')
              .having((c) => c.data, 'data', 1),
        );
      },
    );
  });

  group('Given an endpoint which a further method of the base class, ', () {
    test(
      'when calling the ignored `echoString`, then this fails because the method is ignored in the sub-class and not generated.',
      () async {
        expect(
          () => (client.moduleEndpointReduction as dynamic).echoString('hello'),
          throwsA(isA<NoSuchMethodError>()),
        );
      },
    );
  });

  group(
    'Given an endpoint which extends the subclass with a new method and unhides an existing one, ',
    () {
      test(
        'when calling `greet`, then the input is returned as expected.',
        () async {
          var response = await client.moduleEndpointExtension.greet(
            'Serverpod',
          );

          expect(response, 'Hello Serverpod');
        },
      );

      test(
        'when calling the unhidden `ignoredMethod`, then the client exists and the call succeeds.',
        () async {
          await client.moduleEndpointExtension.ignoredMethod();
        },
      );
    },
  );
}
