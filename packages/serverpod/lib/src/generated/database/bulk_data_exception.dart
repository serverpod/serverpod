/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class BulkDataException extends _i1.SerializableEntity
    implements _i1.SerializableException {
  BulkDataException._({
    required this.message,
    this.query,
  });

  factory BulkDataException({
    required String message,
    String? query,
  }) = _BulkDataExceptionImpl;

  factory BulkDataException.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return BulkDataException(
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      query:
          serializationManager.deserialize<String?>(jsonSerialization['query']),
    );
  }

  String message;

  String? query;

  BulkDataException copyWith({
    String? message,
    String? query,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'query': query,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'message': message,
      'query': query,
    };
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
