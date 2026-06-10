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

abstract class SharedNotFoundException extends _i1.SharedSealedAppException
    implements _i2.SerializableException, _i2.SerializableModel {
  SharedNotFoundException._({
    required super.message,
    required this.code,
  });

  factory SharedNotFoundException({
    required String message,
    required int code,
  }) = _SharedNotFoundExceptionImpl;

  factory SharedNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedNotFoundException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as int,
    );
  }

  int code;

  /// Returns a shallow copy of this [SharedNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SharedNotFoundException copyWith({
    String? message,
    int? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedNotFoundException',
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'SharedNotFoundException(code: $code)';
  }
}

class _SharedNotFoundExceptionImpl extends SharedNotFoundException {
  _SharedNotFoundExceptionImpl({
    required String message,
    required int code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [SharedNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedNotFoundException copyWith({
    String? message,
    int? code,
  }) {
    return SharedNotFoundException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
