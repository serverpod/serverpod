/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class BulkDataException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  BulkDataException._({
    required this.message,
    this.query,
  });

  factory BulkDataException({
    required String message,
    String? query,
  }) = _BulkDataExceptionImpl;

  factory BulkDataException.fromJson(Map<String, dynamic> jsonSerialization) {
    return BulkDataException(
      message: jsonSerialization['message'] as String,
      query: jsonSerialization['query'] as String?,
    );
  }

  String message;

  String? query;

  /// Returns a shallow copy of this [BulkDataException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BulkDataException copyWith({
    String? message,
    String? query,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (query != null) 'query': query,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      if (query != null) 'query': query,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BulkDataExceptionImpl extends BulkDataException {
  _BulkDataExceptionImpl({
    required String message,
    String? query,
  }) : super._(
          message: message,
          query: query,
        );

  /// Returns a shallow copy of this [BulkDataException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BulkDataException copyWith({
    String? message,
    Object? query = _Undefined,
  }) {
    return BulkDataException(
      message: message ?? this.message,
      query: query is String? ? query : this.query,
    );
  }
}
