import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/validation_utils.dart';

class FutureCallMethodParameterValidator {
  final GeneratorConfig config;
  final StatefulAnalyzer modelAnalyzer;

  FutureCallMethodParameterValidator({
    required this.config,
    required this.modelAnalyzer,
  });

  bool isValid(FormalParameterElement parameter) {
    return _isValidType(TypeDefinition.fromDartType(parameter.type));
  }

  bool _isValidType(TypeDefinition type) {
    return (isValidSerializableDartType(type.className) &&
            type.generics.every(_isValidType)) ||
        _isModelType(type) ||
        _isRecordType(type);
  }

  bool _isModelType(TypeDefinition type) {
    final models = modelAnalyzer.validateAll();
    return models.any((model) => model.className == type.className);
  }

  bool _isRecordType(TypeDefinition type) {
    return type.isRecordType && type.generics.every(_isValidType);
  }
}
