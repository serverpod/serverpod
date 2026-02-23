/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

abstract class SharedException
    implements _i1.SerializableException, _i1.SerializableModel {
  SharedException._({
    required this.message,
    this.code,
  });

  factory SharedException({
    required String message,
    int? code,
  }) = _SharedExceptionImpl;

  factory SharedException.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as int?,
    );
  }

  String message;

  int? code;

  /// Returns a shallow copy of this [SharedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedException copyWith({
    String? message,
    int? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedException',
      'message': message,
      if (code != null) 'code': code,
    };
  }

  @override
  String toString() {
    return 'SharedException(message: $message, code: $code)';
  }
}

class _Undefined {}

class _SharedExceptionImpl extends SharedException {
  _SharedExceptionImpl({
    required String message,
    int? code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [SharedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedException copyWith({
    String? message,
    Object? code = _Undefined,
  }) {
    return SharedException(
      message: message ?? this.message,
      code: code is int? ? code : this.code,
    );
  }
}
