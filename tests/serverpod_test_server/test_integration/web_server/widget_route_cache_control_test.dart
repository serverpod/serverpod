import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

// Test widget classes
class TestHtmlWidget extends WebWidget {
  @override
  String toString() => '<html><body>Test HTML</body></html>';
}

class TestJsonWidget extends JsonWidget {
  TestJsonWidget() : super(object: {'test': 'json'});
}

class TestRedirectWidget extends RedirectWidget {
  TestRedirectWidget() : super(url: '/redirected');
}

// Test route implementations
class HtmlTestRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TestHtmlWidget();
  }
}

class JsonTestRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TestJsonWidget();
  }
}

class RedirectTestRoute extends WidgetRoute {
  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TestRedirectWidget();
  }
}

void main() {
  group('Given a web server with widget routes', () {
    late Serverpod serverpod;

    setUp(() async {
      serverpod = IntegrationTestServer.create();

      // Add all test routes
      serverpod.webServer.addRoute(HtmlTestRoute(), '/html-route');
      serverpod.webServer.addRoute(JsonTestRoute(), '/json-route');
      serverpod.webServer.addRoute(RedirectTestRoute(), '/redirect-route');

      await serverpod.start();
    });

    tearDown(() async {
      await serverpod.shutdown(exitProcess: false);
    });

    test(
      'when requesting an HTML widget route '
      'then the cache-control header is set to no-cache and private',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:8082/html-route'),
        );

        expect(response.headers['cache-control'], 'no-cache, private');
      },
    );

    test(
      'when requesting a JSON widget route '
      'then the cache-control header is set to no-cache and private',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:8082/json-route'),
        );

        expect(response.headers['cache-control'], 'no-cache, private');
      },
    );

    test('when requesting a JSON widget route '
        'then the content-type is application/json', () async {
      var response = await http.get(
        Uri.parse('http://localhost:8082/json-route'),
      );

      expect(response.headers['content-type'], contains('application/json'));
    });

    test(
      'when requesting an HTML widget route '
      'then the content-type is text/html even with cache headers set',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:8082/html-route'),
        );

        expect(response.headers['content-type'], contains('text/html'));
        expect(response.headers['cache-control'], 'no-cache, private');
      },
    );

    test('when requesting a JSON widget route '
        'then both content-type and cache headers are set correctly', () async {
      var response = await http.get(
        Uri.parse('http://localhost:8082/json-route'),
      );

      expect(response.headers['content-type'], contains('application/json'));
      expect(response.headers['cache-control'], 'no-cache, private');
    });

    test(
      'when requesting a redirect widget route '
      'then the redirect response does not have cache-control headers',
      () async {
        // Create client that doesn't follow redirects
        var client = http.Client();
        var request = http.Request(
          'GET',
          Uri.parse('http://localhost:8082/redirect-route'),
        );
        request.followRedirects = false;

        var streamedResponse = await client.send(request);
        var response = await http.Response.fromStream(streamedResponse);

        expect(response.statusCode, 303); // See Other redirect
        // Redirect responses don't get cache control headers applied
        // since they return early before the cache control logic
        expect(response.headers['cache-control'], isNull);
      },
    );

    test('when requesting a redirect widget route '
        'then the location header is set correctly', () async {
      var client = http.Client();
      var request = http.Request(
        'GET',
        Uri.parse('http://localhost:8082/redirect-route'),
      );
      request.followRedirects = false;

      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      expect(response.headers['location'], '/redirected');
    });
  });
}
