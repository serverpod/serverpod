import 'dart:io';

import 'package:args/args.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/database/copy_migrations.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/generator/generator.dart';
import 'package:serverpod_cli/src/generator/generator_continuous.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/serverpod_packages_version_check/serverpod_packages_version_check.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

class GenerateCommand extends ServerpodCommand {
  @override
  final name = 'generate';
  @override
  final description = 'Generate code from yaml files for server and clients.';

  GenerateCommand() {
    argParser.addFlag(
      'watch',
      abbr: 'w',
      defaultsTo: false,
      negatable: false,
      help: 'Watch for changes and continuously generate code.',
    );
    argParser.addFlag(
      'experimental-open-api',
      defaultsTo: false,
      negatable: false,
      help: 'Generate OpenAPI schema.',
    );
    argParser.addFlag(
      'version',
      defaultsTo: false,
      negatable: false,
      help: 'Specified the version of the OpenAPI document.',
    );
  }

  @override
  Future<void> run() async {
    // Always do a full generate.
    bool watch = argResults!['watch'];
    // Whether to generate an OpenAPI schema or not.
    bool generateOpenAPI = argResults!['experimental-open-api'];
    // whether an OpenAPI document version is specified or not.
    bool hasOpenAPIdocumentVersion = argResults!['version'];

    // TODO: add a -d option to select the directory
    var config = await GeneratorConfig.load(
      '',
      hasOpenAPIdocumentVersion ? _getOpenAPIDocumentVersion(argResults!) : '',
    );

    if (config == null) {
      throw ExitException(ExitCodeType.commandInvokedCannotExecute);
    }

    // Validate cli version is compatible with serverpod packages
    var warnings = performServerpodPackagesAndCliVersionCheck(
        Version.parse(templateVersion), Directory.current.parent);
    if (warnings.isNotEmpty) {
      log.warning(
        'The version of the CLI may be incompatible with the Serverpod '
        'packages used in your project.',
      );
      for (var warning in warnings) {
        log.sourceSpanException(warning);
      }
    }

    // Copy migrations from modules.
    await copyMigrations(config);

    var endpointsAnalyzer = EndpointsAnalyzer(config);
    Set<CodeOutputFormats> codeOutputFormats = {
      CodeOutputFormats.dart,
    };
    if (generateOpenAPI) {
      codeOutputFormats.add(CodeOutputFormats.openAPI);
    }
    bool success = await log.progress(
      'Generating code',
      () => performGenerate(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
        codeOutputFormats: codeOutputFormats,
      ),
    );
    if (watch) {
      log.info('Initial code generation complete. Listening for changes.');
      success = await performGenerateContinuously(
        config: config,
        endpointsAnalyzer: endpointsAnalyzer,
      );
    } else if (success) {
      log.info('Done.', type: TextLogType.success);
    }

    if (!success) {
      throw ExitException();
    }
  }

  String _getOpenAPIDocumentVersion(ArgResults argResult) {
    var versionFlagIndex = argResult.arguments.indexOf('--version');
    if (versionFlagIndex != -1 &&
        versionFlagIndex + 1 < argResult.arguments.length) {
      var versionValue = argResult.arguments[versionFlagIndex + 1];
      return versionValue;
    }
    return '';
  }
}
