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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

abstract class DatabaseMigrationWarning
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  DatabaseMigrationWarning._({
    required this.type,
    required this.message,
    required this.table,
    required this.columns,
    required this.destructive,
  });

  factory DatabaseMigrationWarning({
    required _isd.DatabaseMigrationWarningType type,
    required String message,
    required String table,
    required List<String> columns,
    required bool destructive,
  }) = _DatabaseMigrationWarningImpl;

  factory DatabaseMigrationWarning.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DatabaseMigrationWarning(
      type: _isd.DatabaseMigrationWarningType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      message: jsonSerialization['message'] as String,
      table: jsonSerialization['table'] as String,
      columns: _isd.Protocol().deserialize<List<String>>(
        jsonSerialization['columns'],
      ),
      destructive: _iss.BoolJsonExtension.fromJson(
        jsonSerialization['destrucive'],
      ),
    );
  }

  _isd.DatabaseMigrationWarningType type;

  String message;

  String table;

  List<String> columns;

  bool destructive;

  /// Returns a shallow copy of this [DatabaseMigrationWarning]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  DatabaseMigrationWarning copyWith({
    _isd.DatabaseMigrationWarningType? type,
    String? message,
    String? table,
    List<String>? columns,
    bool? destructive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseMigrationWarning',
      'type': type.toJson(),
      'message': message,
      'table': table,
      'columns': columns.toJson(),
      'destrucive': destructive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.DatabaseMigrationWarning',
      'type': type.toJson(),
      'message': message,
      'table': table,
      'columns': columns.toJson(),
      'destrucive': destructive,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _DatabaseMigrationWarningImpl extends DatabaseMigrationWarning {
  _DatabaseMigrationWarningImpl({
    required _isd.DatabaseMigrationWarningType type,
    required String message,
    required String table,
    required List<String> columns,
    required bool destructive,
  }) : super._(
         type: type,
         message: message,
         table: table,
         columns: columns,
         destructive: destructive,
       );

  /// Returns a shallow copy of this [DatabaseMigrationWarning]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  DatabaseMigrationWarning copyWith({
    _isd.DatabaseMigrationWarningType? type,
    String? message,
    String? table,
    List<String>? columns,
    bool? destructive,
  }) {
    return DatabaseMigrationWarning(
      type: type ?? this.type,
      message: message ?? this.message,
      table: table ?? this.table,
      columns: columns ?? this.columns.map((e0) => e0).toList(),
      destructive: destructive ?? this.destructive,
    );
  }
}
