@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  final rootPath = p.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group(
    'Given a TemplateContext with website enabled, '
    'when performCreate is called with the context and a fullstack template type,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          website: true,
        ),
      );

      late Directory webDir;
      setUpAll(() {
        webDir = Directory(p.join(project.serverDir, 'web'));
      });

      test(
        'then the server contains a web directory',
        () async {
          await expectLater(webDir.exists(), completion(true));
        },
      );

      test(
        'then the server web directory contains web templates',
        () async {
          final templatesDir = Directory(p.join(webDir.path, 'templates'));
          await expectLater(templatesDir.exists(), completion(true));

          final html = File(
            p.join(templatesDir.path, 'built_with_serverpod.html'),
          );
          await expectLater(html.exists(), completion(true));
        },
      );

      test(
        'then the server server.dart contains correct imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('src/web/routes/root.dart'));
          expect(content, contains('src/cache_busting.dart'));
        },
      );

      test(
        'then the server server.dart contains website configurations',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('pod.webServer.addRoute(RootRoute()'));
          expect(
            content,
            contains('StaticRoute.withCacheBusting(cacheBustingConfig)'),
          );
        },
      );

      test(
        'then the build Flutter app page instructs users to run serverpod run flutter_build',
        () async {
          final buildFlutterAppPage = File(
            p.join(project.serverDir, 'web', 'pages', 'build_flutter_app.html'),
          );
          final content = await buildFlutterAppPage.readAsString();

          expect(content, contains('Flutter web app not built'));
          expect(
            content,
            contains(
              'The production version of your Flutter web app has not yet been '
              'built. The app is automatically built before deploying to '
              'Serverpod Cloud. If you want to manually build it, run the '
              'following command:',
            ),
          );
          expect(content, contains('serverpod run flutter_build'));
          expect(
            content,
            contains(
              'After the app has been built, restart the server and revisit this page.',
            ),
          );
        },
      );

      test(
        'then the server config for development contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for staging contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for production contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for test contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'test.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp enabled, '
    'when performCreate is called with the context and a fullstack template type,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
        ),
      );
      late Directory webDir;
      setUpAll(() {
        webDir = Directory(p.join(project.serverDir, 'web'));
      });

      test(
        'then the server contains a web directory',
        () async {
          await expectLater(webDir.exists(), completion(true));
        },
      );

      test(
        'then the server web directory contains web templates',
        () async {
          final templatesDir = Directory(p.join(webDir.path, 'templates'));
          await expectLater(templatesDir.exists(), completion(true));

          final html = File(
            p.join(templatesDir.path, 'built_with_serverpod.html'),
          );
          await expectLater(html.exists(), completion(true));
        },
      );

      test(
        'then the server server.dart contains correct imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('dart:io'));
          expect(content, contains('src/web/routes/app_config_route.dart'));
          expect(content, contains('src/cache_busting.dart'));
        },
      );

      test(
        'then the server server.dart contains webapp configurations',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(
            content,
            contains('StaticRoute.withCacheBusting(cacheBustingConfig)'),
          );
          expect(
            content,
            contains('AppConfigRoute(apiConfig: pod.config.apiServer),'),
          );
          expect(
            content,
            contains(
              "final appDir = Directory(Uri(path: 'web/app').toFilePath());",
            ),
          );
          expect(content, contains('FlutterRoute('));
          expect(
            content,
            contains(
              "Uri(path: 'web/pages/build_flutter_app.html').toFilePath()",
            ),
          );
        },
      );

      test(
        'then the server server.dart disables WASM headers by default',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();

          expect(
            content,
            contains(
              'If building the Flutter app with WASM, set the below parameter to',
            ),
          );
          expect(
            content,
            contains(
              'true and add the --wasm flag to the flutter build command.',
            ),
          );
          expect(content, contains('enableWasmHeaders: false'));
          expect(content, isNot(contains('enableWasmHeaders: true')));
        },
      );

      test(
        'then the server pubspec contains a Flutter build script without WASM',
        () async {
          final pubspec = File(p.join(project.serverDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();

          expect(content, contains('flutter build'));
          expect(content, isNot(contains('--wasm')));
        },
      );

      test(
        'then the server config for development contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for staging contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for production contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );

      test(
        'then the server config for test contains webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'test.yaml'),
          );
          final content = await config.readAsString();
          expect(content, contains('webServer:'));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp enabled and website disabled, '
    'when performCreate is called with the context and a fullstack template type,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
          website: false,
        ),
      );

      test(
        'then the server server.dart serves the Flutter web app under /',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('// Serve the flutter web app under /.'));
          expect(content, contains("'/'"));
          expect(content, contains("'/**'"));
        },
      );

      test(
        'then the server server.dart serves the app config under the root asset path',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains("'/assets/assets/config.json'"));
        },
      );

      test(
        'then the server.dart has a fallback middleware for the default route',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('pod.webServer.addMiddleware('));
          expect(content, contains('FallbackMiddleware('));
          expect(
            content,
            contains('on: (response) => response.statusCode == 404'),
          );
        },
      );

      test(
        'then the server pubspec contains Flutter build script with base-href /',
        () async {
          final pubspec = File(p.join(project.serverDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();

          expect(
            content,
            matches(RegExp(r'set ARGS=web --base-href /(?!app)')),
          );
          expect(
            content,
            contains(
              'set -- web --base-href / --output ../${project.name}_server/web/app',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp and website enabled, '
    'when performCreate is called with the context and a fullstack template type,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
          website: true,
        ),
      );

      test(
        'then the server server.dart serves the Flutter web app under the /app path',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(
            content,
            contains('// Serve the flutter web app under the /app path.'),
          );
          expect(content, contains("'/app'"));
          expect(content, contains("'/app/**'"));
        },
      );

      test(
        'then the server server.dart serves the app config under the /app asset path',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains("'/app/assets/assets/config.json'"));
        },
      );

      test(
        'then the server.dart does not have a fallback middleware for the default route',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, isNot(contains('pod.webServer.addMiddleware(')));
          expect(content, isNot(contains('FallbackMiddleware(')));
          expect(
            content,
            isNot(contains('on: (response) => response.statusCode == 404')),
          );
        },
      );

      test(
        'then the server pubspec contains Flutter build script with base-href /app',
        () async {
          final pubspec = File(p.join(project.serverDir, 'pubspec.yaml'));
          final content = await pubspec.readAsString();

          expect(content, contains('set ARGS=web --base-href /app/'));
          expect(
            content,
            contains(
              'set -- web --base-href /app/ --output ../${project.name}_server/web/app',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp and website disabled, '
    'when performCreate is called with the context and a fullstack template type,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: false,
          website: false,
        ),
      );

      late Directory webDir;
      setUpAll(() {
        webDir = Directory(p.join(project.serverDir, 'web'));
      });

      test(
        'then the server does not contain a web/templates directory',
        () async {
          final templatesDir = Directory(p.join(webDir.path, 'templates'));
          await expectLater(templatesDir.exists(), completion(false));
        },
      );

      test('then the server does not have a src/cache_busting.dart file', () {
        expect(
          File(
            p.join(project.serverDir, 'lib', 'src', 'cache_busting.dart'),
          ).existsSync(),
          isFalse,
          reason: 'Server cache_busting.dart file exists but should not.',
        );
      });

      test(
        'then the server server.dart does not contain web imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(
            content,
            isNot(contains('src/web/routes/app_config_route.dart')),
          );
          expect(content, isNot(contains('src/web/routes/root.dart')));
          expect(content, isNot(contains('src/cache_busting.dart')));
        },
      );

      test(
        'then the server server.dart does not contain web configurations',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, isNot(contains('pod.webServer.addRoute(')));
          expect(
            content,
            isNot(contains('AppConfigRoute(apiConfig: pod.config.apiServer)')),
          );
        },
      );

      test(
        'then the server config for development does not contain webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'development.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('webServer:')));
        },
      );

      test(
        'then the server config for staging does not contain webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'staging.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('webServer:')));
        },
      );

      test(
        'then the server config for production does not contain webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'production.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('webServer:')));
        },
      );

      test(
        'then the server config for test does not contain webserver configurations',
        () async {
          final config = File(
            p.join(project.serverDir, 'config', 'test.yaml'),
          );
          final content = await config.readAsString();
          expect(content, isNot(contains('webServer:')));
        },
      );
    },
  );

  group(
    'Given a TemplateContext with a module template type, '
    'when performCreate is called,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(template: ServerpodTemplateType.module),
      );

      test(
        'then the server test config contains webserver configuration',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, contains('webServer:'));
        },
      );
    },
  );

  group(
    'Given a project is created with fullstack template and webapp enabled with an injected config asset, '
    'and the pod is running with managed public hosts,',
    () {
      Process? startProjectProcess;
      HttpClient? client;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
        ),
      );

      setUpAll(() async {
        final appDir = Directory(p.join(project.serverDir, 'web', 'app'));
        final configAsset = File(
          p.join(appDir.path, 'assets', 'assets', 'config.json'),
        );
        await configAsset.parent.create(recursive: true);
        await File(p.join(appDir.path, 'index.html')).writeAsString(
          '<html><body>Flutter app</body></html>',
        );
        await configAsset.writeAsString(
          jsonEncode({'apiUrl': 'https://invalid.url'}),
        );

        final testConfig = File(
          p.join(project.serverDir, 'config', 'test.yaml'),
        );
        // Templates checked out on Windows use CRLF. Normalize before matching
        // the multiline YAML blocks below so the replacements work on every
        // platform.
        final config = (await testConfig.readAsString()).replaceAll(
          '\r\n',
          '\n',
        );
        await testConfig.writeAsString(
          config
              .replaceFirst(
                '''apiServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http''',
                '''apiServer:
  port: 0
  publicHost: api.managed.host
  publicPort: 443
  publicScheme: https''',
              )
              .replaceFirst(
                '''webServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http''',
                '''webServer:
  port: 0
  publicHost: app.managed.host
  publicPort: 80
  publicScheme: http''',
              ),
        );

        final startedPod = await _startPodAndCaptureWebPort(
          project: project,
          host: 'app.managed.host',
        );
        startProjectProcess = startedPod.process;

        client = HttpClient()
          ..connectionFactory = (uri, proxyHost, proxyPort) async {
            return Socket.startConnect(
              InternetAddress.loopbackIPv4,
              startedPod.webPort,
            );
          };
      });

      tearDownAll(() async {
        client?.close(force: true);
        final process = startProjectProcess;
        if (process != null) await stopProcess(process);
      });

      test(
        'when requesting the root config asset, '
        'then the dynamic app config overrides the injected asset',
        () async {
          final request = await client!.getUrl(
            Uri.http(
              'app.managed.host',
              '/assets/assets/config.json',
            ),
          );
          final response = await request.close();
          final responseBody = await utf8.decoder.bind(response).join();
          final appConfig = jsonDecode(responseBody) as Map<String, dynamic>;
          final apiUrl = Uri.parse(appConfig['apiUrl'] as String);

          expect(response.statusCode, HttpStatus.ok);
          expect(apiUrl.scheme, 'https');
          expect(apiUrl.host, 'api.managed.host');
          expect(apiUrl.port, 443);
          expect(responseBody, isNot(contains('invalid.url')));
        },
      );
    },
  );

  group(
    'Given a project is created with fullstack template and webapp and website enabled, '
    'and the pod is running, '
    'and Flutter web app is not built,',
    () {
      Process? startProjectProcess;
      late int webPort;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
          website: true,
        ),
      );

      setUpAll(() async {
        final startedPod = await _startPodAndCaptureWebPort(
          project: project,
          host: 'localhost',
        );
        startProjectProcess = startedPod.process;
        webPort = startedPod.webPort;
      });

      tearDownAll(() async {
        final process = startProjectProcess;
        if (process != null) await stopProcess(process);
      });

      test(
        'when requesting the static website under /, then it is is served',
        () async {
          final response = await http.get(
            Uri.parse('http://localhost:$webPort'),
          );
          expect(response.statusCode, equals(200));
          expect(
            response.body,
            contains('<title>Built with Serverpod</title>'),
          );
          expect(response.body, contains('Open Flutter app'));
        },
      );

      test(
        'when requesting the Flutter web app under /app before it is built, '
        'then the "Flutter web app not built" page is served',
        () async {
          final response = await http.get(
            Uri.parse('http://localhost:$webPort/app'),
          );
          expect(response.statusCode, equals(200));
          expect(
            response.body,
            contains('<title>Flutter web app not built</title>'),
          );
          expect(
            response.body,
            isNot(
              contains(
                '<meta name="description" content="A new Flutter project.">',
              ),
            ),
          );
        },
      );
    },
  );

  group(
    'Given a project is created with fullstack template and webapp and website enabled, '
    'and the Flutter web app is built, '
    'and the pod is running,',
    () {
      Process? startProjectProcess;
      late int webPort;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
          website: true,
        ),
      );

      setUpAll(() async {
        final flutterBuildProcess = await startServerpodCli(
          ['run', 'flutter_build'],
          rootPath: rootPath,
          workingDirectory: project.serverDir,
          environment: {
            'SERVERPOD_HOME': rootPath,
          },
        );
        expect(await flutterBuildProcess.exitCode, 0);

        final startedPod = await _startPodAndCaptureWebPort(
          project: project,
          host: 'localhost',
        );
        startProjectProcess = startedPod.process;
        webPort = startedPod.webPort;
      });

      tearDownAll(() async {
        final process = startProjectProcess;
        if (process != null) await stopProcess(process);
      });

      test(
        'when requesting the Flutter web app under /app, '
        'then the web app is served successfully',
        () async {
          final response = await http.get(
            Uri.parse('http://localhost:$webPort/app'),
          );
          expect(response.statusCode, equals(200));
          expect(
            response.body,
            isNot(contains('<title>Flutter web app not built</title>')),
          );
          expect(
            response.body,
            contains(
              '<meta name="description" content="A new Flutter project.">',
            ),
          );
        },
      );
    },
  );
}

Future<({Process process, int webPort})> _startPodAndCaptureWebPort({
  required TempProject project,
  required String host,
}) async {
  final serverOutput = StringBuffer();
  final webServerStartedPattern = RegExp(
    'Webserver listening on http://${RegExp.escape(host)}:(\\d+)',
  );
  int? webPort;
  final process = await startProcessAndWaitForKeywords(
    'dart',
    ['bin/main.dart', '--mode=test'],
    workingDirectory: project.serverDir,
    keywords: ['Webserver listening on'],
    onOutput: (output) {
      serverOutput.write(output);
      final match = webServerStartedPattern.firstMatch(serverOutput.toString());
      if (match != null) webPort = int.parse(match.group(1)!);
    },
  );
  expect(
    webPort,
    isNotNull,
    reason: 'Could not determine the web server port.',
  );

  return (process: process, webPort: webPort!);
}
