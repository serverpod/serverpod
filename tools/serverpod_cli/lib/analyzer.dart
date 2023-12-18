/// Tools for analyzing the protocol files of a Serverpod project.
library analyzer;

export 'src/analyzer/protocol_definition.dart' show ProtocolDefinition;
export 'src/config/config.dart' show GeneratorConfig, PackageType;
export 'src/analyzer/models/model_analyzer.dart'
    show SerializableModelAnalyzer;
export 'src/analyzer/dart/endpoints_analyzer.dart' show EndpointsAnalyzer;
export 'src/analyzer/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.
export 'src/analyzer/models/definitions.dart'
    show
        SerializableModelDefinition,
        ClassDefinition,
        SerializableModelFieldDefinition,
        ModelFieldScopeDefinition,
        SerializableModelIndexDefinition,
        EnumDefinition;
export 'src/database/migration.dart';
export 'src/generator/types.dart' show TypeDefinition;
export 'src/migrations/generator.dart';
export 'src/database/extensions.dart';
