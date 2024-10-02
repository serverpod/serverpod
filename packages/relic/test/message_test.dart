import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/relic.dart';
import 'package:relic/src/headers.dart';
import 'package:relic/src/message.dart';
import 'package:test/test.dart';

import 'test_util.dart';

class _TestMessage extends Message {
  _TestMessage(
    Headers? headers,
    Map<String, Object>? context, {
    Body? body,
  }) : super(
          headers: headers ?? Headers.request(),
          body: body ?? Body.empty(),
          context: context ?? {},
        );

  @override
  Message copyWith({
    Headers? headers,
    Map<String, Object>? context,
    Body? body,
  }) {
    throw UnimplementedError();
  }
}

Message _createMessage({
  Headers? headers,
  Map<String, Object>? context,
  Body? body,
}) {
  return _TestMessage(headers, context, body: body);
}

void main() {
  group('headers', () {
    test('message headers are case insensitive', () {
      var message = _createMessage(
        headers: Headers.request(
          custom: CustomHeaders({
            'foo': ['bar']
          }),
        ),
      );

      expect(message.headers.custom, containsPair('foo', ['bar']));
      expect(message.headers.custom, containsPair('Foo', ['bar']));
      expect(message.headers.custom, containsPair('FOO', ['bar']));
    });

    test('headers are immutable', () {
      var message = _createMessage(
        headers: Headers.request(
          custom: CustomHeaders({
            'h1': ['value1']
          }),
        ),
      );
      expect(
        () => message.headers.custom['h1'] = ['value1'],
        throwsUnsupportedError,
      );
      expect(
        () => message.headers.custom['h1'] = ['value2'],
        throwsUnsupportedError,
      );
      expect(
        () => message.headers.custom['h2'] = ['value2'],
        throwsUnsupportedError,
      );
    });

    test('headers with multiple values', () {
      final message = _createMessage(
        headers: Headers.request(
          custom: CustomHeaders({
            'a': ['A'],
            'b': ['B1', 'B2'],
          }),
        ),
      );

      expect(message.headers.custom, {
        'a': ['A'],
        'b': ['B1', 'B2'],
      });
    });
  });

  group('readAsString', () {
    test('supports a null body', () {
      var request = _createMessage();
      expect(request.readAsString(), completion(equals('')));
    });

    test('supports a Stream<List<int>> body', () {
      var controller = StreamController<Uint8List>();
      var request =
          _createMessage(body: Body.fromDataStream(controller.stream));
      expect(request.readAsString(), completion(equals('hello, world')));

      controller.add(helloBytes);
      return Future(() {
        controller
          ..add(worldBytes)
          ..close();
      });
    });

    test('defaults to UTF-8', () {
      var request = _createMessage(
        body: Body.fromData(Uint8List.fromList([195, 168])),
      );
      expect(request.readAsString(), completion(equals('è')));
    });
  });

  group('read', () {
    test('supports a null body', () {
      var request = _createMessage();
      expect(request.read().toList(), completion(isEmpty));
    });

    test('supports a Stream<List<int>> body', () {
      var controller = StreamController<Uint8List>();
      var request = _createMessage(
        body: Body.fromDataStream(controller.stream),
      );
      expect(request.read().toList(),
          completion(equals([helloBytes, worldBytes])));

      controller.add(helloBytes);
      return Future(() {
        controller
          ..add(worldBytes)
          ..close();
      });
    });

    test('supports a List<int> body', () {
      var request = _createMessage(body: Body.fromData(helloBytes));
      expect(request.read().toList(), completion(equals([helloBytes])));
    });

    test('throws when calling read()/readAsString() multiple times', () {
      Message request;

      request = _createMessage();
      expect(request.read().toList(), completion(isEmpty));
      expect(() => request.read(), throwsStateError);

      request = _createMessage();
      expect(request.readAsString(), completion(isEmpty));
      expect(() => request.readAsString(), throwsStateError);

      request = _createMessage();
      expect(request.readAsString(), completion(isEmpty));
      expect(() => request.read(), throwsStateError);

      request = _createMessage();
      expect(request.read().toList(), completion(isEmpty));
      expect(() => request.readAsString(), throwsStateError);
    });
  });

  group('content-length', () {
    test('is 0 with a default body and without a content-length header', () {
      var request = _createMessage();
      expect(request.body.contentLength, 0);
    });

    test('comes from a byte body', () {
      var request = _createMessage(
        body: Body.fromData(Uint8List.fromList([1, 2, 3])),
      );
      expect(request.body.contentLength, 3);
    });

    test('comes from a string body', () {
      var request = _createMessage(body: Body.fromString('foobar'));
      expect(request.body.contentLength, 6);
    });

    test('is set based on byte length for a string body', () {
      var request = _createMessage(body: Body.fromString('fööbär'));
      expect(request.body.contentLength, 9);

      request = _createMessage(
        body: Body.fromString('fööbär', encoding: latin1),
      );
      expect(request.body.contentLength, 6);
    });

    test('is null for a stream body', () {
      var request = _createMessage(
        body: Body.fromDataStream(Stream.empty()),
      );
      expect(request.body.contentLength, isNull);
    });

    test('is set for identity transfer encoding', () {
      var request = _createMessage(
        body: Body.fromString('1\r\na0\r\n\r\n'),
        headers: Headers.request(
          transferEncoding: TransferEncodingHeader(
            encodings: ['identity'],
          ),
        ),
      );
      expect(request.body.contentLength, equals(9));
    });
  });

  group('encoding', () {
    test('is utf8 without a content-type header', () {
      expect(_createMessage().encoding, utf8);
    });

    test('defaults to encoding a String as UTF-8', () {
      expect(
        _createMessage(
          body: Body.fromString('è'),
        ).read().toList(),
        completion(equals([
          [195, 168]
        ])),
      );
    });

    test('uses the explicit encoding if available', () {
      expect(
        _createMessage(
          body: Body.fromString('è', encoding: latin1),
        ).read().toList(),
        completion(equals([
          [232]
        ])),
      );
    });
  });
}
