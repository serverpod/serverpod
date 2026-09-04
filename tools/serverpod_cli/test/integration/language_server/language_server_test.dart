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

void main() {
  setUpAll(() {
    CommandLineExperimentalFeatures.initialize([]);
  });

  group('Given an initialized language server for a project without model '
      'files', () {
    late LanguageServerTestSession session;
    late String modelsDir;

    setUp(() async {
      await ProjectDirectoryBuilder().build().create();

      modelsDir = p.join(
        d.sandbox,
        'project',
        'my_project_server',
        'lib',
        'src',
        'models',
      );

      session = LanguageServerTestSession();
      await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
      session.sendInitialized();
    });

    tearDown(() async {
      await session.dispose();
    });

    test(
      'when an invalid model file is created on disk without being opened '
      'then diagnostics are published for it.',
      () async {
        var newPath = p.join(modelsDir, 'example.spy.yaml');
        File(newPath).writeAsStringSync(_invalidModelYaml);

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
      'when a valid model file is created on disk without being opened '
      'then empty diagnostics are published for it.',
      () async {
        var newPath = p.join(modelsDir, 'example.spy.yaml');
        File(newPath).writeAsStringSync(_validModelYaml);

        var reported = session.nextDiagnosticsFor(newPath);
        session.sendWatchedFileEvents([(newPath, FileChangeType.Created)]);

        var diagnostics = (await reported).diagnostics;
        expect(diagnostics, isEmpty);
      },
    );
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
        'when the model directory is renamed on disk and only directory-level '
        'events are delivered '
        'then diagnostics move to the new URIs.',
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
    },
  );

  group(
    'Given an initialized language server with an open document for an '
    'invalid model file',
    () {
      late LanguageServerTestSession session;
      late String modelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.file('example.spy.yaml', _invalidModelYaml),
            ])
            .build()
            .create();

        modelPath = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
          'example.spy.yaml',
        );

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        var initialDiagnostics = session.nextDiagnosticsFor(
          modelPath,
          where: (params) => params.diagnostics.isNotEmpty,
        );
        session.sendInitialized();
        await initialDiagnostics;

        session.openDocument(modelPath, _invalidModelYaml);
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when a watched change event arrives for the open document '
        'then the editor buffer content stays authoritative.',
        () async {
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
        'closed '
        'then empty diagnostics are published for its URI.',
        () async {
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
        containsAll([
          '**/*.{spy,spy.yaml,spy.yml}',
          '**/lib/**',
        ]),
      );
      var directoryWatcher = watchers.singleWhere(
        (watcher) => watcher['globPattern'] == '**/lib/**',
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

  group('Given an initialized language server with registered models,', () {
    late LanguageServerTestSession session;
    late String modelsDir;
    late String userModelPath;
    late String postModelPath;
    late String indexedModelPath;
    late String configModelPath;
    late String enumModelPath;
    late String jobModelPath;

    setUp(() async {
      await ProjectDirectoryBuilder().build().create();

      modelsDir = p.join(
        d.sandbox,
        'project',
        'my_project_server',
        'lib',
        'src',
        'models',
      );

      userModelPath = p.join(modelsDir, 'user.spy.yaml');
      postModelPath = p.join(modelsDir, 'post.spy.yaml');
      indexedModelPath = p.join(modelsDir, 'indexed.spy.yaml');
      configModelPath = p.join(modelsDir, 'app_config.spy.yaml');
      enumModelPath = p.join(modelsDir, 'stage_family.spy.yaml');
      jobModelPath = p.join(modelsDir, 'job.spy.yaml');

      File(userModelPath).writeAsStringSync('''
class: User
table: user
fields:
  name: String
''');

      File(postModelPath).writeAsStringSync('''
class: Post
table: post
fields:
  title: String
  authorId: int
  author: User?, relation(field=authorId)
''');

      File(indexedModelPath).writeAsStringSync('''
class: Indexed
table: indexed
fields:
  title: String
  authorId: int
indexes:
  indexed_title_idx:
    fields: title, authorId
''');

      File(configModelPath).writeAsStringSync('''
class: AppConfig
fields:
  data: project:my_project:ConfigData
''');

      File(enumModelPath).writeAsStringSync('''
enum: IngestionStageFamily
serialized: byName
values:
  - alpha
  - beta
''');

      File(jobModelPath).writeAsStringSync('''
class: Job
table: job
fields:
  stage: IngestionStageFamily
''');

      session = LanguageServerTestSession();
      await session.initialize(
        Uri.directory(p.join(d.sandbox, 'project')),
        linkSupport: false,
      );
      session.sendInitialized();
    });

    tearDown(() async {
      await session.dispose();
    });

    test(
      'when definition is requested on a model type name, '
      'then it returns the location of the model definition.',
      () async {
        // Line 5 in post.spy.yaml is: "  author: User?, relation(field=authorId)"
        // "User" is at column 10
        var result = await session.requestDefinition(
          postModelPath,
          line: 5,
          character: 11,
        );

        expect(result, isNotNull);
        var location = result as Map<String, dynamic>;
        var range = location['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        expect(location['uri'], Uri.file(userModelPath).toString());
        expect(start['line'], 0);
        expect(start['character'], 7);
      },
    );

    test(
      'when definition is requested on a relation field reference, '
      'then it returns the location of that field in the current file.',
      () async {
        // Line 5 in post.spy.yaml is: "  author: User?, relation(field=authorId)"
        // "authorId" is at column 32
        var result = await session.requestDefinition(
          postModelPath,
          line: 5,
          character: 34,
        );

        expect(result, isNotNull);
        var location = result as Map<String, dynamic>;
        var range = location['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        expect(location['uri'], Uri.file(postModelPath).toString());
        // authorId is defined at line 4: "  authorId: int"
        expect(start['line'], 4);
      },
    );

    test(
      'when definition is requested on a primitive type, '
      'then it returns null.',
      () async {
        // Line 3 in post.spy.yaml: "  title: String" -> "String" is at column 9
        var result = await session.requestDefinition(
          postModelPath,
          line: 3,
          character: 10,
        );

        expect(result, isNull);
      },
    );

    test(
      'when references are requested for a class on its declaration line with includeDeclaration false, '
      'then it returns references across other model files.',
      () async {
        // Line 0 in user.spy.yaml: "class: User" -> "User" is at column 7
        var result = await session.requestReferences(
          userModelPath,
          line: 0,
          character: 8,
          includeDeclaration: false,
        );

        expect(result, isNotNull);
        expect(result, isA<List>());
        var locations = (result as List).cast<Map<String, dynamic>>();
        expect(locations, hasLength(1));

        var loc = locations.first;
        expect(loc['uri'], Uri.file(postModelPath).toString());
        var range = loc['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        var end = range['end'] as Map<String, dynamic>;
        // In post.spy.yaml: "  author: User?, relation(field=authorId)" -> line 5, col 10..14
        expect(start['line'], 5);
        expect(start['character'], 10);
        expect(end['character'], 14);
      },
    );

    test(
      'when references are requested for a class on its declaration line with includeDeclaration true, '
      'then it returns the declaration and all references.',
      () async {
        var result = await session.requestReferences(
          userModelPath,
          line: 0,
          character: 8,
          includeDeclaration: true,
        );

        expect(result, isNotNull);
        expect(result, isA<List>());
        var locations = (result as List).cast<Map<String, dynamic>>();
        expect(locations, hasLength(2));

        var declLoc = locations.firstWhere(
          (loc) => loc['uri'] == Uri.file(userModelPath).toString(),
        );
        var declStart = (declLoc['range'] as Map)['start'] as Map;
        expect(declStart['line'], 0);
        expect(declStart['character'], 7);

        var refLoc = locations.firstWhere(
          (loc) => loc['uri'] == Uri.file(postModelPath).toString(),
        );
        var refStart = (refLoc['range'] as Map)['start'] as Map;
        expect(refStart['line'], 5);
        expect(refStart['character'], 10);
      },
    );

    test(
      'when references are requested for a field, '
      'then it returns occurrences in relations and declarations.',
      () async {
        // Line 4 in post.spy.yaml: "  authorId: int" -> "authorId" is at column 4
        var result = await session.requestReferences(
          postModelPath,
          line: 4,
          character: 5,
          includeDeclaration: true,
        );

        expect(result, isNotNull);
        expect(result, isA<List>());
        var locations = (result as List).cast<Map<String, dynamic>>();
        expect(locations, hasLength(2));

        // Declaration at line 4
        var decl = locations.firstWhere(
          (l) => ((l['range'] as Map)['start'] as Map)['line'] == 4,
        );
        expect(decl['uri'], Uri.file(postModelPath).toString());

        // Relation reference at line 5
        var rel = locations.firstWhere(
          (l) => ((l['range'] as Map)['start'] as Map)['line'] == 5,
        );
        expect(rel['uri'], Uri.file(postModelPath).toString());
      },
    );

    test(
      'when references are requested for an enum on its declaration line, '
      'then it returns references across other model files.',
      () async {
        // Line 0 in stage_family.spy.yaml: "enum: IngestionStageFamily" ->
        // "IngestionStageFamily" is at column 6
        var result = await session.requestReferences(
          enumModelPath,
          line: 0,
          character: 8,
          includeDeclaration: false,
        );

        expect(result, isNotNull);
        var locations = (result as List).cast<Map<String, dynamic>>();
        expect(locations, hasLength(1));

        var loc = locations.first;
        expect(loc['uri'], Uri.file(jobModelPath).toString());
        var start = (loc['range'] as Map)['start'] as Map;
        // In job.spy.yaml: "  stage: IngestionStageFamily" -> line 3, col 9
        expect(start['line'], 3);
        expect(start['character'], 9);
      },
    );

    test(
      'when references are requested for a primitive type, '
      'then it returns an empty list.',
      () async {
        var result = await session.requestReferences(
          postModelPath,
          line: 3,
          character: 10,
        );

        expect(result, isA<List>());
        expect(result as List, isEmpty);
      },
    );

    test(
      'when definition is requested on a word that resolves to nothing, '
      'then it returns null.',
      () async {
        // Line 3 in post.spy.yaml: "  title: String" -> "title" is a field
        // declaration, not a reference, and matches no model or table name.
        var result = await session.requestDefinition(
          postModelPath,
          line: 3,
          character: 3,
        );

        expect(result, isNull);
      },
    );

    test(
      'when definition is requested on a database table name, '
      'then it returns the location of the model definition.',
      () async {
        // Line 1 in user.spy.yaml: "table: user" -> "user" is at column 7
        var result = await session.requestDefinition(
          userModelPath,
          line: 1,
          character: 8,
        );

        expect(result, isNotNull);
        var location = result as Map<String, dynamic>;
        var range = location['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        expect(location['uri'], Uri.file(userModelPath).toString());
        expect(start['line'], 0);
        expect(start['character'], 7);
      },
    );

    test(
      'when definition is requested on a field in an index, '
      'then it returns the location of the field declaration.',
      () async {
        // Line 7 in indexed.spy.yaml: "    fields: title, authorId" ->
        // "authorId" is at column 19
        var result = await session.requestDefinition(
          indexedModelPath,
          line: 7,
          character: 20,
        );

        expect(result, isNotNull);
        var location = result as Map<String, dynamic>;
        var range = location['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        expect(location['uri'], Uri.file(indexedModelPath).toString());
        // authorId is declared at line 4: "  authorId: int"
        expect(start['line'], 4);
        expect(start['character'], 2);
      },
    );

    test(
      'when a model definition is requested by class name, '
      'then it returns the location of the model definition.',
      () async {
        var result = await session.requestModelDefinition('User');

        expect(result, isNotNull);
        var location = result as Map<String, dynamic>;
        var range = location['range'] as Map<String, dynamic>;
        var start = range['start'] as Map<String, dynamic>;
        expect(location['uri'], Uri.file(userModelPath).toString());
        expect(start['line'], 0);
        expect(start['character'], 7);
      },
    );

    test(
      'when a model definition is requested by an unknown class name, '
      'then it returns null.',
      () async {
        var result = await session.requestModelDefinition('NonExistent');

        expect(result, isNull);
      },
    );

    test(
      'when definition is requested on a project: type reference, '
      'then it returns null.',
      () async {
        // Line 2 in app_config.spy.yaml: "  data: project:my_project:ConfigData"
        // -> "ConfigData" is at column 27
        var result = await session.requestDefinition(
          configModelPath,
          line: 2,
          character: 30,
        );

        expect(result, isNull);
      },
    );

    test(
      'when references are requested on a project: type reference, '
      'then it returns an empty list.',
      () async {
        var result = await session.requestReferences(
          configModelPath,
          line: 2,
          character: 30,
        );

        expect(result, isA<List>());
        expect(result as List, isEmpty);
      },
    );

    test(
      'when references are requested for a field with includeDeclaration false, '
      'then only the references are returned.',
      () async {
        // Line 4 in post.spy.yaml: "  authorId: int" -> "authorId" is at
        // column 2
        var result = await session.requestReferences(
          postModelPath,
          line: 4,
          character: 5,
          includeDeclaration: false,
        );

        expect(result, isNotNull);
        var locations = (result as List).cast<Map<String, dynamic>>();
        expect(locations, hasLength(1));

        var ref = locations.first;
        expect(ref['uri'], Uri.file(postModelPath).toString());
        var start = (ref['range'] as Map)['start'] as Map;
        expect(start['line'], 5);
        expect(start['character'], 32);
      },
    );
  });

  group(
    'Given an initialized language server with a model that has a field named like a YAML keyword,',
    () {
      late LanguageServerTestSession session;
      late String profileModelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.file('user.spy.yaml', '''
class: User
table: user
fields:
  name: String
'''),
              d.file('profile.spy.yaml', '''
class: Profile
table: profile
fields:
  name: String
  user: User?, relation(field=name)
'''),
            ])
            .build()
            .create();

        profileModelPath = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
          'profile.spy.yaml',
        );

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        session.sendInitialized();
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when definition is requested on a relation reference to that field, '
        'then it returns the location of the field declaration.',
        () async {
          // Line 4 in profile.spy.yaml: "  user: User?, relation(field=name)"
          // -> the referenced "name" is at column 30
          var result = await session.requestDefinition(
            profileModelPath,
            line: 4,
            character: 31,
          );

          expect(result, isNotNull);
          var location = result as Map<String, dynamic>;
          var range = location['range'] as Map<String, dynamic>;
          var start = range['start'] as Map<String, dynamic>;
          expect(location['uri'], Uri.file(profileModelPath).toString());
          // name is declared at line 3: "  name: String"
          expect(start['line'], 3);
          expect(start['character'], 2);
        },
      );

      test(
        'when references are requested for that field, '
        'then it returns occurrences in relations and declarations.',
        () async {
          // Line 3 in profile.spy.yaml: "  name: String" -> "name" is at
          // column 2
          var result = await session.requestReferences(
            profileModelPath,
            line: 3,
            character: 3,
            includeDeclaration: true,
          );

          expect(result, isNotNull);
          var locations = (result as List).cast<Map<String, dynamic>>();
          expect(locations, hasLength(2));

          // Declaration at line 3
          var decl = locations.firstWhere(
            (l) => ((l['range'] as Map)['start'] as Map)['line'] == 3,
          );
          expect(decl['uri'], Uri.file(profileModelPath).toString());

          // Relation reference at line 4, column 30
          var rel = locations.firstWhere(
            (l) => ((l['range'] as Map)['start'] as Map)['line'] == 4,
          );
          var relStart = (rel['range'] as Map)['start'] as Map;
          expect(rel['uri'], Uri.file(profileModelPath).toString());
          expect(relStart['character'], 30);
        },
      );
    },
  );

  group(
    'Given an initialized language server with a model that mentions another model in a comment,',
    () {
      late LanguageServerTestSession session;
      late String userModelPath;
      late String commentModelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.file('user.spy.yaml', '''
class: User
table: user
fields:
  name: String
'''),
              d.file('comment.spy.yaml', '''
class: Comment
table: comment
# The User class should not be matched inside comments
fields:
  text: String
  author: User
'''),
            ])
            .build()
            .create();

        var modelsDir = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
        );
        userModelPath = p.join(modelsDir, 'user.spy.yaml');
        commentModelPath = p.join(modelsDir, 'comment.spy.yaml');

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        session.sendInitialized();
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when references are requested for the mentioned model, '
        'then it returns the reference in the model file and excludes the match inside the comment.',
        () async {
          // Line 0 in user.spy.yaml: "class: User" -> "User" is at column 7
          var result = await session.requestReferences(
            userModelPath,
            line: 0,
            character: 8,
            includeDeclaration: false,
          );

          expect(result, isNotNull);
          var locations = (result as List).cast<Map<String, dynamic>>();
          expect(locations, hasLength(1));

          var ref = locations.first;
          expect(ref['uri'], Uri.file(commentModelPath).toString());
          var start = (ref['range'] as Map)['start'] as Map;
          // Line 5 in comment.spy.yaml: "  author: User" -> "User" is at
          // column 10; the mention in the comment at line 2 is excluded.
          expect(start['line'], 5);
          expect(start['character'], 10);
        },
      );
    },
  );

  group(
    'Given an initialized language server for a project with a module dependency,',
    () {
      late LanguageServerTestSession session;
      late String orderModelPath;
      late String moduleModelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.file('order.spy.yaml', '''
class: Order
table: order
fields:
  user: module:auth:UserInfo
'''),
            ])
            .withModule(
              'auth',
              modelDirContents: [
                d.file('user_info.spy.yaml', '''
class: UserInfo
table: user_info
fields:
  name: String
'''),
              ],
            )
            .build()
            .create();

        orderModelPath = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
          'order.spy.yaml',
        );
        moduleModelPath = p.join(
          d.sandbox,
          'project',
          'auth_server',
          'lib',
          'src',
          'models',
          'user_info.spy.yaml',
        );

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        session.sendInitialized();
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when definition is requested on a module-qualified model name, '
        'then it returns the location of the module model definition.',
        () async {
          // Line 3 in order.spy.yaml: "  user: module:auth:UserInfo"
          // "UserInfo" is at column 20
          var result = await session.requestDefinition(
            orderModelPath,
            line: 3,
            character: 21,
          );

          expect(result, isNotNull);
          var location = result as Map<String, dynamic>;
          var range = location['range'] as Map<String, dynamic>;
          var start = range['start'] as Map<String, dynamic>;
          expect(location['uri'], Uri.file(moduleModelPath).toString());
          expect(start['line'], 0);
          expect(start['character'], 7);
        },
      );

      test(
        'when a model definition is requested by module-qualified class name, '
        'then it returns the location of the module model definition.',
        () async {
          var result = await session.requestModelDefinition(
            'UserInfo',
            moduleAlias: 'auth',
          );

          expect(result, isNotNull);
          var location = result as Map<String, dynamic>;
          var range = location['range'] as Map<String, dynamic>;
          var start = range['start'] as Map<String, dynamic>;
          expect(location['uri'], Uri.file(moduleModelPath).toString());
          expect(start['line'], 0);
          expect(start['character'], 7);
        },
      );

      test(
        'when references are requested for a module model on its declaration line, '
        'then it returns module-qualified references in project model files.',
        () async {
          // Line 0 in user_info.spy.yaml: "class: UserInfo" -> "UserInfo" is
          // at column 7
          var result = await session.requestReferences(
            moduleModelPath,
            line: 0,
            character: 8,
            includeDeclaration: false,
          );

          expect(result, isNotNull);
          var locations = (result as List).cast<Map<String, dynamic>>();
          expect(locations, hasLength(1));

          var loc = locations.first;
          expect(loc['uri'], Uri.file(orderModelPath).toString());
          var range = loc['range'] as Map<String, dynamic>;
          var start = range['start'] as Map<String, dynamic>;
          var end = range['end'] as Map<String, dynamic>;
          expect(start['line'], 3);
          expect(start['character'], 20);
          expect(end['character'], 28);
        },
      );
    },
  );

  group('Given an initialized language server with linkSupport enabled,', () {
    late LanguageServerTestSession session;
    late String modelsDir;
    late String userModelPath;
    late String postModelPath;

    setUp(() async {
      await ProjectDirectoryBuilder().build().create();

      modelsDir = p.join(
        d.sandbox,
        'project',
        'my_project_server',
        'lib',
        'src',
        'models',
      );

      userModelPath = p.join(modelsDir, 'user.spy.yaml');
      postModelPath = p.join(modelsDir, 'post.spy.yaml');

      File(userModelPath).writeAsStringSync('''
class: User
table: user
fields:
  name: String
''');

      File(postModelPath).writeAsStringSync('''
class: Post
table: post
fields:
  title: String
  author: User?
''');

      session = LanguageServerTestSession();
      await session.initialize(
        Uri.directory(p.join(d.sandbox, 'project')),
        linkSupport: true,
      );
      session.sendInitialized();
    });

    tearDown(() async {
      await session.dispose();
    });

    test(
      'when definition is requested with linkSupport, '
      'then it returns a list containing LocationLink.',
      () async {
        // Line 4 in post.spy.yaml is: "  author: User?" -> "User" is at column 10
        var result = await session.requestDefinition(
          postModelPath,
          line: 4,
          character: 11,
        );

        expect(result, isNotNull);
        expect(result, isA<List>());
        var link = (result as List).first as Map<String, dynamic>;
        var targetSelectionRange =
            link['targetSelectionRange'] as Map<String, dynamic>;
        var targetStart = targetSelectionRange['start'] as Map<String, dynamic>;
        var originSelectionRange =
            link['originSelectionRange'] as Map<String, dynamic>;
        var originStart = originSelectionRange['start'] as Map<String, dynamic>;
        var originEnd = originSelectionRange['end'] as Map<String, dynamic>;

        expect(link['targetUri'], Uri.file(userModelPath).toString());
        expect(targetStart['line'], 0);
        expect(targetStart['character'], 7);
        expect(originStart['line'], 4);
        expect(originStart['character'], 10);
        expect(originEnd['character'], 14);
      },
    );
  });

  group(
    'Given an initialized language server with models whose table names and '
    'fields collide with the model file syntax,',
    () {
      late LanguageServerTestSession session;
      late String parameterModelPath;
      late String holderModelPath;
      late String ownerModelPath;

      setUp(() async {
        await ProjectDirectoryBuilder()
            .withModelDirContents([
              d.file('parameter.spy.yaml', '''
class: Parameter
table: parameters
fields:
  name: String
'''),
              d.file('holder.spy.yaml', '''
class: Holder
table: holder
fields:
  param: Parameter?, relation(parent=parameters)
'''),
              // An enum value that shares the name of a model.
              d.file('role.spy.yaml', '''
enum: Role
serialized: byName
values:
  - Parameter
  - guest
'''),
              // A model that shares the name of a foreign key action.
              d.file('cascade.spy.yaml', '''
class: Cascade
table: cascade
fields:
  name: String
'''),
              d.file('owner.spy.yaml', '''
class: Owner
table: owner
fields:
  item: Cascade?, relation(onDelete=CASCADE)
'''),
            ])
            .build()
            .create();

        var modelsDir = p.join(
          d.sandbox,
          'project',
          'my_project_server',
          'lib',
          'src',
          'models',
        );
        parameterModelPath = p.join(modelsDir, 'parameter.spy.yaml');
        holderModelPath = p.join(modelsDir, 'holder.spy.yaml');
        ownerModelPath = p.join(modelsDir, 'owner.spy.yaml');

        session = LanguageServerTestSession();
        await session.initialize(Uri.directory(p.join(d.sandbox, 'project')));
        session.sendInitialized();
      });

      tearDown(() async {
        await session.dispose();
      });

      test(
        'when definition is requested on a parent table name that is also a '
        'key of the model file syntax, '
        'then it returns the location of the model definition.',
        () async {
          // Line 3 in holder.spy.yaml:
          // "  param: Parameter?, relation(parent=parameters)"
          // -> "parameters" is at column 37
          var result = await session.requestDefinition(
            holderModelPath,
            line: 3,
            character: 40,
          );

          expect(result, isNotNull);
          var location = result as Map<String, dynamic>;
          var start = (location['range'] as Map)['start'] as Map;
          expect(location['uri'], Uri.file(parameterModelPath).toString());
          expect(start['line'], 0);
          expect(start['character'], 7);
        },
      );

      test(
        'when definition is requested on a foreign key action written in a '
        'different casing than a model that shares its name, '
        'then it returns null.',
        () async {
          // Line 3 in owner.spy.yaml:
          // "  item: Cascade?, relation(onDelete=CASCADE)"
          // -> "CASCADE" is at column 36
          var result = await session.requestDefinition(
            ownerModelPath,
            line: 3,
            character: 38,
          );

          expect(result, isNull);
        },
      );

      test(
        'when references are requested for a model that shares its name with '
        'an enum value, '
        'then the enum value is not reported as a reference.',
        () async {
          // Line 0 in parameter.spy.yaml: "class: Parameter"
          var result = await session.requestReferences(
            parameterModelPath,
            line: 0,
            character: 8,
            includeDeclaration: false,
          );

          var locations = (result as List).cast<Map<String, dynamic>>();
          expect(
            locations.map((loc) => loc['uri']),
            isNot(contains(contains('role.spy.yaml'))),
          );
          expect(
            locations.map((loc) => loc['uri']),
            everyElement(Uri.file(holderModelPath).toString()),
          );
        },
      );
    },
  );
}
