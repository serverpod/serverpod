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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../protocol.dart' as _iototaiw;

abstract class ExtendedAppException extends _iototaiw.BaseAppException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ExtendedAppException._({
    required super.message,
    required this.detail,
  });

  factory ExtendedAppException({
    required String message,
    required String detail,
  }) = _ExtendedAppExceptionImpl;

  factory ExtendedAppException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ExtendedAppException(
      message: jsonSerialization['message'] as String,
      detail: jsonSerialization['detail'] as String,
    );
  }

  String detail;

  /// Returns a shallow copy of this [ExtendedAppException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  ExtendedAppException copyWith({
    String? message,
    String? detail,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExtendedAppException',
      'message': message,
      'detail': detail,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExtendedAppException',
      'message': message,
      'detail': detail,
    };
  }

  @override
  String toString() {
    return 'ExtendedAppException(message: $message, detail: $detail)';
  }
}

class _ExtendedAppExceptionImpl extends ExtendedAppException {
  _ExtendedAppExceptionImpl({
    required String message,
    required String detail,
  }) : super._(
         message: message,
         detail: detail,
       );

  /// Returns a shallow copy of this [ExtendedAppException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExtendedAppException copyWith({
    String? message,
    String? detail,
  }) {
    return ExtendedAppException(
      message: message ?? this.message,
      detail: detail ?? this.detail,
    );
  }
}
