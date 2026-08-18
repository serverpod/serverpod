import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';

/// Guards against the generated `Serverpod` subclass drifting from the
/// framework's `Serverpod` constructor: a named parameter added to the
/// framework without updating `generateServerpodClass` would silently not be
/// forwarded, since the subclass re-declares every parameter.
void main() {
  var frameworkSourcePath = path.join(
    '..',
    '..',
    'packages',
    'serverpod',
    'lib',
    'src',
    'server',
    'serverpod.dart',
  );

  test(
    'Given the framework Serverpod constructor when comparing with the '
    'generated Serverpod subclass then all named parameters are declared and '
    'forwarded.',
    () {
      var frameworkFile = File(frameworkSourcePath);
      if (!frameworkFile.existsSync()) {
        markTestSkipped(
          'Framework source not found at $frameworkSourcePath; '
          'this test only runs in the Serverpod mono-repo.',
        );
        return;
      }

      var frameworkConstructor = _unnamedConstructorOfClass(
        parseString(content: frameworkFile.readAsStringSync()).unit,
        'Serverpod',
      );
      var frameworkParameters = _namedParameterNames(frameworkConstructor);

      var config = GeneratorConfigBuilder().withName('example_project').build();
      var codeMap = const DartServerCodeGenerator().generateProtocolCode(
        protocolDefinition: const ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        ),
        config: config,
      );
      var generatedFile =
          codeMap[path.join('lib', 'src', 'generated', 'serverpod.dart')]!;

      var generatedConstructor = _unnamedConstructorOfClass(
        parseString(content: generatedFile).unit,
        'Serverpod',
      );
      var generatedParameters = _namedParameterNames(generatedConstructor);
      var forwardedParameters = generatedConstructor.initializers
          .whereType<SuperConstructorInvocation>()
          .single
          .argumentList
          .arguments
          .whereType<NamedExpression>()
          .map((argument) => argument.name.label.name)
          .toSet();

      const outOfSyncReason =
          'The framework Serverpod constructor and the generated Serverpod '
          'subclass are out of sync. Update generateServerpodClass in '
          'lib/src/generator/dart/library_generators/'
          'serverpod_library_generator.dart.';

      expect(generatedParameters, frameworkParameters, reason: outOfSyncReason);
      expect(forwardedParameters, frameworkParameters, reason: outOfSyncReason);
    },
  );
}

ConstructorDeclaration _unnamedConstructorOfClass(
  CompilationUnit unit,
  String className,
) {
  // The replacements (namePart, body) only exist in analyzer 10+, and the
  // pubspec range starts at 8.1.0 (exercised by the CI downgrade legs).
  return unit.declarations
      .whereType<ClassDeclaration>()
      // ignore: deprecated_member_use
      .singleWhere((declaration) => declaration.name.lexeme == className)
      // ignore: deprecated_member_use
      .members
      .whereType<ConstructorDeclaration>()
      .singleWhere((constructor) => constructor.name == null);
}

Set<String> _namedParameterNames(ConstructorDeclaration constructor) {
  return constructor.parameters.parameters
      .where((parameter) => parameter.isNamed)
      .map((parameter) => parameter.name!.lexeme)
      .toSet();
}
