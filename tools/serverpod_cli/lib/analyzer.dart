/// Tools for analyzing the protocol files of a Serverpod project.
library analyzer;

export 'src/generator/config.dart' show GeneratorConfig;
export 'src/analyzer/yaml/file_analyzer.dart' show ProtocolYamlFileAnalyzer;
export 'src/generator/code_analysis_collector.dart' show CodeAnalysisCollector;
export 'package:source_span/source_span.dart'
    show SourceSpanException; // The collector uses them.
export 'src/analyzer/yaml/definitions.dart'
    show
        ProtocolFileDefinition,
        ClassDefinition,
        FieldDefinition,
        FieldScope,
        IndexDefinition,
        EnumDefinition;
export 'src/generator/types.dart' show TypeDefinition;
