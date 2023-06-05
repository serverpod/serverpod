/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ServerpodSqlException extends _i1.SerializableEntity
    implements _i1.SerializableException {
  const ServerpodSqlException._();

  const factory ServerpodSqlException({
    required String message,
    required String sql,
  }) = _ServerpodSqlException;

  factory ServerpodSqlException.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerpodSqlException(
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      sql: serializationManager.deserialize<String>(jsonSerialization['sql']),
    );
  }

  ServerpodSqlException copyWith({
    String? message,
    String? sql,
  });
  String get message;
  String get sql;
}

class _ServerpodSqlException extends ServerpodSqlException
    implements _i1.SerializableException {
  const _ServerpodSqlException({
    required this.message,
    required this.sql,
  }) : super._();

  @override
  final String message;

  @override
  final String sql;

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sql': sql,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ServerpodSqlException &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
            (identical(
                  other.sql,
                  sql,
                ) ||
                other.sql == sql));
  }

  @override
  int get hashCode => Object.hash(
        message,
        sql,
      );

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
