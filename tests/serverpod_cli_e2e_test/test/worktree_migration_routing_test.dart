@Timeout(Duration(minutes: 12))
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/copy_directory.dart';
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:uuid/uuid.dart';

void main() async {
  late String firstServerDir;
  late String secondServerDir;

  setUpAll(() async {
    var projectName =
        'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';
    var result = await runServerpod(
      ['create', projectName, '--template', 'server', '--no-interactive'],
      workingDirectory: d.sandbox,
    );
    expect(result.exitCode, 0, reason: 'Failed to create the project.');

    var firstProject = path.join(d.sandbox, projectName);
    var secondProject = path.join(d.sandbox, '${projectName}_wt2');
    firstServerDir = path.join(firstProject, '${projectName}_server');
    secondServerDir = path.join(secondProject, '${projectName}_server');
    copyDirectory(Directory(firstProject), Directory(secondProject));
  });

  group(
    'Given two worktrees of a project configured for the same ports, '
    'the second holding a migration the first lacks, '
    'with both runners up,',
    () {
      setUp(() async {
        var [api, insights, web, firstDatabase, secondDatabase] =
            await _freePorts(5);
        _configurePorts(
          firstServerDir,
          api: api,
          insights: insights,
          web: web,
          database: firstDatabase,
        );
        _configurePorts(
          secondServerDir,
          api: api,
          insights: insights,
          web: web,
          database: secondDatabase,
        );

        File(
            path.join(
              secondServerDir,
              'lib',
              'src',
              'models',
              'only_here.spy.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: OnlyHere
table: only_here
fields:
  name: String
''');
        var migration = await runServerpod(
          ['create-migration', '--force'],
          workingDirectory: secondServerDir,
        );
        expect(
          migration.exitCode,
          0,
          reason: '${migration.stdout}${migration.stderr}',
        );

        for (var serverDir in [firstServerDir, secondServerDir]) {
          var started = await runServerpod(
            ['start', '--no-watch', '--no-attach', '--no-docker'],
            workingDirectory: serverDir,
          );
          expect(
            started.exitCode,
            0,
            reason:
                'Runner did not come up:\n${started.stdout}${started.stderr}',
          );
        }
      });

      tearDown(() async {
        await Future.wait([
          stopRunner(firstServerDir),
          stopRunner(secondServerDir),
        ]);
      });

      test(
        'when a repair migration is created in the second worktree, '
        'then it reads the second database, which has no drift',
        () async {
          var result = await runServerpod(
            ['create-repair-migration'],
            workingDirectory: secondServerDir,
          );

          var output = '${result.stdout}${result.stderr}';
          expect(output, contains('No changes detected'), reason: output);
          expect(output, isNot(contains('Repair migration created')));
        },
      );
    },
  );
}

/// Ports nothing listens on right now.
Future<List<int>> _freePorts(int count) async {
  var sockets = [
    for (var i = 0; i < count; i++)
      await ServerSocket.bind(InternetAddress.loopbackIPv4, 0),
  ];
  var ports = [for (var socket in sockets) socket.port];
  for (var socket in sockets) {
    await socket.close();
  }
  return ports;
}

/// Replaces the template ports in the development config of [serverDir].
void _configurePorts(
  String serverDir, {
  required int api,
  required int insights,
  required int web,
  required int database,
}) {
  var config = File(path.join(serverDir, 'config', 'development.yaml'));
  var content = config.readAsStringSync();
  for (var MapEntry(key: template, value: port) in {
    8080: api,
    8081: insights,
    8082: web,
    8090: database,
  }.entries) {
    content = content.replaceAll('port: $template', 'port: $port');
  }
  config.writeAsStringSync(content);
}
