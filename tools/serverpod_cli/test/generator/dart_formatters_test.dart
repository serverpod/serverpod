import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../test_util/builders/generator_config_builder.dart';

void main() {
  late Directory tempDirectory;
  late Directory serverDirectory;
  late _WarningCapturingLogger logger;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'dart_formatters_test_',
    );

    serverDirectory = Directory(
      p.join(tempDirectory.path, 'example_server'),
    );
    await serverDirectory.create(recursive: true);

    logger = _WarningCapturingLogger();
    initializeLoggerWith(logger);
  });

  tearDown(() async {
    GeneratedDartFormatters.reset();
    await tempDirectory.delete(recursive: true);
  });

  tearDownAll(closeLogger);

  test(
    'Given a target package using Dart 3.12, '
    'when its generated-code formatters are resolved, '
    'then they use the target package language version.',
    () async {
      final dartToolDirectory = Directory(
        p.join(serverDirectory.path, '.dart_tool'),
      );
      await dartToolDirectory.create(recursive: true);
      await File(
        p.join(dartToolDirectory.path, 'package_config.json'),
      ).writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "example_server",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    }
  ]
}
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.languageVersion, Version(3, 12, 0));
    },
  );

  test(
    'Given a target package preserving trailing commas, '
    'when its generated-code formatters are resolved, '
    'then they capture the target trailing-comma setting.',
    () async {
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  trailing_commas: preserve
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.trailingCommas, TrailingCommas.preserve);
    },
  );

  test(
    'Given a target package with page width 120, '
    'when its generated-code formatters are resolved, '
    'then they capture the target page width.',
    () async {
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  page_width: 120
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.pageWidth, 120);
    },
  );

  test(
    'Given a client package with page width 120, '
    'when its client migration formatters are resolved, '
    'then they capture the target page width.',
    () async {
      final clientDirectory = Directory(
        p.join(tempDirectory.path, 'example_client'),
      );
      await clientDirectory.create(recursive: true);
      await File(
        p.join(clientDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  page_width: 120
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .withRelativeDartClientPackagePathParts(['..', 'example_client'])
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll([
          ...config.clientPackagePathParts,
          'lib',
          'migrations',
          'migration_registry.dart',
        ]),
      );

      expect(formatter.pageWidth, 120);
    },
  );

  test(
    'Given a target package with an invalid trailing-comma analysis options setting, '
    'when its generated-code formatters are resolved, '
    'then the formatter warning is logged instead of written to stderr.',
    () async {
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
formatter:
  trailing_commas: not_a_valid_setting
''');
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      // Stands in for the real stderr, which the TUI owns.
      final outerStderr = _RecordingStdout();
      await IOOverrides.runZoned(
        () => GeneratedDartFormatters.resolve(config),
        stderr: () => outerStderr,
      );

      expect(
        outerStderr.text,
        isEmpty,
        reason: 'dart_style must not write to stderr itself.',
      );
      expect(
        logger.warnings.single,
        contains('Warning: "trailing_commas" option'),
      );
    },
  );

  test(
    'Given a target package whose analysis options include a package URI, '
    'when its generated-code formatters are resolved before the output directory exists, '
    'then they capture the target formatter settings and report no resolution error.',
    () async {
      // Stands in for `package:lints`, which the project templates include.
      final lintsDirectory = Directory(
        p.join(tempDirectory.path, 'example_lints', 'lib'),
      );
      await lintsDirectory.create(recursive: true);
      await File(
        p.join(lintsDirectory.path, 'recommended.yaml'),
      ).writeAsString('''
linter:
  rules:
    - camel_case_types
''');

      final dartToolDirectory = Directory(
        p.join(serverDirectory.path, '.dart_tool'),
      );
      await dartToolDirectory.create(recursive: true);
      await File(
        p.join(dartToolDirectory.path, 'package_config.json'),
      ).writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "example_server",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    },
    {
      "name": "example_lints",
      "rootUri": "../../example_lints",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    }
  ]
}
''');
      await File(
        p.join(serverDirectory.path, 'analysis_options.yaml'),
      ).writeAsString('''
include: package:example_lints/recommended.yaml

formatter:
  page_width: 120
  trailing_commas: preserve
''');

      // The generated output directory is deliberately left uncreated: it does
      // not exist until the first generation run writes to it, and resolving
      // the include from a directory that does not exist fails.
      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .build();

      await GeneratedDartFormatters.resolve(config);

      final formatter = GeneratedDartFormatters.of(
        p.joinAll(config.generatedServerProtocolFilePathParts),
      );

      expect(formatter.pageWidth, 120);
      expect(formatter.trailingCommas, TrailingCommas.preserve);
      expect(
        logger.warnings,
        isEmpty,
        reason: 'The include resolves, so dart_style reports no error.',
      );
    },
  );

  test(
    'Given a client package using Dart 3.12 whose generated protocol directory cannot be checked for existence, '
    'when its generated-code formatters are resolved, '
    'then they use the client package language version.',
    () async {
      final clientDirectory = Directory(
        p.join(tempDirectory.path, 'example_client'),
      );
      final clientDartToolDirectory = Directory(
        p.join(clientDirectory.path, '.dart_tool'),
      );
      await clientDartToolDirectory.create(recursive: true);
      await File(
        p.join(clientDartToolDirectory.path, 'package_config.json'),
      ).writeAsString('''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "example_client",
      "rootUri": "../",
      "packageUri": "lib/",
      "languageVersion": "3.12"
    }
  ]
}
''');
      final libDirectory = Directory(p.join(clientDirectory.path, 'lib'));
      await Directory(p.join(libDirectory.path, 'src')).create(recursive: true);

      if (!await _makeUnsearchable(libDirectory)) {
        markTestSkipped(
          'Directory.exists() cannot be made to fail on this platform.',
        );
        return;
      }
      addTearDown(() => Process.run('chmod', ['755', libDirectory.path]));

      final config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(p.split(serverDirectory.path))
          .withRelativeDartClientPackagePathParts(['..', 'example_client'])
          .build();

      await GeneratedDartFormatters.resolve(config);

      // The language version is only found if the walk up out of the
      // unreadable output directory stops inside the client package.
      final formatter = GeneratedDartFormatters.of(
        p.joinAll([
          ...config.generatedDartClientModelPathParts,
          'protocol.dart',
        ]),
      );

      expect(formatter.languageVersion, Version(3, 12, 0));
    },
  );
}

