import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/relic.dart';
import 'package:relic/src/message/message.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

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
  group('Given message headers', () {
    test('when accessed then they are case insensitive', () {
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

    test('when modified then they are immutable', () {
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

    test('when containing multiple values then they are handled correctly', () {
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

  group('Given readAsString', () {
    test('when the body is null then it returns an empty string', () {
      var request = _createMessage();
      expect(request.readAsString(), completion(equals('')));
    });

    test('when the body is a Stream<Uint8List> then it reads correctly', () {
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

    test('when no encoding is specified then it defaults to UTF-8', () {
      var request = _createMessage(
        body: Body.fromData(Uint8List.fromList([195, 168])),
      );
      expect(request.readAsString(), completion(equals('è')));
    });
  });

  group('Given read', () {
    test('when the body is null then it returns an empty list', () {
      var request = _createMessage();
      expect(request.read().toList(), completion(isEmpty));
    });

    test('when the body is a Stream<Uint8List> then it reads correctly', () {
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

    test('when the body is a List<int> then it reads correctly', () {
      var request = _createMessage(body: Body.fromData(helloBytes));
      expect(request.read().toList(), completion(equals([helloBytes])));
    });

    test(
        'when read()/readAsString() is called multiple times then it throws a StateError',
        () {
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

  group('Given content-length', () {
    test(
        'when the body is default and no content-length header is present then it is 0',
        () {
      var request = _createMessage();
      expect(request.body.contentLength, 0);
    });

    test('when the body is a byte body then it is set correctly', () {
      var request = _createMessage(
        body: Body.fromData(Uint8List.fromList([1, 2, 3])),
      );
      expect(request.body.contentLength, 3);
    });

    test('when the body is a string then it is set correctly', () {
      var request = _createMessage(body: Body.fromString('foobar'));
      expect(request.body.contentLength, 6);
    });

    test('when the body is a string then it is set based on byte length', () {
      var request = _createMessage(body: Body.fromString('fööbär'));
      expect(request.body.contentLength, 9);

      request = _createMessage(
        body: Body.fromString('fööbär', encoding: latin1),
      );
      expect(request.body.contentLength, 6);
    });

    test('when the body is a stream then it is null', () {
      var request = _createMessage(
        body: Body.fromDataStream(Stream.empty()),
      );
      expect(request.body.contentLength, isNull);
    });

    test('when identity transfer encoding is set then it is set correctly', () {
      var request = _createMessage(
        body: Body.fromString('1\r\na0\r\n\r\n'),
        headers: Headers.request(
          transferEncoding: TransferEncodingHeader(
            encodings: [TransferEncoding.identity],
          ),
        ),
      );
      expect(request.body.contentLength, equals(9));
    });
  });

  group('Given encoding', () {
    test('when no content-type header is present then it defaults to utf8', () {
      expect(_createMessage().encoding, utf8);
    });

    test('when encoding a String then it defaults to UTF-8', () {
      expect(
        _createMessage(
          body: Body.fromString('è'),
        ).read().toList(),
        completion(equals([
          [195, 168]
        ])),
      );
    });

    test('when an explicit encoding is available then it uses it', () {
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
