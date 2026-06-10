/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'shared_sealed_app_exception.dart';

abstract class SharedValidationException extends _i1.SharedSealedAppException
    implements _i2.SerializableException, _i2.SerializableModel {
  SharedValidationException._({
    required super.message,
    required this.field,
  });

  factory SharedValidationException({
    required String message,
    required String field,
  }) = _SharedValidationExceptionImpl;

  factory SharedValidationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedValidationException(
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String,
    );
  }

  String field;

  /// Returns a shallow copy of this [SharedValidationException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SharedValidationException copyWith({
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedValidationException',
      'message': message,
      'field': field,
    };
  }

  @override
  String toString() {
    return 'SharedValidationException(field: $field)';
  }
}

class _SharedValidationExceptionImpl extends SharedValidationException {
  _SharedValidationExceptionImpl({
    required String message,
    required String field,
  }) : super._(
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [SharedValidationException]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedValidationException copyWith({
    String? message,
    String? field,
  }) {
    return SharedValidationException(
      message: message ?? this.message,
      field: field ?? this.field,
    );
  }
}
