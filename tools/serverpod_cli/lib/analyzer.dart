/// Tools for analyzing the protocol files of a Serverpod project.
library analyzer;

export 'src/generator/config.dart' show GeneratorConfig;
export 'src/generator/class_analyzer.dart' show ProtocolFileAnalyzer;
export 'src/generator/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.
export 'src/generator/protocol_definition.dart'
    show
        ProtocolFileDefinition,
        ClassDefinition,
        FieldDefinition,
        FieldScope,
        IndexDefinition,
        EnumDefinition;
export 'src/generator/types.dart' show TypeDefinition;
