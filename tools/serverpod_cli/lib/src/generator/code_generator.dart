import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart_formatters.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// A code generator is responsible for generating the code for the target
/// language.
abstract class CodeGenerator {
  /// Create a new [CodeGenerator].
  const CodeGenerator();

  /// Generates the content of files that only depend the [SerializableModel].
  ///
  /// Returns a map where they key is the path of the file and the value is
  /// the file's content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// Called and generated before [generateProtocolCode].
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  });

  /// Generate the content of files that depend on the entire
  /// [ProtocolDefinition].
  ///
  /// Returns a map where they key is the path of the file and the value is
  /// the file's content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// At the time this is called, [generateSerializableModelsCode] should
  /// already be called and generated.
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });
}

extension GenerateCode on Library {
  /// Emits this library into [allocator] and throws the result away.
  ///
  /// Import prefixes are assigned from the complete set of imports a library
  /// needs rather than as references arrive, so the allocator has to see the
  /// whole library before [AssigningAllocator.assignPrefixes] is called. For a
  /// library split into part files, every part is collected into the shared
  /// allocator before any of them is generated.
  ///
  /// Emitting is around one percent of the cost of a generation run, the parse
  /// and the formatting in [generateCode] being the expensive parts, so
  /// collecting this way is cheaper than it looks.
  void collectImports(AssigningAllocator allocator) {
    accept(DartEmitter(useNullSafetySyntax: true, allocator: allocator));
  }

  /// Emits and formats this library.
  ///
  /// Pass an [allocator] that has already been through [collectImports],
  /// along with every other library sharing it. Without one, this collects
  /// itself into a fresh allocator, which is all a library that stands alone
  /// needs.
  ///
  /// Assigning the prefixes is done here either way, and is idempotent, so
  /// the members of a sealed hierarchy settle theirs on the first of them to
  /// be generated.
  String generateCode({
    AssigningAllocator? allocator,
    DartFormatter? formatter,
  }) {
    var assigned = allocator ?? StableImportAllocator();
    if (allocator == null) collectImports(assigned);
    assigned.assignPrefixes();

    var code = accept(
      DartEmitter(
        useNullSafetySyntax: true,
        allocator: assigned,
      ),
    ).toString();

    formatter ??= GeneratedDartFormatters.serverpodDefaultFormatter;

    try {
      return formatter.format(
        '$_fileHeader${ignoreForFile.isEmpty ? '\n' : ''}$code',
      );
    } on FormatterException catch (e) {
      const maxErrorLength = 4000;
      final message = e.toString();
      log.error(
        message.length > maxErrorLength
            ? '${message.substring(0, maxErrorLength)}\n\n... (truncated, ${message.length - maxErrorLength} more characters)'
            : message,
      );
    }
    return code;
  }
}

const _fileHeader = '''
/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
''';
