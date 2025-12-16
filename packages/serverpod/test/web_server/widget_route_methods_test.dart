import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/endpoints.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

class TestWidget extends WebWidget {
  final String method;

  TestWidget(this.method);

  @override
  String toString() => '<html><body>Method: $method</body></html>';
}

class GetPostRoute extends WidgetRoute {
  GetPostRoute() : super(methods: {Method.get, Method.post});

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TestWidget(request.method.toString());
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
  });
}
