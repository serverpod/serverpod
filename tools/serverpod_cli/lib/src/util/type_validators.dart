import 'package:serverpod_cli/analyzer.dart';

/// Utility class for validating [TypeDefinition]s.
class TypeValidators {
  /// Returns true if the [type] is a valid type that can be serialized.
  static bool isValidType(
    TypeDefinition type,
    List<TypeDefinition> extraClasses,
    List<SerializableModelDefinition> models,
  ) {
    return type.isSerializableDartType ||
        type.isStreamType ||
        isModelType(type, models) ||
        isCustomType(type, extraClasses) ||
        isRecordType(type, extraClasses, models);
  }

  static bool isCustomType(
    TypeDefinition type,
    List<TypeDefinition> extraClasses,
  ) {
    return extraClasses.any((c) => c.className == type.className);
  }

  static bool isRecordType(
    TypeDefinition type,
    List<TypeDefinition> extraClasses,
    List<SerializableModelDefinition> models,
  ) {
    return type.isRecordType &&
        type.generics.every((e) => isValidType(e, extraClasses, models));
  }

  static bool isModelType(
    TypeDefinition type,
    List<SerializableModelDefinition> models,
  ) {
    return models.any((model) => model.className == type.className);
  }
}
