/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

abstract class DatabaseMigrationWarning extends _i1.SerializableEntity {
  const DatabaseMigrationWarning._();

  const factory DatabaseMigrationWarning({
    required _i2.DatabaseMigrationWarningType type,
    required String message,
    required String table,
    required List<String> columns,
    required bool destrucive,
  }) = _DatabaseMigrationWarning;

  factory DatabaseMigrationWarning.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationWarning(
      type: serializationManager.deserialize<_i2.DatabaseMigrationWarningType>(
          jsonSerialization['type']),
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      table:
          serializationManager.deserialize<String>(jsonSerialization['table']),
      columns: serializationManager
          .deserialize<List<String>>(jsonSerialization['columns']),
      destrucive: serializationManager
          .deserialize<bool>(jsonSerialization['destrucive']),
    );
  }

  DatabaseMigrationWarning copyWith({
    _i2.DatabaseMigrationWarningType? type,
    String? message,
    String? table,
    List<String>? columns,
    bool? destrucive,
  });
  _i2.DatabaseMigrationWarningType get type;
  String get message;
  String get table;
  List<String> get columns;
  bool get destrucive;
}

class _DatabaseMigrationWarning extends DatabaseMigrationWarning {
  const _DatabaseMigrationWarning({
    required this.type,
    required this.message,
    required this.table,
    required this.columns,
    required this.destrucive,
  }) : super._();

  @override
  final _i2.DatabaseMigrationWarningType type;

  @override
  final String message;

  @override
  final String table;

  @override
  final List<String> columns;

  @override
  final bool destrucive;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'table': table,
      'columns': columns,
      'destrucive': destrucive,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DatabaseMigrationWarning &&
            (identical(
                  other.type,
                  type,
                ) ||
                other.type == type) &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
            (identical(
                  other.table,
                  table,
                ) ||
                other.table == table) &&
            (identical(
                  other.destrucive,
                  destrucive,
                ) ||
                other.destrucive == destrucive) &&
            const _i3.DeepCollectionEquality().equals(
              columns,
              other.columns,
            ));
  }

  @override
  int get hashCode => Object.hash(
        type,
        message,
        table,
        destrucive,
        const _i3.DeepCollectionEquality().hash(columns),
      );

  @override
  DatabaseMigrationWarning copyWith({
    _i2.DatabaseMigrationWarningType? type,
    String? message,
    String? table,
    List<String>? columns,
    bool? destrucive,
  }) {
    return DatabaseMigrationWarning(
      type: type ?? this.type,
      message: message ?? this.message,
      table: table ?? this.table,
      columns: columns ?? this.columns,
      destrucive: destrucive ?? this.destrucive,
    );
  }
}
