/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ServerpodSqlException extends _i1.SerializableEntity
    implements _i1.SerializableException {
  ServerpodSqlException({
    required this.message,
    required this.sql,
  });

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

  String message;

  String sql;

  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sql': sql,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'message': message,
      'sql': sql,
    };
  }
}
