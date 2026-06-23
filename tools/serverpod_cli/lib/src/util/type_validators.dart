import 'package:serverpod_cli/analyzer.dart';

/// Utility class for validating [TypeDefinition]s.
class TypeValidators {
  /// Returns true if the [type] is a valid type that can be serialized.
  static bool isValidType(
    TypeDefinition type,
    TypeValidationOptions options,
  ) {
    return (options.allowSerializableDartType && type.isSerializableDartType) ||
        (options.allowSerializableModelBaseType &&
            isSerializableModelBaseType(type)) ||
        (options.allowStreamType && type.isStreamType) ||
        isModelType(type, options) ||
        (options.modelTypeValidator?.call(type) ?? false) ||
        isCustomType(type, options) ||
        isRecordType(type, options) ||
        (options.allowSerializableGenerics &&
            isSerializableGeneric(type, options));
  }

  /// Returns true if the [type] matches one of the provided extra classes.
  static bool isCustomType(
    TypeDefinition type,
    TypeValidationOptions options,
  ) {
    return options.extraClasses?.any((c) => c.className == type.className) ??
        false;
  }

  /// Returns true if the [type] is a record type and all its generics are valid.
  static bool isRecordType(
    TypeDefinition type,
    TypeValidationOptions options,
  ) {
    return type.isRecordType &&
        type.generics.every(
          (e) => isValidType(e, options),
        );
  }

  /// Returns true if the [type] is a serializable Dart type and its generics are valid.
  static bool isSerializableGeneric(
    TypeDefinition type,
    TypeValidationOptions options,
  ) {
    return type.isSerializableDartType &&
        type.generics.every(
          (e) => isValidType(e, options),
        );
  }

  /// Returns true if the [type] matches one of the provided models.
  static bool isModelType(
    TypeDefinition type,
    TypeValidationOptions options,
  ) {
    return options.models?.any((model) => model.className == type.className) ??
        false;
  }

  /// Returns true if the [type] is the base 'SerializableModel' type.
  static bool isSerializableModelBaseType(TypeDefinition type) {
    return type.className == 'SerializableModel';
  }
}

/// Options for configuring how [TypeDefinition]s are validated.
class TypeValidationOptions {
  /// Models in the project.
  final List<SerializableModelDefinition>? models;

  /// Custom classes.
  final List<TypeDefinition>? extraClasses;

  /// Custom validator function for model types.
  final bool Function(TypeDefinition type)? modelTypeValidator;

  /// Whether serializable Dart types are allowed without validating their
  /// generic arguments (e.g. `List<Foo>` is accepted regardless of `Foo`).
  /// Prefer [allowSerializableGenerics] unless the generic arguments are
  /// validated separately.
  final bool allowSerializableDartType;

  /// Whether serializable Dart types are allowed, validating each generic
  /// argument recursively (e.g. `List<Foo>` is only accepted when `Foo` is
  /// itself a valid type).
  final bool allowSerializableGenerics;

  /// Whether Stream types are allowed.
  final bool allowStreamType;

  /// Whether the 'SerializableModel' base class itself is allowed as a type.
  final bool allowSerializableModelBaseType;

  const TypeValidationOptions({
    this.models,
    this.extraClasses,
    this.modelTypeValidator,
    this.allowSerializableDartType = false,
    this.allowSerializableGenerics = false,
    this.allowStreamType = false,
    this.allowSerializableModelBaseType = false,
  });
}
