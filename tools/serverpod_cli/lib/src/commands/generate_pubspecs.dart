import 'package:config/command.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';

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
  ),
  ;

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
  void run(CommandContext<GeneratePubspecsOption, void> context) {
    var version = context.config.value(GeneratePubspecsOption.version);
    var dartVersion = context.config.value(GeneratePubspecsOption.dartVersion);
    var flutterVersion = context.config.value(
      GeneratePubspecsOption.flutterVersion,
    );
    var mode = context.config.value(GeneratePubspecsOption.mode);

    performGeneratePubspecs(
      version: version,
      dartVersion: dartVersion,
      flutterVersion: flutterVersion,
      mode: mode,
    );
  }
}
