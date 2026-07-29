import 'dart:io';

import 'package:lsp_server/lsp_server.dart' show FileChangeType;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../../test_util/builders/project_directory_builder.dart';
import '../../test_util/language_server_test_session.dart';

const _invalidModelYaml = '''
class: Example
fields:
  name: (String)
''';

const _validModelYaml = '''
class: Example
fields:
  name: String
''';

const _secondInvalidModelYaml = '''
class: Example2
fields:
  name: (String)
''';

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  group(
    'Given an initialized language server for a project with an invalid model '
    'file in a models subdirectory',
    () {
      late LanguageServerTestSession session;
      late String modelsDir;
      late String subDir;
      late String modelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.dir('subdir', [d.file('example.spy.yaml', _invalidModelYaml)]),
            ])
            .build()
            .create();

        modelsDir = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
        );
        subDir = p.join(modelsDir, 'subdir');
        modelPath = p.join(subDir, 'example.spy.yaml');

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        var initialDiagnostics = session.nextDiagnosticsFor(
          modelPath,
          where: (params) => params.diagnostics.isNotEmpty,
        );
        session.sendInitialized();
        await initialDiagnostics;
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when the model file is renamed on disk '
        'then diagnostics move from the old to the new URI.',
        () async {
          var newPath = p.join(subDir, 'renamed.spy.yaml');
          File(modelPath).renameSync(newPath);

          var oldUriCleared = session.nextDiagnosticsFor(
            modelPath,
            where: (params) => params.diagnostics.isEmpty,
          );
          var newUriReported = session.nextDiagnosticsFor(
            newPath,
            where: (params) => params.diagnostics.isNotEmpty,
          );
          session.sendWatchedFileEvents([
            (modelPath, FileChangeType.Deleted),
            (newPath, FileChangeType.Created),
          ]);

          await expectLater(oldUriCleared, completes);
          var diagnostics = (await newUriReported).diagnostics;
          expect(diagnostics.single.message, contains('invalid datatype'));
        },
      );

      test(
        'when the model file is deleted on disk '
        'then empty diagnostics are published for its URI.',
        () async {
          File(modelPath).deleteSync();

          var cleared = session.nextDiagnosticsFor(
            modelPath,
            where: (params) => params.diagnostics.isEmpty,
          );
          session.sendWatchedFileEvents([(modelPath, FileChangeType.Deleted)]);

          await expectLater(cleared, completes);
        },
      );

      test(
        'when a new invalid model file is created on disk without being opened '
        'then diagnostics are published for it.',
        () async {
          var newPath = p.join(modelsDir, 'example2.spy.yaml');
          File(newPath).writeAsStringSync(_secondInvalidModelYaml);

          var reported = session.nextDiagnosticsFor(
            newPath,
            where: (params) => params.diagnostics.isNotEmpty,
          );
          session.sendWatchedFileEvents([(newPath, FileChangeType.Created)]);

          var diagnostics = (await reported).diagnostics;
          expect(diagnostics.single.message, contains('invalid datatype'));
        },
      );

      test(
        'when the model directory is renamed on disk and only directory-level '
        'events are delivered then diagnostics move to the new URIs.',
        () async {
          var newSubDir = p.join(modelsDir, 'renamed_subdir');
          Directory(subDir).renameSync(newSubDir);

          var oldUriCleared = session.nextDiagnosticsFor(
            modelPath,
            where: (params) => params.diagnostics.isEmpty,
          );
          var newUriReported = session.nextDiagnosticsFor(
            p.join(newSubDir, 'example.spy.yaml'),
            where: (params) => params.diagnostics.isNotEmpty,
          );
          session.sendWatchedFileEvents([
            (subDir, FileChangeType.Deleted),
            (newSubDir, FileChangeType.Created),
          ]);

          await expectLater(oldUriCleared, completes);
          var diagnostics = (await newUriReported).diagnostics;
          expect(diagnostics.single.message, contains('invalid datatype'));
        },
      );

      test(
        'when a watched change event arrives for an open document '
        'then the editor buffer content stays authoritative.',
        () async {
          session.openDocument(modelPath, _invalidModelYaml);
          File(modelPath).writeAsStringSync(_validModelYaml);

          var revalidated = session.nextDiagnosticsFor(modelPath);
          session.sendWatchedFileEvents([(modelPath, FileChangeType.Changed)]);

          var diagnostics = (await revalidated).diagnostics;
          expect(
            diagnostics,
            isNotEmpty,
            reason:
                'The open document still holds the invalid model, so its '
                'errors must not be cleared by the valid content on disk.',
          );
        },
      );

      test(
        'when the model file is deleted on disk and the document is then '
        'closed then empty diagnostics are published for its URI.',
        () async {
          session.openDocument(modelPath, _invalidModelYaml);
          File(modelPath).deleteSync();

          var cleared = session.nextDiagnosticsFor(
            modelPath,
            where: (params) => params.diagnostics.isEmpty,
          );
          session.closeDocument(modelPath);

          await expectLater(cleared, completes);
        },
      );
    },
  );

  test(
    'Given a client that supports dynamic file watcher registration, '
    'when the language server is initialized, '
    'then watchers for model files and directories are registered.',
    () async {
      await ProjectDirectoryBuilder().build().create();
      var session = LanguageServerTestSession();
      addTearDown(session.dispose);

      await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
      var registrationReceived = session.nextRegistration();
      session.sendInitialized();
      var registration = await registrationReceived;

      expect(registration.method, 'workspace/didChangeWatchedFiles');
      var options = registration.registerOptions as Map;
      var watchers = (options['watchers'] as List).cast<Map>();
      expect(
        watchers.map((watcher) => watcher['globPattern']),
        containsAll(['**/*.{spy,yaml,yml}', '**/*']),
      );
      var directoryWatcher = watchers.singleWhere(
        (watcher) => watcher['globPattern'] == '**/*',
      );
      expect(directoryWatcher['kind'], 5, reason: 'WatchKind.Create | Delete');
    },
  );

  test(
    'Given a client without support for dynamic file watcher registration, '
    'when the language server is initialized, '
    'then no watcher registration is requested.',
    () async {
      await ProjectDirectoryBuilder().build().create();
      var session = LanguageServerTestSession();
      addTearDown(session.dispose);

      await session.initialize(
        Uri.directory(p.join(d.sandbox, 'project')),
        supportsWatchedFilesRegistration: false,
      );
      session.sendInitialized();
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(session.registrations, isEmpty);
    },
  );
}
