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
import '../database/column_definition.dart' as _i2;
import '../database/foreign_key_definition.dart' as _i3;
import '../database/index_definition.dart' as _i4;

/// The definition of a (desired) table in the database.
abstract class TableDefinition
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    required List<_i3.ForeignKeyDefinition> foreignKeys,
    required List<_i4.IndexDefinition> indexes,
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
              _i3.ForeignKeyDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      indexes: (jsonSerialization['indexes'] as List)
          .map((e) => _i4.IndexDefinition.fromJson((e as Map<String, dynamic>)))
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
  List<_i3.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  List<_i4.IndexDefinition> indexes;

  /// Indicates if the table should be managed by Serverpod.
  /// Null, if this is unknown.
  bool? managed;

  /// Returns a shallow copy of this [TableDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TableDefinition copyWith({
    String? name,
    String? dartName,
    String? module,
    String? schema,
    String? tableSpace,
    List<_i2.ColumnDefinition>? columns,
    List<_i3.ForeignKeyDefinition>? foreignKeys,
    List<_i4.IndexDefinition>? indexes,
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

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'name': name,
      if (dartName != null) 'dartName': dartName,
      if (module != null) 'module': module,
      'schema': schema,
      if (tableSpace != null) 'tableSpace': tableSpace,
      'columns': columns.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'foreignKeys':
          foreignKeys.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'indexes': indexes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (managed != null) 'managed': managed,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    required List<_i3.ForeignKeyDefinition> foreignKeys,
    required List<_i4.IndexDefinition> indexes,
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

  /// Returns a shallow copy of this [TableDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TableDefinition copyWith({
    String? name,
    Object? dartName = _Undefined,
    Object? module = _Undefined,
    String? schema,
    Object? tableSpace = _Undefined,
    List<_i2.ColumnDefinition>? columns,
    List<_i3.ForeignKeyDefinition>? foreignKeys,
    List<_i4.IndexDefinition>? indexes,
    Object? managed = _Undefined,
  }) {
    return TableDefinition(
      name: name ?? this.name,
      dartName: dartName is String? ? dartName : this.dartName,
      module: module is String? ? module : this.module,
      schema: schema ?? this.schema,
      tableSpace: tableSpace is String? ? tableSpace : this.tableSpace,
      columns: columns ?? this.columns.map((e0) => e0.copyWith()).toList(),
      foreignKeys:
          foreignKeys ?? this.foreignKeys.map((e0) => e0.copyWith()).toList(),
      indexes: indexes ?? this.indexes.map((e0) => e0.copyWith()).toList(),
      managed: managed is bool? ? managed : this.managed,
    );
  }
}
