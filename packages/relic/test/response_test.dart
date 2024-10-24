import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:relic/relic.dart' hide Request;
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  group('supports a String body', () {
    test('readAsString', () {
      var response = Response.ok(body: Body.fromString('hello, world'));
      expect(response.readAsString(), completion(equals('hello, world')));
    });

    test('read', () {
      var helloWorldBytes = [...helloBytes, ...worldBytes];

      var response = Response.ok(body: Body.fromString('hello, world'));
      expect(response.read().toList(), completion(equals([helloWorldBytes])));
    });
  });

  test('supports a Uint8List body without copying', () async {
    var bytes = Uint8List(10);
    var response = Response.ok(body: Body.fromData(bytes));

    expect(response.body.contentLength, 10);
    expect(await response.read().single, same(bytes));
  });

  test('supports a Stream<Uint8List> body without copying', () async {
    var bytes = Stream.value(Uint8List.fromList([1, 2, 3, 4]));
    var response = Response.ok(body: Body.fromDataStream(bytes));

    expect(response.read(), same(bytes));
  });

  group('new Response.internalServerError without a body', () {
    test('sets the body to "Internal Server Error"', () {
      var response = Response.internalServerError();
      expect(
          response.readAsString(), completion(equals('Internal Server Error')));
    });

    test('sets the content-type header to text/plain', () {
      var response = Response.internalServerError();
      expect(response.body.contentType.toString(),
          equals('text/plain; charset=utf-8'));
      expect(response.body.contentLength, equals(21));
    });
  });

  group('Response.badRequest:', () {
    test('no supplied body results in "Bad Request"', () {
      var response = Response.badRequest();
      expect(response.readAsString(), completion(equals('Bad Request')));
    });

    test('sets body', () {
      var response = Response.badRequest(
        body: Body.fromString('missing token'),
      );
      expect(response.readAsString(), completion(equals('missing token')));
    });
  });

  group('Response.unauthorized:', () {
    test('sets body', () {
      var response = Response.unauthorized(
        body: Body.fromString('request unauthorized'),
      );
      expect(
          response.readAsString(), completion(equals('request unauthorized')));
      expect(response.statusCode, 401);
    });
  });

  group('Response redirect', () {
    test('sets the location header for a String', () {
      var response = Response.found(Uri.parse('/foo'));
      expect(
        response.headers.location.toString(),
        equals('/foo'),
      );
    });

    test('sets the location header for a Uri', () {
      var response = Response.found(Uri(path: '/foo'));
      expect(
        response.headers.location.toString(),
        equals('/foo'),
      );
    });
  });

  group('expires', () {
    test('is null without an Expires header', () {
      expect(
          Response.ok(body: Body.fromString('okay!')).headers.expires, isNull);
    });

    test('comes from the Expires header', () {
      expect(
          Response.ok(
            body: Body.fromString('okay!'),
            headers: Headers.response(
              expires: parseHttpDate('Sun, 06 Nov 1994 08:49:37 GMT'),
            ),
          ).headers.expires,
          equals(DateTime.parse('1994-11-06 08:49:37z')));
    });
  });

  group('lastModified', () {
    test('is null without a Last-Modified header', () {
      expect(Response.ok(body: Body.fromString('okay!')).headers.lastModified,
          isNull);
    });

    test('comes from the Last-Modified header', () {
      expect(
          Response.ok(
              body: Body.fromString('okay!'),
              headers: Headers.response(
                lastModified: parseHttpDate('Sun, 06 Nov 1994 08:49:37 GMT'),
              )).headers.lastModified,
          equals(DateTime.parse('1994-11-06 08:49:37z')));
    });
  });

  group('change', () {
    test('with no arguments returns instance with equal values', () {
      var controller = StreamController<Object>();

      var request = Response(
        345,
        body: Body.fromString('hèllo, world'),
        encoding: latin1,
        headers: Headers.response(
          custom: CustomHeaders({
            'header1': ['header value 1']
          }),
        ),
        context: {'context1': 'context value 1'},
      );

      var copy = request.copyWith();

      expect(copy.statusCode, request.statusCode);
      expect(copy.readAsString(), completion('hèllo, world'));
      expect(copy.headers, same(request.headers));
      expect(copy.encoding, request.encoding);
      expect(copy.context, same(request.context));

      controller.add(helloBytes);
      return Future(() {
        controller
          ..add(worldBytes)
          ..close();
      });
    });

    test('allows the original response to be read', () {
      var response = Response.ok(body: null);
      var changed = response.copyWith();

      expect(response.read().toList(), completion(isEmpty));
      expect(changed.read, throwsStateError);
    });

    test('allows the changed response to be read', () {
      var response = Response.ok(body: null);
      var changed = response.copyWith();

      expect(changed.read().toList(), completion(isEmpty));
      expect(response.read, throwsStateError);
    });

    test('allows another changed response to be read', () {
      var response = Response.ok(body: null);
      var changed1 = response.copyWith();
      var changed2 = response.copyWith();

      expect(changed2.read().toList(), completion(isEmpty));
      expect(changed1.read, throwsStateError);
      expect(response.read, throwsStateError);
    });
  });
}