/// Makes [directory] unsearchable, so that `Directory.exists()` on the paths
/// below it fails with a [PathAccessException] instead of returning `false`.
///
/// This is how Windows reports a directory that is pending deletion, which the
/// generated output directory can be when one generation run follows another.
/// Returns `false`, leaving [directory] untouched, where that cannot be
/// arranged: on Windows, or when running as a user that bypasses permission
/// checks.
///
/// It is the only reliable way to test the behavior, because a delete-pending
/// directory is inherently a race condition and can't be reliably reproduced.
Future<bool> _makeUnsearchable(Directory directory) async {
  if (Platform.isWindows) return false;

  await Process.run('chmod', ['000', directory.path]);
  try {
    await Directory(p.join(directory.path, 'probe')).exists();
  } on PathAccessException {
    return true;
  }

  await Process.run('chmod', ['755', directory.path]);
  return false;
}

/// A logger that records the debug messages it is given and prints nothing.
class _WarningCapturingLogger extends VoidLogger {
  final List<String> warnings = [];

  @override
  void warning(String message, {bool newParagraph = false, LogType? type}) {
    warnings.add(message);
  }
}

/// A [Stdout] that records everything written to it in memory.
class _RecordingStdout implements Stdout {
  final StringBuffer _buffer = StringBuffer();

  String get text => _buffer.toString();

  @override
  Encoding encoding = utf8;

  @override
  void write(Object? object) => _buffer.write(object);

  @override
  void writeln([Object? object = '']) => _buffer.writeln(object);

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) =>
      _buffer.writeAll(objects, separator);

  @override
  void writeCharCode(int charCode) => _buffer.writeCharCode(charCode);

  @override
  void add(List<int> data) => _buffer.write(encoding.decode(data));

  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> get done => Future.value();

  @override
  IOSink get nonBlocking => this;

  @override
  bool get hasTerminal => false;

  @override
  bool get supportsAnsiEscapes => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
