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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ExceptionDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ExceptionDetail._({
    required this.field,
    required this.message,
  });

  factory ExceptionDetail({
    required String field,
    required String message,
  }) = _ExceptionDetailImpl;

  factory ExceptionDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExceptionDetail(
      field: jsonSerialization['field'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  String field;

  String message;

  /// Returns a shallow copy of this [ExceptionDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExceptionDetail copyWith({
    String? field,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExceptionDetail',
      'field': field,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExceptionDetail',
      'field': field,
      'message': message,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ExceptionDetailImpl extends ExceptionDetail {
  _ExceptionDetailImpl({
    required String field,
    required String message,
  }) : super._(
         field: field,
         message: message,
       );

  /// Returns a shallow copy of this [ExceptionDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExceptionDetail copyWith({
    String? field,
    String? message,
  }) {
    return ExceptionDetail(
      field: field ?? this.field,
      message: message ?? this.message,
    );
  }
}
