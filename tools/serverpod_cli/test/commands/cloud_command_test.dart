import 'package:cli_tools/cli_tools.dart';
import 'package:config/command.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../test_util/resolve_command_config.dart';

typedef _Launch = ({List<String> args, Map<String, String> environment});

/// Records each launch and exits with the next code from [exitCodes].
class _FakeScloud {
  final List<int> exitCodes;
  final List<_Launch> launches = [];
  int installs = 0;
  ExitException? installError;

  _FakeScloud(this.exitCodes);

  Future<int> start(
    List<String> args, {
    required Map<String, String> environment,
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

class _SilentAnalytics extends Analytics {
  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {}
}

typedef _CompletionCall = ({
  String executable,
  List<String> words,
  Map<String, String>? environment,
});

/// Records each completion request and answers with a deploy candidate.
class _RecordingCompletion {
  final List<_CompletionCall> calls = [];

  Future<CompletionResponse> call(
    String executable,
    List<String> words, {
    Map<String, String>? environment,
  }) async {
    calls.add((
      executable: executable,
      words: words,
      environment: environment,
    ));
    return const CompletionResponse(
      [CompletionCandidate('deploy', description: 'Deploy a project')],
      directive: CompletionDirective.noFileCompletion,
    );
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
        final config = resolveCommandConfig(command.options, []);

        expect(config.errors, isEmpty);
      },
    );

    group('when splitting a cloud invocation, ', () {
      test('then the words after cloud are forwarded to scloud', () {
        final split = splitCloudInvocation([
          'cloud',
          'deploy',
          '--project',
          'my-project',
        ]);

        expect(split?.cloudArgs, ['deploy', '--project', 'my-project']);
        expect(split?.runnerArgs, ['cloud']);
      });

      test('then global options before cloud stay on the runner', () {
        final split = splitCloudInvocation([
          '--verbose',
          'cloud',
          '--help',
        ]);

        expect(split?.runnerArgs, ['--verbose', 'cloud']);
        expect(split?.cloudArgs, ['--help']);
      });

      test('then a completion request is left intact for the runner', () {
        expect(
          splitCloudInvocation(['__complete', '--verbose', 'cloud', 'deploy']),
          isNull,
        );
      });
    });
  });

  group('Given shell completion of serverpod cloud', () {
    late _RecordingCompletion completion;
    late ServerpodCommandRunner runner;

    setUp(() {
      completion = _RecordingCompletion();
      runner =
          ServerpodCommandRunner.createCommandRunner(
            _SilentAnalytics(),
            false,
            Version(1, 1, 0),
            preCommandHooks: false,
          )..addCommand(
            CloudCommand(requestCompletion: completion.call),
          );
    });

    Future<CompletionResponse> complete(List<String> words) {
      return CompletionEngine<GlobalOption, void>(
        runner,
        resolver: runner.resolver,
        parserSettings: runner.parserSettings,
      ).complete(words);
    }

    test(
      'when a word after cloud is completed, '
      'then scloud is asked for that word and its answer is returned',
      () async {
        final response = await complete(['cloud', 'de']);

        expect(completion.calls, hasLength(1));
        expect(completion.calls.single.executable, getScloudExecutablePath());
        expect(completion.calls.single.words, ['de']);
        expect(completion.calls.single.environment, {
          ScloudEnvironment.baseCommand: scloudBaseCommand,
        });
        expect(response.candidates, [
          const CompletionCandidate(
            'deploy',
            description: 'Deploy a project',
          ),
        ]);
        expect(response.directive, CompletionDirective.noFileCompletion);
      },
    );

    test(
      'when words after cloud include options, '
      'then those words are forwarded to scloud',
      () async {
        await complete(['cloud', 'deploy', '--project', 'my']);

        expect(completion.calls.single.words, [
          'deploy',
          '--project',
          'my',
        ]);
      },
    );

    test(
      'when a global option precedes cloud, '
      'then it is not forwarded to scloud',
      () async {
        await complete(['--verbose', 'cloud', '']);

        expect(completion.calls.single.words, ['']);
      },
    );

    test(
      'when the cloud command name itself is completed, '
      'then scloud is not asked',
      () async {
        final response = await complete(['clo']);

        expect(completion.calls, isEmpty);
        expect(
          response.candidates.map((candidate) => candidate.value),
          contains('cloud'),
        );
      },
    );
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
