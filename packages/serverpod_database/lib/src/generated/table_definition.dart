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

/// The definition of a (desired) table in the database.
abstract class TableDefinition
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
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
    required List<_isd.ColumnDefinition> columns,
    required List<_isd.ForeignKeyDefinition> foreignKeys,
    required List<_isd.IndexDefinition> indexes,
    bool? managed,
  }) = _TableDefinitionImpl;

  factory TableDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return TableDefinition(
      name: jsonSerialization['name'] as String,
      dartName: jsonSerialization['dartName'] as String?,
      module: jsonSerialization['module'] as String?,
      schema: jsonSerialization['schema'] as String,
      tableSpace: jsonSerialization['tableSpace'] as String?,
      columns: _isd.Protocol().deserialize<List<_isd.ColumnDefinition>>(
        jsonSerialization['columns'],
      ),
      foreignKeys: _isd.Protocol().deserialize<List<_isd.ForeignKeyDefinition>>(
        jsonSerialization['foreignKeys'],
      ),
      indexes: _isd.Protocol().deserialize<List<_isd.IndexDefinition>>(
        jsonSerialization['indexes'],
      ),
      managed: jsonSerialization['managed'] == null
          ? null
          : _iss.BoolJsonExtension.fromJson(jsonSerialization['managed']),
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
  List<_isd.ColumnDefinition> columns;

  /// All the foreign keys.
  List<_isd.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  List<_isd.IndexDefinition> indexes;

  /// Indicates if the table should be managed by Serverpod.
  /// Null, if this is unknown.
  bool? managed;

  /// Returns a shallow copy of this [TableDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  TableDefinition copyWith({
    String? name,
    String? dartName,
    String? module,
    String? schema,
    String? tableSpace,
    List<_isd.ColumnDefinition>? columns,
    List<_isd.ForeignKeyDefinition>? foreignKeys,
    List<_isd.IndexDefinition>? indexes,
    bool? managed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.TableDefinition',
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
      '__className__': 'serverpod.TableDefinition',
      'name': name,
      if (dartName != null) 'dartName': dartName,
      if (module != null) 'module': module,
      'schema': schema,
      if (tableSpace != null) 'tableSpace': tableSpace,
      'columns': columns.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'foreignKeys': foreignKeys.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'indexes': indexes.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (managed != null) 'managed': managed,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
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
    required List<_isd.ColumnDefinition> columns,
    required List<_isd.ForeignKeyDefinition> foreignKeys,
    required List<_isd.IndexDefinition> indexes,
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
  @_iss.useResult
  @override
  TableDefinition copyWith({
    String? name,
    Object? dartName = _Undefined,
    Object? module = _Undefined,
    String? schema,
    Object? tableSpace = _Undefined,
    List<_isd.ColumnDefinition>? columns,
    List<_isd.ForeignKeyDefinition>? foreignKeys,
    List<_isd.IndexDefinition>? indexes,
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
