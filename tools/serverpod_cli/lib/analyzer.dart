/// Tools for analyzing the protocol files of a Serverpod project.
library analyzer;

export 'src/analyzer/analyzer.dart' show ProtocolAnalyzer;
export 'src/analyzer/protocol_definition.dart' show ProtocolDefinition;
export 'src/generator/config.dart' show GeneratorConfig;
export 'src/analyzer/yaml/entity_analyzer.dart' show ProtocolEntityAnalyzer;
export 'src/analyzer/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.
export 'src/analyzer/yaml/definitions.dart'
    show
        ProtocolEntityDefinition,
        ProtocolClassDefinition,
        ProtocolFieldDefinition,
        ProtocolFieldScope,
        ProtocolIndexDefinition,
        ProtocolEnumDefinition;
export 'src/generator/types.dart' show TypeDefinition;
