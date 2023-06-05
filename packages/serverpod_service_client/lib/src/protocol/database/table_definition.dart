/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// The definition of a (desired) table in the database.
class TableDefinition extends _i1.SerializableEntity {
  TableDefinition({
    required this.name,
    this.dartName,
    this.module,
    required this.schema,
    this.tableSpace,
    required this.columns,
    required this.foreignKeys,
    required this.indexes,
    this.managed,
  });

  factory TableDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TableDefinition(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      dartName: serializationManager
          .deserialize<String?>(jsonSerialization['dartName']),
      module: serializationManager
          .deserialize<String?>(jsonSerialization['module']),
      schema:
          serializationManager.deserialize<String>(jsonSerialization['schema']),
      tableSpace: serializationManager
          .deserialize<String?>(jsonSerialization['tableSpace']),
      columns: serializationManager.deserialize<List<_i2.ColumnDefinition>>(
          jsonSerialization['columns']),
      foreignKeys:
          serializationManager.deserialize<List<_i2.ForeignKeyDefinition>>(
              jsonSerialization['foreignKeys']),
      indexes: serializationManager
          .deserialize<List<_i2.IndexDefinition>>(jsonSerialization['indexes']),
      managed:
          serializationManager.deserialize<bool?>(jsonSerialization['managed']),
    );
  }

  /// The table name.
  final String name;

  /// The name of the serializable class in Dart.
  final String? dartName;

  /// The name of the module this table belongs to, if available.
  final String? module;

  /// The schema this table is in.
  final String schema;

  /// The tablespace this table is stored in.
  /// If null, the table is in the databases default tablespace.
  final String? tableSpace;

  /// All the columns of this table.
  final List<_i2.ColumnDefinition> columns;

  /// All the foreign keys.
  final List<_i2.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  final List<_i2.IndexDefinition> indexes;

  /// Indicates if the table should be managed by Serverpod.
  /// Null, if this is unknown.
  final bool? managed;

  late Function({
    String? name,
    String? dartName,
    String? module,
    String? schema,
    String? tableSpace,
    List<_i2.ColumnDefinition>? columns,
    List<_i2.ForeignKeyDefinition>? foreignKeys,
    List<_i2.IndexDefinition>? indexes,
    bool? managed,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dartName': dartName,
      'module': module,
      'schema': schema,
      'tableSpace': tableSpace,
      'columns': columns,
      'foreignKeys': foreignKeys,
      'indexes': indexes,
      'managed': managed,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is TableDefinition &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.dartName,
                  dartName,
                ) ||
                other.dartName == dartName) &&
            (identical(
                  other.module,
                  module,
                ) ||
                other.module == module) &&
            (identical(
                  other.schema,
                  schema,
                ) ||
                other.schema == schema) &&
            (identical(
                  other.tableSpace,
                  tableSpace,
                ) ||
                other.tableSpace == tableSpace) &&
            (identical(
                  other.managed,
                  managed,
                ) ||
                other.managed == managed) &&
            const _i3.DeepCollectionEquality().equals(
              columns,
              other.columns,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              foreignKeys,
              other.foreignKeys,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              indexes,
              other.indexes,
            ));
  }

  @override
  int get hashCode => Object.hash(
        name,
        dartName,
        module,
        schema,
        tableSpace,
        managed,
        const _i3.DeepCollectionEquality().hash(columns),
        const _i3.DeepCollectionEquality().hash(foreignKeys),
        const _i3.DeepCollectionEquality().hash(indexes),
      );

  TableDefinition _copyWith({
    String? name,
    Object? dartName = _Undefined,
    Object? module = _Undefined,
    String? schema,
    Object? tableSpace = _Undefined,
    List<_i2.ColumnDefinition>? columns,
    List<_i2.ForeignKeyDefinition>? foreignKeys,
    List<_i2.IndexDefinition>? indexes,
    Object? managed = _Undefined,
  }) {
    return TableDefinition(
      name: name ?? this.name,
      dartName: dartName == _Undefined ? this.dartName : (dartName as String?),
      module: module == _Undefined ? this.module : (module as String?),
      schema: schema ?? this.schema,
      tableSpace:
          tableSpace == _Undefined ? this.tableSpace : (tableSpace as String?),
      columns: columns ?? this.columns,
      foreignKeys: foreignKeys ?? this.foreignKeys,
      indexes: indexes ?? this.indexes,
      managed: managed == _Undefined ? this.managed : (managed as bool?),
    );
  }
}
