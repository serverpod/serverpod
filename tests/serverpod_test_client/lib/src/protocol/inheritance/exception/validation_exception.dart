/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'sealed_app_exception.dart';

abstract class ValidationException extends _i1.SealedAppException
    implements _i2.SerializableException, _i2.SerializableModel {
  ValidationException._({
    required super.message,
    required this.field,
  });

  factory ValidationException({
    required String message,
    required String field,
  }) = _ValidationExceptionImpl;

  factory ValidationException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ValidationException(
      message: jsonSerialization['message'] as String,
      field: jsonSerialization['field'] as String,
    );
  }

  String field;

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ValidationException copyWith({
    String? message,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ValidationException',
      'message': message,
      'field': field,
    };
  }

  @override
  String toString() {
    return 'ValidationException(message: $message, field: $field)';
  }
}

class _ValidationExceptionImpl extends ValidationException {
  _ValidationExceptionImpl({
    required String message,
    required String field,
  }) : super._(
         message: message,
         field: field,
       );

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ValidationException copyWith({
    String? message,
    String? field,
  }) {
    return ValidationException(
      message: message ?? this.message,
      field: field ?? this.field,
    );
  }
}
