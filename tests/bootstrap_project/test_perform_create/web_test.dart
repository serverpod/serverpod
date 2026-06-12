import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
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
    'Given a TemplateContext with web enabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          web: true,
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
        'then the server server.dart contains web imports',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('src/web/routes/app_config_route.dart'));
          expect(content, contains('src/web/routes/root.dart'));
        },
      );

      test(
        'then the server server.dart contains web configurations',
        () async {
          final serverFile = File(
            p.join(project.serverDir, 'lib', 'server.dart'),
          );
          final content = await serverFile.readAsString();
          expect(content, contains('pod.webServer.addRoute('));
          expect(
            content,
            contains('AppConfigRoute(apiConfig: pod.config.apiServer)'),
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
              'Remove this line if you build the Flutter app with --wasm',
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

          expect(content, contains('flutter build web --base-href /app/'));
          expect(content, isNot(contains('--wasm')));
        },
      );

      test(
        'then the build Flutter app page uses a non-WASM build by default',
        () async {
          final buildFlutterAppPage = File(
            p.join(project.serverDir, 'web', 'pages', 'build_flutter_app.html'),
          );
          final content = await buildFlutterAppPage.readAsString();

          expect(
            content,
            contains(
              'flutter build web --base-href /app/ '
              '-o ../${project.name}_server/web/app',
            ),
          );
          expect(
            content,
            isNot(contains('flutter build web --base-href /app/ --wasm')),
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
    'Given a TemplateContext with web disabled, '
    'when performCreate is called with the context and a server template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          web: false,
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
    'Given a TemplateContext with web enabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          web: true,
        ),
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
    'Given a TemplateContext with web disabled, '
    'when performCreate is called with the context and a module template type',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          web: false,
        ),
      );

      test(
        'then the server test config does not contain webserver configuration',
        () async {
          final file = File(p.join(project.serverDir, 'config', 'test.yaml'));
          final content = await file.readAsString();
          expect(content, isNot(contains('webServer:')));
        },
      );
    },
  );
}
