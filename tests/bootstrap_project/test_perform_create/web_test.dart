@Timeout(Duration(minutes: 5))
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
    'when performCreate is called with the context and a fullstack template type',
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
    'when performCreate is called with the context and a fullstack template type',
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
            contains('/app/assets/assets/config.json'),
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

          expect(content, contains('flutter build web'));
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
    'when performCreate is called with the context and a fullstack template type',
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

          expect(content, contains('flutter build web --base-href /'));
          expect(
            content,
            contains(
              'flutter build web --base-href / --output ../${project.name}_server/web/app',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp and website enabled, '
    'when performCreate is called with the context and a fullstack template type',
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

          expect(content, contains('flutter build web --base-href /app'));
          expect(
            content,
            contains(
              'flutter build web --base-href /app/ --output ../${project.name}_server/web/app',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a TemplateContext with webapp and website disabled, '
    'when performCreate is called with the context and a fullstack template type',
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
    'when performCreate is called, ',
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
    'Given a project is created with fullstack template and webapp and website enabled, '
    'and the pod is running',
    () {
      late Process startProjectProcess;

      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.fullstack,
          webapp: true,
          website: true,
        ),
      );

      setUpAll(() async {
        startProjectProcess = await startProcessAndWaitForKeywords(
          'dart',
          ['bin/main.dart', '--apply-migrations'],
          workingDirectory: project.serverDir,
          keywords: ['Webserver listening on'],
        );
      });

      tearDownAll(() {
        startProjectProcess.kill();
      });

      test(
        'when requesting the static website under / then it is is served',
        () async {
          final response = await http.get(Uri.parse('http://localhost:8082'));
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
            Uri.parse('http://localhost:8082/app'),
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

      group('Given the Flutter web app is built and the pod is restarted', () {
        setUp(() async {
          final flutterBuildProcess = await startServerpodCli(
            ['run', 'flutter_build'],
            rootPath: rootPath,
            workingDirectory: project.serverDir,
            environment: {
              'SERVERPOD_HOME': rootPath,
            },
          );
          expect(await flutterBuildProcess.exitCode, 0);

          startProjectProcess.kill();
          startProjectProcess = await startProcessAndWaitForKeywords(
            'dart',
            ['bin/main.dart', '--apply-migrations'],
            workingDirectory: project.serverDir,
            keywords: ['Webserver listening on'],
          );
        });

        test(
          'when requesting the Flutter web app under /app, '
          'then the web app is served successfully',
          () async {
            final response = await http.get(
              Uri.parse('http://localhost:8082/app'),
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
      });
    },
    skip: Platform.isWindows
        ? 'Windows does not support postgres in github actions'
        : null,
  );
}
