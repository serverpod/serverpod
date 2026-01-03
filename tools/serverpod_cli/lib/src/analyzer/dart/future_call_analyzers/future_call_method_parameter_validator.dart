import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';

class FutureCallMethodParameterValidator {
  final StatefulAnalyzer modelAnalyzer;

  FutureCallMethodParameterValidator({required this.modelAnalyzer});

  bool isValid(FormalParameterElement parameter) {
    return _isValidType(TypeDefinition.fromDartType(parameter.type));
  }

  bool _isValidType(TypeDefinition type) {
    return (type.isSerializableDartType && type.generics.every(_isValidType)) ||
        _isSerializableModel(type) ||
        _isModelType(type) ||
        _isRecordType(type);
  }

  bool _isSerializableModel(TypeDefinition type) {
    return type.className == Keyword.serializableModelClassName;
  }

  bool _isModelType(TypeDefinition type) {
    final models = modelAnalyzer.validateAll();
    return models.any((model) => model.className == type.className);
  }

  bool _isRecordType(TypeDefinition type) {
    return type.isRecordType && type.generics.every(_isValidType);
  }
}
