@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:relic/src/relic_server_serve.dart' as relic_server;
import 'package:test/test.dart';

import 'ssl/ssl_certs.dart';
import 'util/test_util.dart';

void main() {
  tearDown(() async {
    var server = _server;
    if (server != null) {
      try {
        await server.close().timeout(Duration(seconds: 5));
      } catch (e) {
        await server.close(force: true);
      } finally {
        _server = null;
      }
    }
  });

  test('sync handler returns a value to the client', () async {
    await _scheduleServer(syncHandler);

    var response = await _get();
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /');
  });

  test('async handler returns a value to the client', () async {
    await _scheduleServer(asyncHandler);

    var response = await _get();
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /');
  });

  test('thrown error leads to a 500', () async {
    await _scheduleServer((request) {
      throw UnsupportedError('test');
    });

    var response = await _get();
    expect(response.statusCode, HttpStatus.internalServerError);
    expect(response.body, 'Internal Server Error');
  });

  test('async error leads to a 500', () async {
    await _scheduleServer((request) {
      return Future.error('test');
    });

    var response = await _get();
    expect(response.statusCode, HttpStatus.internalServerError);
    expect(response.body, 'Internal Server Error');
  });

  test('Request is populated correctly', () async {
    late Uri uri;

    await _scheduleServer((request) {
      expect(request.method, RequestMethod.get);

      expect(request.requestedUri, uri);

      expect(request.url.path, 'foo/bar');
      expect(request.url.pathSegments, ['foo', 'bar']);
      expect(request.protocolVersion, '1.1');
      expect(request.url.query, 'qs=value');
      expect(request.handlerPath, '/');

      return syncHandler(request);
    });

    uri = Uri.http('localhost:$_serverPort', '/foo/bar', {'qs': 'value'});
    var response = await http.get(uri);

    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /foo/bar');
  });

  test('Request can handle colon in first path segment', () async {
    await _scheduleServer(syncHandler);

    var response = await _get(path: 'user:42');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /user:42');
  });

  test('chunked requests are un-chunked', () async {
    await _scheduleServer(
      expectAsync1((request) async {
        expect(request.body.contentLength, isNull);
        expect(request.method, RequestMethod.post);
        expect(
          request.headers,
          isNot(contains(HttpHeaders.transferEncodingHeader)),
        );

        var stream = request.read();
        var body = await stream.toList();
        expect(
          body.first,
          equals(Uint8List.fromList([1, 2, 3, 4])),
        );

        return Response.ok();
      }),
    );

    var request = http.StreamedRequest(
      RequestMethod.post.value,
      Uri.http('localhost:$_serverPort', '/'),
    );
    request.sink.add([1, 2, 3, 4]);
    request.sink.close();

    var response = await request.send();
    expect(response.statusCode, HttpStatus.ok);
  });

  test('custom response headers are received by the client', () async {
    await _scheduleServer((request) {
      return Response.ok(
        body: Body.fromString('Hello from /'),
        headers: Headers.response(
            custom: CustomHeaders({
          'test-header': ['test-value'],
          'test-list': ['a', 'b', 'c'],
        })),
      );
    });

    var response = await _get();
    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers['test-header'], 'test-value');
    expect(response.body, 'Hello from /');
  });

  test('multiple headers are received from the client', () async {
    await _scheduleServer((Request request) {
      return Response.ok(
        body: Body.fromString('Hello from /'),
        headers: Headers.response(
            custom: CustomHeaders({
          'requested-values': request.headers.custom['request-values']!,
          'requested-values-length': [
            request.headers.custom['request-values']!.length.toString()
          ],
        })),
      );
    });

    final response = await _get(
      headers: {
        'request-values': 'a,b',
        'set-cookie': 'c,d',
      },
    );
    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers['requested-values'], 'a, b');
    expect(response.headers['requested-values-length'], '2');
  });

  test('custom status code is received by the client', () async {
    await _scheduleServer((request) {
      return Response(299, body: Body.fromString('Hello from /'));
    });

    var response = await _get();
    expect(response.statusCode, 299);
    expect(response.body, 'Hello from /');
  });

  test('custom request headers are received by the handler', () async {
    await _scheduleServer((request) {
      expect(
        request.headers.custom,
        containsPair('custom-header', ['client value']),
      );

      // dart:io HttpServer splits multi-value headers into an array
      // validate that they are combined correctly
      expect(
        request.headers.custom,
        containsPair('multi-header', ['foo', 'bar', 'baz']),
      );
      return syncHandler(request);
    });

    var headers = {
      'custom-header': 'client value',
      'multi-header': 'foo,bar,baz'
    };

    var response = await _get(headers: headers);
    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /');
  });

  test('post with empty content', () async {
    await _scheduleServer((request) async {
      expect(request.mimeType, isNull);
      expect(request.encoding, isNull);
      expect(request.method, RequestMethod.post);
      expect(request.body.contentLength, isNull);

      var body = await request.readAsString();
      expect(body, '');
      return syncHandler(request);
    });

    var response = await _post();
    expect(response.statusCode, HttpStatus.ok);
    expect(response.stream.bytesToString(), completion('Hello from /'));
  });

  test('post with request content', () async {
    await _scheduleServer((request) async {
      expect(request.mimeType?.primaryType, 'text');
      expect(request.mimeType?.subType, 'plain');
      expect(request.encoding, utf8);
      expect(request.method, RequestMethod.post);
      expect(request.body.contentLength, 9);

      var body = await request.readAsString();
      expect(body, 'test body');
      return syncHandler(request);
    });

    var response = await _post(body: 'test body');
    expect(response.statusCode, HttpStatus.ok);
    expect(response.stream.bytesToString(), completion('Hello from /'));
  });

  test('supports request hijacking', () async {
    await _scheduleServer((request) {
      expect(request.method, RequestMethod.post);

      request.hijack(expectAsync1((channel) {
        expect(channel.stream.first, completion(equals('Hello'.codeUnits)));

        channel.sink.add('HTTP/1.1 404 Not Found\r\n'
                'date: Mon, 23 May 2005 22:38:34 GMT\r\n'
                'Content-Length: 13\r\n'
                '\r\n'
                'Hello, world!'
            .codeUnits);
        channel.sink.close();
      }));
    });

    var response = await _post(body: 'Hello');
    expect(response.statusCode, HttpStatus.notFound);
    expect(response.headers['date'], 'Mon, 23 May 2005 22:38:34 GMT');
    expect(
        response.stream.bytesToString(), completion(equals('Hello, world!')));
  });

  test('reports an error if a HijackException is thrown without hijacking',
      () async {
    await _scheduleServer((request) => throw const HijackException());

    var response = await _get();
    expect(response.statusCode, HttpStatus.internalServerError);
  });

  test('passes asynchronous exceptions to the parent error zone', () async {
    await runZonedGuarded(() async {
      var server = await relic_server.serve((request) {
        Future(() => throw StateError('oh no'));
        return syncHandler(request);
      }, 'localhost', 0);

      var response = await http.get(Uri.http('localhost:${server.port}', '/'));
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body, 'Hello from /');
      await server.close();
    }, expectAsync2((error, stack) {
      expect(error, isOhNoStateError);
    }));
  });

  test("doesn't pass asynchronous exceptions to the root error zone", () async {
    var response = await Zone.root.run(() async {
      var server = await relic_server.serve((request) {
        Future(() => throw StateError('oh no'));
        return syncHandler(request);
      }, 'localhost', 0);

      try {
        return await http.get(Uri.http('localhost:${server.port}', '/'));
      } finally {
        await server.close();
      }
    });

    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello from /');
  });

  test('a bad HTTP host request results in a 500 response', () async {
    await _scheduleServer(syncHandler);

    var socket = await Socket.connect('localhost', _serverPort);

    try {
      socket.write('GET / HTTP/1.1\r\n');
      socket.write('Host: ^^super bad !@#host\r\n');
      socket.write('\r\n');
    } finally {
      await socket.close();
    }

    expect(
        await utf8.decodeStream(socket), contains('500 Internal Server Error'));
  });

  test('a bad HTTP URL request results in a 400 response', () async {
    await _scheduleServer(syncHandler);
    final socket = await Socket.connect('localhost', _serverPort);

    try {
      socket.write('GET /#/ HTTP/1.1\r\n');
      socket.write('Host: localhost\r\n');
      socket.write('\r\n');
    } finally {
      await socket.close();
    }

    expect(await utf8.decodeStream(socket), contains('400 Bad Request'));
  });

  group('date header', () {
    test('is sent by default', () async {
      await _scheduleServer(syncHandler);

      // Update beforeRequest to be one second earlier. HTTP dates only have
      // second-level granularity and the request will likely take less than a
      // second.
      var beforeRequest = DateTime.now().subtract(const Duration(seconds: 1));

      var response = await _get();
      expect(response.headers, contains('date'));
      var responseDate = parser.parseHttpDate(response.headers['date']!);

      expect(responseDate.isAfter(beforeRequest), isTrue);
      expect(responseDate.isBefore(DateTime.now()), isTrue);
    });

    test('defers to header in response', () async {
      var date = DateTime.utc(1981, 6, 5);
      await _scheduleServer((request) {
        return Response.ok(
          body: Body.fromString('test'),
          headers: Headers.response(
            date: date,
          ),
        );
      });

      var response = await _get();
      expect(response.headers, contains('date'));
      var responseDate = parser.parseHttpDate(response.headers['date']!);
      expect(responseDate, date);
    });
  });

  group('X-Powered-By header', () {
    const poweredBy = 'x-powered-by';
    test('defaults to "Relic"', () async {
      await _scheduleServer(syncHandler);

      var response = await _get();
      expect(
        response.headers[poweredBy],
        equals('Relic'),
      );
    });

    test('defers to header in response when default', () async {
      await _scheduleServer((request) {
        return Response.ok(
          body: Body.fromString('test'),
          headers: Headers.response(
            xPoweredBy: 'myServer',
          ),
        );
      });

      var response = await _get();
      expect(response.headers, containsPair(poweredBy, 'myServer'));
    });

    test('can be set at the server level', () async {
      _server = await relic_server.serve(
        syncHandler,
        'localhost',
        0,
        poweredByHeader: 'ourServer',
      );
      var response = await _get();
      expect(
        response.headers,
        containsPair(poweredBy, 'ourServer'),
      );
    });

    test('defers to header in response when set at the server level', () async {
      _server = await relic_server.serve(
        (request) {
          return Response.ok(
            body: Body.fromString('test'),
            headers: Headers.response(
              xPoweredBy: 'myServer',
            ),
          );
        },
        'localhost',
        0,
        poweredByHeader: 'ourServer',
      );

      var response = await _get();
      expect(response.headers, containsPair(poweredBy, 'myServer'));
    });
  });

  group('chunked coding', () {
    group('is added when the transfer-encoding header is', () {
      test('unset', () async {
        await _scheduleServer((request) {
          return Response.ok(
            body: Body.fromDataStream(
                Stream.value(Uint8List.fromList([1, 2, 3, 4]))),
          );
        });

        var response = await _get();
        expect(response.headers,
            containsPair(HttpHeaders.transferEncodingHeader, 'chunked'));
        expect(response.bodyBytes, equals([1, 2, 3, 4]));
      });

      test('"identity"', () async {
        await _scheduleServer((request) {
          return Response.ok(
            body: Body.fromDataStream(
              Stream.value(Uint8List.fromList([1, 2, 3, 4])),
            ),
            headers: Headers.response(
              transferEncoding: TransferEncodingHeader(
                encodings: [TransferEncoding.identity],
              ),
            ),
          );
        });

        var response = await _get();
        expect(response.headers,
            containsPair(HttpHeaders.transferEncodingHeader, 'chunked'));
        expect(response.bodyBytes, equals([1, 2, 3, 4]));
      });
    });

    test('is preserved when the transfer-encoding header is "chunked"',
        () async {
      await _scheduleServer((request) {
        return Response.ok(
          body: Body.fromDataStream(
            Stream.fromIterable(
              [
                Uint8List.fromList('2\r\nhi\r\n0\r\n\r\n'.codeUnits),
              ],
            ),
          ),
          headers: Headers.response(
            transferEncoding: TransferEncodingHeader(
              encodings: [TransferEncoding.chunked],
            ),
          ),
        );
      });

      var response = await _get();
      expect(
        response.headers,
        containsPair(HttpHeaders.transferEncodingHeader, 'chunked'),
      );
      expect(response.body, equals('hi'));
    });

    group('is not added when', () {
      test('content-length is set', () async {
        await _scheduleServer((request) {
          return Response.ok(
            body: Body.fromDataStream(
              Stream.value(Uint8List.fromList([1, 2, 3, 4])),
            ),
          );
        });

        var response = await _get();
        expect(response.bodyBytes, equals([1, 2, 3, 4]));
      });

      test('status code is 1xx', () async {
        await _scheduleServer((request) {
          return Response(123, body: Body.fromDataStream(Stream.empty()));
        });

        var response = await _get();
        expect(response.headers,
            isNot(contains(HttpHeaders.transferEncodingHeader)));
        expect(response.body, isEmpty);
      });

      test('status code is 204', () async {
        await _scheduleServer((request) {
          return Response(204, body: Body.fromDataStream(Stream.empty()));
        });

        var response = await _get();
        expect(response.headers,
            isNot(contains(HttpHeaders.transferEncodingHeader)));
        expect(response.body, isEmpty);
      });

      test('status code is 304', () async {
        await _scheduleServer((request) {
          return Response(304, body: Body.fromDataStream(Stream.empty()));
        });

        var response = await _get();
        expect(response.headers,
            isNot(contains(HttpHeaders.transferEncodingHeader)));
        expect(response.body, isEmpty);
      });
    });
  });

  test('respects the "relic_server.buffer_output" context parameter', () async {
    var controller = StreamController<String>();
    await _scheduleServer((request) {
      controller.add('Hello, ');

      return Response.ok(
        body: Body.fromDataStream(
          utf8.encoder
              .bind(controller.stream)
              .map((list) => Uint8List.fromList(list)),
        ),
        context: {'relic_server.buffer_output': false},
      );
    });

    var request = http.Request(
        RequestMethod.get.value, Uri.http('localhost:$_serverPort', ''));

    var response = await request.send();
    var stream = StreamQueue(utf8.decoder.bind(response.stream));

    var data = await stream.next;
    expect(data, equals('Hello, '));
    controller.add('world!');

    data = await stream.next;
    expect(data, equals('world!'));
    await controller.close();
    expect(stream.hasNext, completion(isFalse));
  });

  test('includes the dart:io HttpConnectionInfo in request', () async {
    await _scheduleServer((request) {
      expect(request.connectionInfo, isNotNull);

      var connectionInfo = request.connectionInfo!;
      expect(connectionInfo.remoteAddress, equals(_server!.address));
      expect(connectionInfo.localPort, equals(_server!.port));

      return syncHandler(request);
    });

    var response = await _get();
    expect(response.statusCode, HttpStatus.ok);
  });

  group('ssl tests', () {
    var securityContext = SecurityContext()
      ..setTrustedCertificatesBytes(certChainBytes)
      ..useCertificateChainBytes(certChainBytes)
      ..usePrivateKeyBytes(certKeyBytes, password: 'dartdart');

    var sslClient = HttpClient(context: securityContext);

    Future<HttpClientRequest> scheduleSecureGet() =>
        sslClient.getUrl(Uri.https('localhost:${_server!.port}', ''));

    test('secure sync handler returns a value to the client', () async {
      await _scheduleServer(syncHandler, securityContext: securityContext);

      var req = await scheduleSecureGet();

      var response = await req.close();
      expect(response.statusCode, HttpStatus.ok);
      expect(await response.cast<List<int>>().transform(utf8.decoder).single,
          'Hello from /');
    });

    test('secure async handler returns a value to the client', () async {
      await _scheduleServer(asyncHandler, securityContext: securityContext);

      var req = await scheduleSecureGet();
      var response = await req.close();
      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.cast<List<int>>().transform(utf8.decoder).single,
        'Hello from /',
      );
    });
  });
}

int get _serverPort => _server!.port;

HttpServer? _server;

Future<void> _scheduleServer(
  Handler handler, {
  SecurityContext? securityContext,
}) async {
  assert(_server == null);
  _server = await relic_server.serve(
    handler,
    'localhost',
    0,
    securityContext: securityContext,
  );
}

Future<http.Response> _get({
  Map<String, String>? headers,
  String path = '',
}) async {
  var request = http.Request(
    RequestMethod.get.value,
    Uri.http('localhost:$_serverPort', path),
  );

  if (headers != null) request.headers.addAll(headers);

  var response = await request.send();
  return await http.Response.fromStream(response);
}

Future<http.StreamedResponse> _post({
  Map<String, String>? headers,
  String? body,
}) {
  var request = http.Request(
    RequestMethod.post.value,
    Uri.http('localhost:$_serverPort', ''),
  );

  if (headers != null) request.headers.addAll(headers);
  if (body != null) request.body = body;

  return request.send();
}
