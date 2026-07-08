import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/endpoints.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:test_descriptor/test_descriptor.dart' as d;

final portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

class CacheBustWidgetRoute extends WidgetRoute {
  CacheBustWidgetRoute({super.cacheBustingConfig});

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TemplateWidget(name: 'cache_bust_page');
  }
}

class NonBustWidgetRoute extends WidgetRoute {
  NonBustWidgetRoute();

  @override
  Future<WebWidget> build(Session session, Request request) async {
    return TemplateWidget(name: 'non_bust_page');
  }
}

void main() {
  group('Given a WidgetRoute with cacheBustingConfig', () {
    late Serverpod pod;
    late int port;
    late Directory assetDir;

    setUp(() async {
      assetDir = await Directory.systemTemp.createTemp('cache_bust_assets_');
      await File(p.join(assetDir.path, 'style.css')).writeAsString('body {}');
      await File(
        p.join(assetDir.path, 'app.js'),
      ).writeAsString('console.log("app");');

      await d.file('cache_bust_page.html', '''
<html>
  <script src="{{@/static/app.js}}"></script>
  <link rel="stylesheet" href="{{@/static/style.css}}">
</html>''').create();

      await d.file('non_bust_page.html', '''
<html>
  <script src="/static/app.js"></script>
</html>''').create();

      await templates.loadAll(Directory(d.sandbox));

      pod = Serverpod(
        [],
        internal.Protocol(),
        Endpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );

      pod.webServer.addRoute(
        CacheBustWidgetRoute(
          cacheBustingConfig: CacheBustingConfig(
            mountPrefix: '/static',
            fileSystemRoot: assetDir,
          ),
        ),
        '/bust-page',
      );

      pod.webServer.addRoute(
        NonBustWidgetRoute(),
        '/non-bust-page',
      );

      await pod.start();
      port = pod.webServer.port!;
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      await assetDir.delete(recursive: true);
      templates.clear();
    });

    test(
      'when template uses cache-busting patterns, then response contains cache-busted paths',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:$port/bust-page'),
        );

        expect(response.statusCode, 200);
        expect(response.body, contains('src="/static/app@'));
        expect(response.body, contains('href="/static/style@'));
        expect(response.body, contains('.js">'));
        expect(response.body, contains('.css">'));
        expect(response.body, isNot(contains('{{')));
      },
    );

    test(
      'when template has no cache-busting pattern, then response is unchanged',
      () async {
        var response = await http.get(
          Uri.parse('http://localhost:$port/non-bust-page'),
        );

        expect(response.statusCode, 200);
        expect(
          response.body,
          '<html>\n'
          '  <script src="/static/app.js"></script>\n'
          '</html>',
        );
      },
    );
  });
}
