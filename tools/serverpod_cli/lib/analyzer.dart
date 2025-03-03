/// Tools for analyzing the protocol files of a Serverpod project.
library;

export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.

export 'src/analyzer/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'src/analyzer/dart/endpoints_analyzer.dart' show EndpointsAnalyzer;
export 'src/analyzer/models/definitions.dart'
    show
        SerializableModelDefinition,
        ClassDefinition,
        ModelClassDefinition,
        ExceptionClassDefinition,
        SerializableModelFieldDefinition,
        ModelFieldScopeDefinition,
        SerializableModelIndexDefinition,
        EnumDefinition;
export 'src/analyzer/models/model_analyzer.dart' show SerializableModelAnalyzer;
export 'src/analyzer/protocol_definition.dart' show ProtocolDefinition;
export 'src/config/config.dart' show GeneratorConfig, PackageType;
export 'src/database/extensions.dart';
export 'src/database/migration.dart';
export 'src/generator/types.dart' show TypeDefinition;
export 'src/migrations/generator.dart';
