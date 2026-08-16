import 'dart:async';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as module;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given a module', () {
    test('when calling a non-module endpoint that uses a module object '
        'then should return true to indicate nothing went wrong', () async {
      var success = await client.moduleSerialization.serializeModuleObject();
      expect(success, equals(true));
    });

    test('when calling endpoint method hello'
        'then returns greeting', () async {
      var result = await client.modules.module.module.hello('World');
      expect(result, equals('Hello World'));
    });

    test('when calling a non-module endpoint that modifies a module object '
        'then should return modified object', () async {
      var moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      var result = await client.moduleSerialization.modifyModuleObject(
        moduleClass,
      );
      expect(result.data, equals(42));
    });

    test('when calling endpoint method that modifies object '
        'then returns modified object', () async {
      var moduleClass = module.ModuleClass(
        name: 'foo',
        data: 0,
      );
      var result = await client.modules.module.module.modifyModuleObject(
        moduleClass,
      );
      expect(result.data, equals(42));
    });

    test(
      'when calling stream-returning method that takes stream as a parameter '
      'then should return a stream',
      () async {
        var streamComplete = Completer();
        var numberGenerator = List.generate(10, (index) => index++);
        var inputStream = Stream<int>.fromIterable(numberGenerator);
        var stream = client.modules.module.streaming.intEchoStream(inputStream);

        var received = <int>[];
        stream.listen(
          (event) {
            received.add(event);
          },
          onDone: () {
            streamComplete.complete();
          },
          cancelOnError: true,
        );

        await streamComplete.future;
        expect(received, numberGenerator);
      },
    );

    test(
      'when calling future-returning method that takes stream as a parameter '
      'then should return a future value',
      () async {
        var inputStream = Stream<int>.fromIterable([1]);
        var value = await client.modules.module.streaming
            .simpleInputReturnStream(inputStream);

        expect(value, 1);
      },
    );
  });

  group('Nested modules classes.', () {
    test(
      'Given a generated protocol class with a custom class, then serialize the internal data.',
      () async {
        var result = await client.moduleSerialization
            .serializeNestedModuleObject();
        expect(result.model.data, equals(42));
        expect(result.list[0].data, equals(42));
        expect(result.map['foo']?.data, equals(42));
      },
    );
  });
}
