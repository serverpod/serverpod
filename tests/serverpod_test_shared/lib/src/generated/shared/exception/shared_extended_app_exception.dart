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
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

abstract class SharedExtendedAppException extends _i1.SharedBaseAppException
    implements
        _i2.SerializableException,
        _i2.SerializableModel,
        _i2.ProtocolSerialization {
  SharedExtendedAppException._({
    required super.message,
    required this.detail,
  });

  factory SharedExtendedAppException({
    required String message,
    required String detail,
  }) = _SharedExtendedAppExceptionImpl;

  factory SharedExtendedAppException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedExtendedAppException(
      message: jsonSerialization['message'] as String,
      detail: jsonSerialization['detail'] as String,
    );
  }

  String detail;

  /// Returns a shallow copy of this [SharedExtendedAppException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SharedExtendedAppException copyWith({
    String? message,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedExtendedAppException',
      'message': message,
      'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedExtendedAppException',
      'message': message,
      'detail': detail,
    };
  }

  @override
  String toString() {
    return 'SharedExtendedAppException(message: $message, detail: $detail)';
  }
}

class _SharedExtendedAppExceptionImpl extends SharedExtendedAppException {
  _SharedExtendedAppExceptionImpl({
    required String message,
    required String detail,
  }) : super._(
         message: message,
         detail: detail,
       );

  /// Returns a shallow copy of this [SharedExtendedAppException]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedExtendedAppException copyWith({
    String? message,
    String? detail,
  }) {
    return SharedExtendedAppException(
      message: message ?? this.message,
      detail: detail ?? this.detail,
    );
  }
}
