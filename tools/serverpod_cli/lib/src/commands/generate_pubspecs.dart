import 'dart:async';

import 'package:config/config.dart';
import 'package:serverpod_cli/src/analytics/analytics_helper.dart';
import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

enum GeneratePubspecsOption<V> implements OptionDefinition<V> {
  version(
    StringOption(
      argName: 'version',
      mandatory: true,
    ),
  ),
  dartVersion(
    StringOption(
      argName: 'dart-version',
      mandatory: true,
    ),
  ),
  flutterVersion(
    StringOption(
      argName: 'flutter-version',
      mandatory: true,
    ),
  ),
  mode(
    StringOption(
      argName: 'mode',
      defaultsTo: 'development',
      allowedValues: ['development', 'production'],
    ),
  );

  const GeneratePubspecsOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class GeneratePubspecsCommand extends ServerpodCommand<GeneratePubspecsOption> {
  @override
  final name = 'generate-pubspecs';

  @override
  final description = '';

  @override
  bool get hidden => true;

  GeneratePubspecsCommand() : super(options: GeneratePubspecsOption.values);

  @override
  FutureOr<void>? runWithConfig(
    Configuration<GeneratePubspecsOption> commandConfig,
  ) {
    var version = commandConfig.value(GeneratePubspecsOption.version);
    var dartVersion = commandConfig.value(GeneratePubspecsOption.dartVersion);
    var flutterVersion = commandConfig.value(
      GeneratePubspecsOption.flutterVersion,
    );
    var mode = commandConfig.value(GeneratePubspecsOption.mode);

    // Build full command string for tracking
    final fullCommandParts = [
      'serverpod',
      'generate-pubspecs',
      '--version',
      version,
      '--dart-version',
      dartVersion,
      '--flutter-version',
      flutterVersion,
    ];
    if (mode != 'development') {
      fullCommandParts.add('--mode');
      fullCommandParts.add(mode);
    }
    final fullCommand = fullCommandParts.join(' ');

    performGeneratePubspecs(
      version: version,
      dartVersion: dartVersion,
      flutterVersion: flutterVersion,
      mode: mode,
    );

    // Track the event
    serverpodRunner.analytics.trackWithProperties(
      event: 'cli:pubspecs_generated',
      properties: {
        'full_command': fullCommand,
        'command': 'generate-pubspecs',
        'version': version,
        'dart_version': dartVersion,
        'flutter_version': flutterVersion,
        'mode': mode,
      },
    );
  }
}
