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

abstract class NotFoundException extends _i1.SealedAppException
    implements
        _i2.SerializableException,
        _i2.SerializableModel,
        _i2.ProtocolSerialization {
  NotFoundException._({
    required super.message,
    required this.code,
  });

  factory NotFoundException({
    required String message,
    required int code,
  }) = _NotFoundExceptionImpl;

  factory NotFoundException.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotFoundException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as int,
    );
  }

  int code;

  /// Returns a shallow copy of this [NotFoundException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  NotFoundException copyWith({
    String? message,
    int? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotFoundException',
      'message': message,
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotFoundException',
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'NotFoundException(code: $code)';
  }
}

class _NotFoundExceptionImpl extends NotFoundException {
  _NotFoundExceptionImpl({
    required String message,
    required int code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [NotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  NotFoundException copyWith({
    String? message,
    int? code,
  }) {
    return NotFoundException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
