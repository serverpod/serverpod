/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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

  factory TableDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return TableDefinition(
      name: jsonSerialization['name'] as String,
      dartName: jsonSerialization['dartName'] as String?,
      module: jsonSerialization['module'] as String?,
      schema: jsonSerialization['schema'] as String,
      tableSpace: jsonSerialization['tableSpace'] as String?,
      columns: (jsonSerialization['columns'] as List)
          .map(
              (e) => _i2.ColumnDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      foreignKeys: (jsonSerialization['foreignKeys'] as List)
          .map((e) =>
              _i2.ForeignKeyDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      indexes: (jsonSerialization['indexes'] as List)
          .map((e) => _i2.IndexDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      managed: jsonSerialization['managed'] as bool?,
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
      if (dartName != null) 'dartName': dartName,
      if (module != null) 'module': module,
      'schema': schema,
      if (tableSpace != null) 'tableSpace': tableSpace,
      'columns': columns.toJson(valueToJson: (v) => v.toJson()),
      'foreignKeys': foreignKeys.toJson(valueToJson: (v) => v.toJson()),
      'indexes': indexes.toJson(valueToJson: (v) => v.toJson()),
      if (managed != null) 'managed': managed,
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
      dartName: dartName is String? ? dartName : this.dartName,
      module: module is String? ? module : this.module,
      schema: schema ?? this.schema,
      tableSpace: tableSpace is String? ? tableSpace : this.tableSpace,
      columns: columns ?? this.columns.clone(),
      foreignKeys: foreignKeys ?? this.foreignKeys.clone(),
      indexes: indexes ?? this.indexes.clone(),
      managed: managed is bool? ? managed : this.managed,
    );
  }
}
