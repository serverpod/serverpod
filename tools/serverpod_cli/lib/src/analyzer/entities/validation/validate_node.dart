import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:source_span/source_span.dart';

class ValidateNode {
  String key;
  bool isRequired;
  bool isDepricated;
  Set<String> mutualExclusiveKeys;
  bool Function(String)? keyRestriction;
  void Function(dynamic, SourceSpan?, CodeAnalysisCollector)? valueRestriction;
  Set<ValidateNode> nested;

  ValidateNode(
    this.key, {
    this.isRequired = false,
    this.isDepricated = false,
    this.mutualExclusiveKeys = const {},
    this.keyRestriction,
    this.valueRestriction,
    this.nested = const {},
  });
}
