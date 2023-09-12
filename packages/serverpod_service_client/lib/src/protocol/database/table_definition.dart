/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// The definition of a (desired) table in the database.
abstract class TableDefinition extends _i1.SerializableEntity {
  TableDefinition._({
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

  factory TableDefinition({
    required String name,
    String? dartName,
    String? module,
    required String schema,
    String? tableSpace,
    required List<_i2.ColumnDefinition> columns,
    required List<_i2.ForeignKeyDefinition> foreignKeys,
    required List<_i2.IndexDefinition> indexes,
    bool? managed,
  }) = _TableDefinitionImpl;

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
  String name;

  /// The name of the serializable class in Dart.
  String? dartName;

  /// The name of the module this table belongs to, if available.
  String? module;

  /// The schema this table is in.
  String schema;

  /// The tablespace this table is stored in.
  /// If null, the table is in the databases default tablespace.
  String? tableSpace;

  /// All the columns of this table.
  List<_i2.ColumnDefinition> columns;

  /// All the foreign keys.
  List<_i2.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  List<_i2.IndexDefinition> indexes;

  /// Indicates if the table should be managed by Serverpod.
  /// Null, if this is unknown.
  bool? managed;

  TableDefinition copyWith({
    String? name,
    String? dartName,
    String? module,
    String? schema,
    String? tableSpace,
    List<_i2.ColumnDefinition>? columns,
    List<_i2.ForeignKeyDefinition>? foreignKeys,
    List<_i2.IndexDefinition>? indexes,
    bool? managed,
  });
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
}

class _Undefined {}

class _TableDefinitionImpl extends TableDefinition {
  _TableDefinitionImpl({
    required String name,
    String? dartName,
    String? module,
    required String schema,
    String? tableSpace,
    required List<_i2.ColumnDefinition> columns,
    required List<_i2.ForeignKeyDefinition> foreignKeys,
    required List<_i2.IndexDefinition> indexes,
    bool? managed,
  }) : super._(
          name: name,
          dartName: dartName,
          module: module,
          schema: schema,
          tableSpace: tableSpace,
          columns: columns,
          foreignKeys: foreignKeys,
          indexes: indexes,
          managed: managed,
        );

  @override
  TableDefinition copyWith({
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
      dartName: dartName is! String? ? this.dartName : dartName,
      module: module is! String? ? this.module : module,
      schema: schema ?? this.schema,
      tableSpace: tableSpace is! String? ? this.tableSpace : tableSpace,
      columns: columns ?? this.columns.clone(),
      foreignKeys: foreignKeys ?? this.foreignKeys.clone(),
      indexes: indexes ?? this.indexes.clone(),
      managed: managed is! bool? ? this.managed : managed,
    );
  }
}
