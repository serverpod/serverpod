import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

typedef _Launch = ({List<String> args, Map<String, String> environment});

/// Records each launch and exits with the next code from [exitCodes].
class _FakeScloud {
  final List<int> exitCodes;
  final List<_Launch> launches = [];
  int installs = 0;
  ExitException? installError;

  _FakeScloud(this.exitCodes);

  Future<int> start(
    final List<String> args, {
    required final Map<String, String> environment,
  }) async {
    launches.add((args: args, environment: environment));
    return exitCodes[launches.length - 1];
  }

  Future<void> install() async {
    installs++;
    final error = installError;
    if (error != null) throw error;
  }
}

void main() {
  group('Given a CloudCommand', () {
    late CloudCommand command;

    setUp(() {
      command = CloudCommand();
    });

    tearDownAll(closeLogger);

    test(
      'when parsing configuration with no args, '
      'then there are no errors',
      () {
        final argResults = command.argParser.parse([]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      },
    );

    group('when parsing configuration with scloud args, ', () {
      late final argResults = command.argParser.parse([
        'deploy',
        '--project',
        'my-project',
      ]);

      test('then there are no errors', () {
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      });

      test('then args are forwarded via argResults.rest', () {
        expect(argResults.rest, ['deploy', '--project', 'my-project']);
      });
    });
  });

  group('Given scloud that exits successfully when run', () {
    late _FakeScloud scloud;
    late int exitCode;

    setUp(() async {
      scloud = _FakeScloud([0]);
      exitCode = await runScloud(
        ['deploy', '--project', 'my-project'],
        start: scloud.start,
        install: scloud.install,
      );
    });

    test('then the exit code is returned', () {
      expect(exitCode, 0);
    });

    test('then scloud is launched once', () {
      expect(scloud.launches, hasLength(1));
    });

    test('then the args are forwarded unchanged', () {
      expect(scloud.launches.single.args, [
        'deploy',
        '--project',
        'my-project',
      ]);
    });

    test('then the base command is set to serverpod cloud', () {
      expect(
        scloud.launches.single.environment[ScloudEnvironment.baseCommand],
        'serverpod cloud',
      );
    });

    test('then scloud is asked to exit on updated', () {
      expect(
        scloud.launches.single.environment[ScloudEnvironment.exitOnUpdated],
        'true',
      );
    });

    test('then scloud is not installed', () {
      expect(scloud.installs, 0);
    });
  });

  group('Given scloud that exits with an unrelated error when run', () {
    late _FakeScloud scloud;
    late int exitCode;

    setUp(() async {
      scloud = _FakeScloud([1]);
      exitCode = await runScloud(
        ['deploy'],
        start: scloud.start,
        install: scloud.install,
      );
    });

    test('then the exit code is returned', () {
      expect(exitCode, 1);
    });

    test('then scloud is not relaunched', () {
      expect(scloud.launches, hasLength(1));
    });

    test('then scloud is not installed', () {
      expect(scloud.installs, 0);
    });
  });

  group(
    'Given scloud that updated itself and succeeds on relaunch when run',
    () {
      late _FakeScloud scloud;
      late int exitCode;

      setUp(() async {
        scloud = _FakeScloud([ScloudExitCode.updatedRerunRequired, 0]);
        exitCode = await runScloud(
          ['deploy', '--project', 'my-project'],
          start: scloud.start,
          install: scloud.install,
        );
      });

      test('then the relaunch exit code is returned', () {
        expect(exitCode, 0);
      });

      test('then scloud is relaunched once', () {
        expect(scloud.launches, hasLength(2));
      });

      test('then scloud is not installed', () {
        expect(scloud.installs, 0);
      });

      test('then the relaunch forwards the same args', () {
        expect(scloud.launches[1].args, ['deploy', '--project', 'my-project']);
      });

      test('then the relaunch keeps the base command', () {
        expect(
          scloud.launches[1].environment[ScloudEnvironment.baseCommand],
          'serverpod cloud',
        );
      });

      test('then the relaunch is not asked to exit on updated', () {
        expect(
          scloud.launches[1].environment,
          isNot(contains(ScloudEnvironment.exitOnUpdated)),
        );
      });
    },
  );

  group('Given scloud that updated itself and fails on relaunch when run', () {
    late _FakeScloud scloud;
    late int exitCode;

    setUp(() async {
      scloud = _FakeScloud([ScloudExitCode.updatedRerunRequired, 1]);
      exitCode = await runScloud(
        ['deploy'],
        start: scloud.start,
        install: scloud.install,
      );
    });

    test('then the relaunch exit code is returned', () {
      expect(exitCode, 1);
    });

    test('then scloud is relaunched once', () {
      expect(scloud.launches, hasLength(2));
    });
  });

  group('Given scloud that updated itself and updates again on relaunch '
      'when run', () {
    late _FakeScloud scloud;
    late int exitCode;

    setUp(() async {
      scloud = _FakeScloud([
        ScloudExitCode.updatedRerunRequired,
        ScloudExitCode.updatedRerunRequired,
      ]);
      exitCode = await runScloud(
        ['deploy'],
        start: scloud.start,
        install: scloud.install,
      );
    });

    test('then the relaunch exit code is returned', () {
      expect(exitCode, ScloudExitCode.updatedRerunRequired);
    });

    test('then scloud is not relaunched again', () {
      expect(scloud.launches, hasLength(2));
    });
  });

  group('Given scloud that could not update itself and a successful install '
      'when run', () {
    late _FakeScloud scloud;
    late int exitCode;

    setUp(() async {
      scloud = _FakeScloud([ScloudExitCode.updateRequired, 0]);
      exitCode = await runScloud(
        ['deploy', '--project', 'my-project'],
        start: scloud.start,
        install: scloud.install,
      );
    });

    test('then the relaunch exit code is returned', () {
      expect(exitCode, 0);
    });

    test('then scloud is installed once', () {
      expect(scloud.installs, 1);
    });

    test('then scloud is relaunched once', () {
      expect(scloud.launches, hasLength(2));
    });

    test('then the relaunch forwards the same args', () {
      expect(scloud.launches[1].args, ['deploy', '--project', 'my-project']);
    });

    test('then the relaunch keeps the base command', () {
      expect(
        scloud.launches[1].environment[ScloudEnvironment.baseCommand],
        'serverpod cloud',
      );
    });

    test('then the relaunch is not asked to exit on updated', () {
      expect(
        scloud.launches[1].environment,
        isNot(contains(ScloudEnvironment.exitOnUpdated)),
      );
    });
  });

  group('Given scloud that could not update itself and a failing install', () {
    late _FakeScloud scloud;

    setUp(() {
      scloud = _FakeScloud([ScloudExitCode.updateRequired, 0]);
      scloud.installError = ExitException(126);
    });

    test('when run then the install error is thrown', () async {
      await expectLater(
        runScloud(['deploy'], start: scloud.start, install: scloud.install),
        throwsA(
          isA<ExitException>().having((e) => e.exitCode, 'exitCode', 126),
        ),
      );
    });

    test('when run then scloud is not relaunched', () async {
      await runScloud(
        ['deploy'],
        start: scloud.start,
        install: scloud.install,
      ).catchError((_) => 0);

      expect(scloud.launches, hasLength(1));
    });
  });

  group(
    'Given scloud that still needs an update after the install when run',
    () {
      late _FakeScloud scloud;
      late int exitCode;

      setUp(() async {
        scloud = _FakeScloud([
          ScloudExitCode.updateRequired,
          ScloudExitCode.updateRequired,
        ]);
        exitCode = await runScloud(
          ['deploy'],
          start: scloud.start,
          install: scloud.install,
        );
      });

      test('then the relaunch exit code is returned', () {
        expect(exitCode, ScloudExitCode.updateRequired);
      });

      test('then scloud is installed once', () {
        expect(scloud.installs, 1);
      });

      test('then scloud is not relaunched again', () {
        expect(scloud.launches, hasLength(2));
      });
    },
  );
}
