import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/endpoints.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class TestWidget extends WebWidget {
  final String method;

  TestWidget(this.method);

  @override
  String render({String? Function(String)? onMissingVariable}) {
    return '<html><body>Method: $method</body></html>';
  }
}

class GetPostRoute extends WidgetRoute {
  GetPostRoute() : super(methods: {Method.get, Method.post});

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TestWidget(request.method.toString());
  }
}

class NotFoundRoute extends WidgetRoute {
  NotFoundRoute() : super(methods: {Method.get, Method.post});

  @override
  Future<WebWidget?> build(Session session, Request request) async {
    return null;
  }
}

void main() {
  group('Given a widget route that accepts GET and POST methods', () {
    late Serverpod pod;
    late int port;

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
          webServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
        ),
      );

      pod.webServer.addRoute(GetPostRoute(), '/test-route');
      pod.webServer.addRoute(NotFoundRoute(), '/not-found-route');

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when GET request is made then route responds successfully.',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:$port/test-route'),
        );

        expect(response.statusCode, 200);
        expect(response.body, contains('Method: Method.get'));
      },
    );

    test(
      'when POST request is made then route responds successfully.',
      () async {
        var response = await http.post(
          Uri.parse('http://localhost:$port/test-route'),
        );

        expect(response.statusCode, 200);
        expect(response.body, contains('Method: Method.post'));
      },
    );

    test(
      'when GET request is made for a route that returns a null web widget, '
      'then a 404 response is returned.',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:$port/not-found-route'),
        );

        expect(response.statusCode, 404);
        expect(response.body, contains('Not found'));
      },
    );

    test(
      'when POST request is made for a route that returns a null web widget, '
      'then a 404 response is returned.',
      () async {
        var response = await http.post(
          Uri.parse('http://localhost:$port/not-found-route'),
        );

        expect(response.statusCode, 404);
        expect(response.body, contains('Not found'));
      },
    );
  });
}
