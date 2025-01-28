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

abstract class ServerpodSqlException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  ServerpodSqlException._({
    required this.message,
    required this.sql,
  });

  factory ServerpodSqlException({
    required String message,
    required String sql,
  }) = _ServerpodSqlExceptionImpl;

  factory ServerpodSqlException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerpodSqlException(
      message: jsonSerialization['message'] as String,
      sql: jsonSerialization['sql'] as String,
    );
  }

  String message;

  String sql;

  /// Returns a shallow copy of this [ServerpodSqlException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerpodSqlException copyWith({
    String? message,
    String? sql,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sql': sql,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      'sql': sql,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ServerpodSqlExceptionImpl extends ServerpodSqlException {
  _ServerpodSqlExceptionImpl({
    required String message,
    required String sql,
  }) : super._(
          message: message,
          sql: sql,
        );

  /// Returns a shallow copy of this [ServerpodSqlException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerpodSqlException copyWith({
    String? message,
    String? sql,
  }) {
    return ServerpodSqlException(
      message: message ?? this.message,
      sql: sql ?? this.sql,
    );
  }
}
