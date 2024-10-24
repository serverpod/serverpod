import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:relic/relic.dart';
import 'package:relic/src/message.dart';
import 'package:relic/src/method/method.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  group('Request', () {
    _testChange(({
      body,
      Headers? headers,
      Map<String, Object>? context,
    }) {
      return Request(
        Method.get,
        localhostUri,
        body: body,
        headers: headers,
        context: context,
      );
    });
  });

  group('Response', () {
    _testChange(({
      body,
      Headers? headers,
      Map<String, Object>? context,
    }) {
      return Response.ok(
        body: body,
        headers: headers,
        context: context,
      );
    });
  });
}

/// Shared test method used by [Request] and [Response] tests to validate
/// the behavior of `change` with different `headers` and `context` values.
void _testChange(
  Message Function({
    Body? body,
    Headers headers,
    Map<String, Object> context,
  }) factory,
) {
  group('body', () {
    test('with String', () async {
      var request = factory(body: Body.fromString('Hello, world'));
      var copy = request.copyWith(body: Body.fromString('Goodbye, world'));

      var newBody = await copy.readAsString();

      expect(newBody, equals('Goodbye, world'));
    });

    test('with Stream', () async {
      var request = factory(body: Body.fromString('Hello, world'));
      var copy = request.copyWith(
        body: Body.fromDataStream(
          Stream.fromIterable(['Goodbye, world'])
              .transform(utf8.encoder)
              .map((list) => Uint8List.fromList(list)),
        ),
      );

      var newBody = await copy.readAsString();

      expect(newBody, equals('Goodbye, world'));
    });
  });

  test('with empty headers returns identical instance', () {
    var request = factory(
      headers: Headers.request(
        custom: CustomHeaders({
          'header1': ['header value 1']
        }),
      ),
    );
    var copy = request.copyWith(
      headers: Headers.request(),
    );

    expect(
      copy.headers.toMap(),
      equals(request.headers.toMap()),
    );
    expect(
      copy.headers.custom,
      equals(request.headers.custom),
    );
  });

  test('with empty context returns identical instance', () {
    var request = factory(context: {'context1': 'context value 1'});
    var copy = request.copyWith(context: {});

    expect(copy.context, same(request.context));
  });

  test('new header values are added', () {
    var request = factory(
      headers: Headers.request(
        custom: CustomHeaders({
          'test': ['test value']
        }),
      ),
    );
    var copy = request.copyWith(
      headers: request.headers.copyWith(
        custom: CustomHeaders({
          'test2': ['test2 value']
        }),
      ),
    );

    expect(copy.headers.toMap(), {
      'test': ['test value'],
      'test2': ['test2 value'],
    });
  });

  test('existing header values are overwritten', () {
    var request = factory(
      headers: Headers.request(
        custom: CustomHeaders({
          'test': ['test value']
        }),
      ),
    );
    var copy = request.copyWith(
      headers: request.headers.copyWith(
        custom: CustomHeaders({
          'test': ['new test value']
        }),
      ),
    );

    expect(copy.headers.toMap(), {
      'test': ['new test value'],
    });
  });

  test('new context values are added', () {
    var request = factory(context: {'test': 'test value'});
    var copy = request.copyWith(context: {'test2': 'test2 value'});

    expect(copy.context, {'test': 'test value', 'test2': 'test2 value'});
  });

  test('existing context values are overwritten', () {
    var request = factory(context: {'test': 'test value'});
    var copy = request.copyWith(context: {'test': 'new test value'});

    expect(copy.context, {'test': 'new test value'});
  });
}
