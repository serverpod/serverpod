import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/logger/loggers/void_logger.dart';
import 'package:test/test.dart';

class TestLogger extends VoidLogger {
  final List<String> _errorLogs = [];

  void clearLogs() {
    _errorLogs.clear();
  }

  List<String> get errorLogs => _errorLogs;

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = const RawLogType(),
  }) {
    _errorLogs.add(message);
  }
}

void main() {
  var testAssetsPath = p.join('test', 'migrations', 'test_assets');

  setUpAll(() => initializeLoggerWith(TestLogger()));
  setUp(() => (log as TestLogger).clearLogs());

  group('Given a latest version migration folder that is empty', () {
    var projectDirectory = Directory(p.join(testAssetsPath, 'empty_migration'));
    var projectName = 'test_project';
    var generator = MigrationGenerator(
      directory: projectDirectory,
      projectName: projectName,
    );

    group('when creating migration', () {
      test('then null is returned.', () async {
        var migration = await generator.createMigration(
          force: false,
          priority: 0,
        );

        expect(migration, isNull);
      });

      test('then expected error messages are logged.', () async {
        await generator.createMigration(force: false, priority: 0);

        var logs = (log as TestLogger).errorLogs;

        expect(logs, hasLength(2));
        expect(
          logs.first,
          startsWith(
              'Unable to determine latest database definition due to a corrupted'),
        );
        expect(
          logs.first,
          endsWith('Migration version: "00000000000000".'),
        );
        expect(
          logs.last,
          startsWith('PathNotFoundException: Cannot open file'),
        );
      });
    });

    group('when creating repair migration', () {
      test('then null is returned.', () async {
        var repairSql = await generator.repairMigration(
          runMode: CreateMigrationCommand.runModes.first /* development */,
          force: false,
        );
        expect(repairSql, isNull);
      });

      test('then expected error message is logged.', () async {
        await generator.repairMigration(
          runMode: CreateMigrationCommand.runModes.first /* development */,
          force: false,
        );

        var logs = (log as TestLogger).errorLogs;

        expect(logs, hasLength(2));
        expect(
          logs.first,
          startsWith(
              'Unable to determine latest database definition due to a corrupted'),
        );
        expect(
          logs.first,
          endsWith(
              'Migration version: "00000000000000" for module "test_project".'),
        );
        expect(
          logs.last,
          startsWith('PathNotFoundException: Cannot open file'),
        );
      });
    });
  });
}
