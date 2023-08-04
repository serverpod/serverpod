/// Tools for analyzing the protocol files of a Serverpod project.
library analyzer;

export 'src/analyzer/protocol_definition.dart' show ProtocolDefinition;
export 'src/config/config.dart' show GeneratorConfig, PackageType;
export 'src/analyzer/entities/entity_analyzer.dart'
    show SerializableEntityAnalyzer;
export 'src/analyzer/dart/endpoints_analyzer.dart' show EndpointsAnalyzer;
export 'src/analyzer/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.
export 'src/analyzer/entities/definitions.dart'
    show
        SerializableEntityDefinition,
        ClassDefinition,
        SerializableEntityFieldDefinition,
        EntityFieldScopeDefinition,
        SerializableEntityIndexDefinition,
        EnumDefinition;
export 'src/generator/types.dart' show TypeDefinition;
export 'src/generator/generator_database_definition.dart';
export 'src/migrations/generator.dart';
export 'src/database/extensions.dart';
