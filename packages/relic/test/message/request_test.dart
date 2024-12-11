import 'dart:async';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:relic/relic.dart';
import 'package:relic/src/method/request_method.dart';
import 'package:test/test.dart';

import '../util/test_util.dart';

Request _request({
  Headers? headers,
  Body? body,
}) {
  return Request(
    RequestMethod.get,
    localhostUri,
    headers: headers,
    body: body,
  );
}

void main() {
  group('Given a request constructor', () {
    test('when no protocolVersion is provided then it defaults to "1.1"', () {
      var request = Request(RequestMethod.get, localhostUri);
      expect(request.protocolVersion, '1.1');
    });

    test(
        'when a non-default protocolVersion is provided then it is set correctly',
        () {
      var request =
          Request(RequestMethod.get, localhostUri, protocolVersion: '1.0');
      expect(request.protocolVersion, '1.0');
    });

    group('Given a request URL', () {
      test(
          "when no url is provided then it defaults to the requestedUri's relativized path and query",
          () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'));
        expect(request.url, equals(Uri.parse('foo/bar?q=1')));
      });

      test('when the URL contains a colon then it is handled correctly', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar:42'));
        expect(request.url, equals(Uri.parse('foo/bar:42')));
      });

      test(
          'when the URL contains a colon in the first segment then it is handled correctly',
          () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo:bar/42'));
        expect(request.url, equals(Uri.parse('foo%3Abar/42')));
      });

      test('when the URL contains a slash then it is handled correctly', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar%2f42'));
        expect(request.url, equals(Uri.parse('foo/bar%2f42')));
      });

      test('when handlerPath is provided then url is inferred from it', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo/');
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test('when a specific url is provided then it is used', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            url: Uri.parse('bar?q=1'));
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test('when an empty url is provided then it is handled correctly', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar'),
            url: Uri.parse(''));
        expect(request.url, equals(Uri.parse('')));
      });
    });

    group('Given a request handlerPath', () {
      test("when no handlerPath is provided then it defaults to '/'", () {
        var request =
            Request(RequestMethod.get, Uri.parse('http://localhost/foo/bar'));
        expect(request.handlerPath, equals('/'));
      });

      test('when url is provided then handlerPath is inferred from it', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            url: Uri.parse('bar?q=1'));
        expect(request.handlerPath, equals('/foo/'));
      });

      test('when a specific handlerPath is provided then it is used', () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo/');
        expect(request.handlerPath, equals('/foo/'));
      });

      test(
          'when a handlerPath without a trailing slash is provided then it adds a trailing slash',
          () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/foo');
        expect(request.handlerPath, equals('/foo/'));
        expect(request.url, equals(Uri.parse('bar?q=1')));
      });

      test(
          'when a single slash is provided as handlerPath then it is handled correctly',
          () {
        var request = Request(
            RequestMethod.get, Uri.parse('http://localhost/foo/bar?q=1'),
            handlerPath: '/');
        expect(request.handlerPath, equals('/'));
        expect(request.url, equals(Uri.parse('foo/bar?q=1')));
      });
    });

    group('Given request errors', () {
      group('Given a requestedUri', () {
        test('when it is not absolute then it throws an ArgumentError', () {
          expect(() => Request(RequestMethod.get, Uri.parse('/path')),
              throwsArgumentError);
        });

        test('when it has a fragment then it throws an ArgumentError', () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/#fragment'));
          }, throwsArgumentError);
        });
      });

      group('Given a url', () {
        test('when it is not relative then it throws an ArgumentError', () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/test'),
                url: Uri.parse('http://localhost/test'));
          }, throwsArgumentError);
        });

        test('when it is root-relative then it throws an ArgumentError', () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/test'),
                url: Uri.parse('/test'));
          }, throwsArgumentError);
        });

        test('when it has a fragment then it throws an ArgumentError', () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/test'),
                url: Uri.parse('test#fragment'));
          }, throwsArgumentError);
        });

        test(
            'when it is not a suffix of requestedUri then it throws an ArgumentError',
            () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/dir/test'),
                url: Uri.parse('dir'));
          }, throwsArgumentError);
        });

        test(
            'when it does not have the same query parameters as requestedUri then it throws an ArgumentError',
            () {
          expect(() {
            Request(
                RequestMethod.get, Uri.parse('http://localhost/test?q=1&r=2'),
                url: Uri.parse('test?q=2&r=1'));
          }, throwsArgumentError);

          // Order matters for query parameters.
          expect(() {
            Request(
                RequestMethod.get, Uri.parse('http://localhost/test?q=1&r=2'),
                url: Uri.parse('test?r=2&q=1'));
          }, throwsArgumentError);
        });
      });

      group('Given a handlerPath', () {
        test(
            'when it is not a prefix of requestedUri then it throws an ArgumentError',
            () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/dir/test'),
                handlerPath: '/test');
          }, throwsArgumentError);
        });

        test('when it does not start with "/" then it throws an ArgumentError',
            () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/test'),
                handlerPath: 'test');
          }, throwsArgumentError);
        });

        test(
            'when url is empty and handlerPath is not the requestedUri path then it throws an ArgumentError',
            () {
          expect(() {
            Request(RequestMethod.get, Uri.parse('http://localhost/test'),
                handlerPath: '/', url: Uri.parse(''));
          }, throwsArgumentError);
        });
      });

      group('Given handlerPath + url', () {
        test(
            'when they do not form the requestedUrl path then it throws an ArgumentError',
            () {
          expect(() {
            Request(
                RequestMethod.get, Uri.parse('http://localhost/foo/bar/baz'),
                handlerPath: '/foo/', url: Uri.parse('baz'));
          }, throwsArgumentError);
        });

        test(
            'when they are not on a path boundary then it throws an ArgumentError',
            () {
          expect(() {
            Request(
                RequestMethod.get, Uri.parse('http://localhost/foo/bar/baz'),
                handlerPath: '/foo/ba', url: Uri.parse('r/baz'));
          }, throwsArgumentError);
        });
      });
    });
  });

  group('Given ifModifiedSince', () {
    test('when there is no If-Modified-Since header then it is null', () {
      var request = _request();
      expect(request.headers.ifModifiedSince, isNull);
    });

    test('when there is a Last-Modified header then it is set correctly', () {
      var request = _request(
          headers: Headers.request(
              ifModifiedSince: parseHttpDate('Sun, 06 Nov 1994 08:49:37 GMT')));
      expect(request.headers.ifModifiedSince,
          equals(DateTime.parse('1994-11-06 08:49:37z')));
    });
  });

  group('Given a request change', () {
    test(
        'when no arguments are provided then it returns an instance with equal values',
        () {
      var controller = StreamController<Uint8List>();

      var uri = Uri.parse('https://test.example.com/static/file.html');

      var request = Request(RequestMethod.get, uri,
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

    group('Given a path', () {
      test('when updated then it updates handlerPath and url', () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));
        var copy = request.copyWith(path: 'dir');

        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse('file.html'));
      });

      test('when a trailing slash is allowed then it is handled correctly', () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));
        var copy = request.copyWith(path: 'dir/');

        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse('file.html'));
      });

      test(
          'when handling a regression test for Issue #142 then it is handled correctly',
          () {
        var uri = Uri.parse('https://test.example.com/static/dir/');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '/static/', url: Uri.parse('dir/'));

        var copy = request.copyWith(path: 'dir');
        expect(copy.handlerPath, '/static/dir/');
        expect(copy.url, Uri.parse(''));
      });

      test(
          'when changing path leading to double // then it is handled correctly',
          () {
        var uri = Uri.parse('https://test.example.com/some_base//more');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '', url: Uri.parse('some_base//more'));

        var copy = request.copyWith(path: 'some_base');
        expect(copy.handlerPath, '/some_base/');
        expect(copy.url, Uri.parse('/more'));
      });

      test(
          'when path does not match existing uri then it throws an ArgumentError',
          () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));

        expect(() => request.copyWith(path: 'wrong'), throwsArgumentError);
      });

      test("when path isn't a path boundary then it throws an ArgumentError",
          () {
        var uri = Uri.parse('https://test.example.com/static/dir/file.html');
        var request = Request(RequestMethod.get, uri,
            handlerPath: '/static/', url: Uri.parse('dir/file.html'));

        expect(() => request.copyWith(path: 'di'), throwsArgumentError);
      });
    });

    test('when the original request is read then it allows reading', () {
      var request = _request();
      var changed = request.copyWith();

      expect(request.read().toList(), completion(isEmpty));
      expect(changed.read, throwsStateError);
    });

    test('when the changed request is read then it allows reading', () {
      var request = _request();
      var changed = request.copyWith();

      expect(changed.read().toList(), completion(isEmpty));
      expect(request.read, throwsStateError);
    });

    test('when another changed request is read then it allows reading', () {
      var request = _request();
      var changed1 = request.copyWith();
      var changed2 = request.copyWith();

      expect(changed2.read().toList(), completion(isEmpty));
      expect(changed1.read, throwsStateError);
      expect(request.read, throwsStateError);
    });
  });
}
