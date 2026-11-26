import 'package:config/config.dart';

/// Resolves [options] from [args] the way a command used to resolve its own
/// parser results.
///
/// [passThroughRest] keeps words after `--`, which the runner accepts for the
/// commands that forward them.
Configuration<O> resolveCommandConfig<O extends OptionDefinition>(
  List<O> options,
  List<String> args, {
  bool passThroughRest = false,
}) {
  if (!passThroughRest) {
    return Configuration.resolveNoExcept(
      options: options,
      args: args,
    );
  }

  final parsed = scanAndParseArgs(
    args,
    options: options,
    settings: const ParserSettings(
      doubleDashHandling: DoubleDashHandling.passThroughRest,
    ),
  );
  return Configuration.resolveNoExcept(
    options: options,
    parsedArgs: NewParsedArgs(parsed),
    ignoreUnexpectedPositionalArgs: true,
  );
}
