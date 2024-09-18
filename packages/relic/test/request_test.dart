import 'dart:async';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import 'test_util.dart';

Request _request({
  Headers? headers,
  Body? body,
}) {
  return Request(
    'GET',
    localhostUri,
    headers: headers,
    body: body,
  );
}

void main() {
  group('constructor', () {
    test('protocolVersion defaults to "1.1"', () {
      var request = Request('GET', localhostUri);
      expect(request.protocolVersion, '1.1');
    });

    test('provide non-default protocolVersion', () {
      var request = Request('GET', localhostUri, protocolVersion: '1.0');
      expect(request.protocolVersion, '1.0');
    });

    group('url', () {
      test("defaults to the requestedUri's relativized path and query", () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'));
        expect(request.url, equals(Uri.parse('foo/bar?q=1')));
      });

      test('may contain colon', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar:42'));
        expect(request.url, equals(Uri.parse('foo/bar:42')));
      });

      test('may contain colon in first segment', () {
        var request = Request('GET', Uri.parse('http://localhost/foo:bar/42'));
        expect(request.url, equals(Uri.parse('foo%3Abar/42')));
      });

      test('may contain slash', () {
        var request =
            Request('GET', Uri.parse('http://localhost/foo/bar%2f42'));
        expect(request.url, equals(Uri.parse('foo/bar%2f42')));
      });

      test('is inferred from handlerPath if possible', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo/');
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test('uses the given value if passed', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            url: Uri.parse('bar?q=1'));
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test('may be empty', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar'),
            url: Uri.parse(''));
        expect(request.url, equals(Uri.parse('')));
      });
    });

    group('handlerPath', () {
      test("defaults to '/'", () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar'));
        expect(request.handlerPath, equals('/'));
      });

      test('is inferred from url if possible', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            url: Uri.parse('bar?q=1'));
        expect(request.handlerPath, equals('/foo/'));
      });

      test('uses the given value if passed', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo/');
        expect(request.handlerPath, equals('/foo/'));
      });

      test('adds a trailing slash to the given value if necessary', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo');
        expect(request.handlerPath, equals('/foo/'));
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test('may be a single slash', () {
        var request = Request('GET', Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/');
        expect(request.handlerPath, equals('/'));
        expect(request.url, equals(Uri.parse('foo/bar?q=1')));
      });
    });

    group('errors', () {
      group('requestedUri', () {
        test('must be absolute', () {
          expect(() => Request('GET', Uri.parse('/path')), throwsArgumentError);
        });

        test('may not have a fragment', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/#fragment'));
          }, throwsArgumentError);
        });
      });

      group('url', () {
        test('must be relative', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test'),
                url: Uri.parse('http://localhost/test'));
          }, throwsArgumentError);
        });

        test('may not be root-relative', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test'),
                url: Uri.parse('/test'));
          }, throwsArgumentError);
        });

        test('may not have a fragment', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test'),
                url: Uri.parse('test#fragment'));
          }, throwsArgumentError);
        });

        test('must be a suffix of requestedUri', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/dir/test'),
                url: Uri.parse('dir'));
          }, throwsArgumentError);
        });

        test('must have the same query parameters as requestedUri', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test?q=1&r=2'),
                url: Uri.parse('test?q=2&r=1'));
          }, throwsArgumentError);

          // Order matters for query parameters.
          expect(() {
            Request('GET', Uri.parse('http://localhost/test?q=1&r=2'),
                url: Uri.parse('test?r=2&q=1'));
          }, throwsArgumentError);
        });
      });

      group('handlerPath', () {
        test('must be a prefix of requestedUri', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/dir/test'),
                handlerPath: '/test');
          }, throwsArgumentError);
        });

        test('must start with "/"', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test'),
                handlerPath: 'test');
          }, throwsArgumentError);
        });

        test('must be the requestedUri path if url is empty', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/test'),
                handlerPath: '/', url: Uri.parse(''));
          }, throwsArgumentError);
        });
      });

      group('handlerPath + url must', () {
        test('be requestedUrl path', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/foo/bar/baz'),
                handlerPath: '/foo/', url: Uri.parse('baz'));
          }, throwsArgumentError);
        });

        test('be on a path boundary', () {
          expect(() {
            Request('GET', Uri.parse('http://localhost/foo/bar/baz'),
                handlerPath: '/foo/ba', url: Uri.parse('r/baz'));
          }, throwsArgumentError);
        });
      });
    });
  });

  group('ifModifiedSince', () {
    test('is null without an If-Modified-Since header', () {
      var request = _request();
      expect(request.headers.ifModifiedSince, isNull);
    });

    test('comes from the Last-Modified header', () {
      var request = _request(
          headers: Headers.request(
              ifModifiedSince: parseHttpDate('Sun, 06 Nov 1994 08:49:37 GMT')));
      expect(request.headers.ifModifiedSince,
          equals(DateTime.parse('1994-11-06 08:49:37z')));
    });
  });

  group('change', () {
    test('with no arguments returns instance with equal values', () {
      var controller = StreamController<Uint8List>();

      var uri = Uri.parse('https://test.example.com/static/file.html');

      var request = Request('GET', uri,
          protocolVersion: '2.0',
          headers: Headers.request(
              custom: CustomHeaders({
            'header1': ['header value 1']
          })),
          url: Uri.parse('file.html'),
          handlerPath: '/static/',
          body: Body.fromDataStream(controller.stream),
          context: {'context1': 'context value 1'});

      var copy = request.copyWith();

      expect(copy.method, request.method);
      expect(copy.requestedUri, request.requestedUri);
      expect(copy.protocolVersion, request.protocolVersion);
      expect(copy.headers, same(request.headers));
      expect(copy.headers.custom, same(request.headers.custom));
      expect(copy.url, request.url);
      expect(copy.handlerPath, request.handlerPath);
      expect(copy.context, same(request.context));
      expect(copy.readAsString(), completion('hello, world'));

      controller.add(helloBytes);
      return Future(() {
        controller
          ..add(worldBytes)
          ..close();
      });
    });

    group('with path', () {
      test('updates handlerPath and url', () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request('GET', uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));
        var copy = request.copyWith(path: 'dir');

        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse('file.html'));
      });

      test('allows a trailing slash', () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request('GET', uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));
        var copy = request.copyWith(path: 'dir/');

        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse('file.html'));
      });

      test('regression test for Issue #142', () {
        var uri = Uri.parse('https://test.example.com/static/dir/');
        var request = Request('GET', uri,
            handlerPath: '/static/', url: Uri.parse('dir/'));

        var copy = request.copyWith(path: 'dir');
        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse(''));
      });

      test('allows changing path leading to double //', () {
        var uri = Uri.parse('https://test.example.com/some_base//more');
        var request = Request('GET', uri,
            handlerPath: '', url: Uri.parse('some_base//more'));

        var copy = request.copyWith(path: 'some_base');
        expect(copy.handlerPath, '/some_base/');
        expect(copy.url, Uri.parse('/more'));
      });

      test('throws if path does not match existing uri', () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request('GET', uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));

        expect(() => request.copyWith(path: 'wrong'), throwsArgumentError);
      });

      test("throws if path isn't a path boundary", () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request('GET', uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));

        expect(() => request.copyWith(path: 'di'), throwsArgumentError);
      });
    });

    test('allows the original request to be read', () {
      var request = _request();
      var changed = request.copyWith();

      expect(request.read().toList(), completion(isEmpty));
      expect(changed.read, throwsStateError);
    });

    test('allows the changed request to be read', () {
      var request = _request();
      var changed = request.copyWith();

      expect(changed.read().toList(), completion(isEmpty));
      expect(request.read, throwsStateError);
    });

    test('allows another changed request to be read', () {
      var request = _request();
      var changed1 = request.copyWith();
      var changed2 = request.copyWith();

      expect(changed2.read().toList(), completion(isEmpty));
      expect(changed1.read, throwsStateError);
      expect(request.read, throwsStateError);
    });
  });
}
