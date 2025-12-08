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
import 'package:serverpod/serverpod.dart' as _i1;
import '../database/column_definition.dart' as _i2;
import '../database/foreign_key_definition.dart' as _i3;
import '../database/index_definition.dart' as _i4;
import '../database/partition_method.dart' as _i5;
import 'package:serverpod/src/generated/protocol.dart' as _i6;

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
    this.partitionBy,
    this.partitionMethod,
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
    List<String>? partitionBy,
    _i5.PartitionMethod? partitionMethod,
  }) = _TableDefinitionImpl;

  factory TableDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return TableDefinition(
      name: jsonSerialization['name'] as String,
      dartName: jsonSerialization['dartName'] as String?,
      module: jsonSerialization['module'] as String?,
      schema: jsonSerialization['schema'] as String,
      tableSpace: jsonSerialization['tableSpace'] as String?,
      columns: _i6.Protocol().deserialize<List<_i2.ColumnDefinition>>(
        jsonSerialization['columns'],
      ),
      foreignKeys: _i6.Protocol().deserialize<List<_i3.ForeignKeyDefinition>>(
        jsonSerialization['foreignKeys'],
      ),
      indexes: _i6.Protocol().deserialize<List<_i4.IndexDefinition>>(
        jsonSerialization['indexes'],
      ),
      managed: jsonSerialization['managed'] as bool?,
      partitionBy: jsonSerialization['partitionBy'] == null
          ? null
          : _i6.Protocol().deserialize<List<String>>(
              jsonSerialization['partitionBy'],
            ),
      partitionMethod: jsonSerialization['partitionMethod'] == null
          ? null
          : _i5.PartitionMethod.fromJson(
              (jsonSerialization['partitionMethod'] as String),
            ),
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

  /// The fields to partition the table by, if any.
  /// Uses PostgreSQL partitioning for tables with high traffic.
  List<String>? partitionBy;

  /// The partition method to use (list, range, or hash).
  /// Defaults to 'list' if not specified but partitionBy is set.
  _i5.PartitionMethod? partitionMethod;

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
    List<String>? partitionBy,
    _i5.PartitionMethod? partitionMethod,
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
      if (partitionBy != null) 'partitionBy': partitionBy?.toJson(),
      if (partitionMethod != null) 'partitionMethod': partitionMethod?.toJson(),
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
      if (partitionBy != null) 'partitionBy': partitionBy?.toJson(),
      if (partitionMethod != null) 'partitionMethod': partitionMethod?.toJson(),
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
    List<String>? partitionBy,
    _i5.PartitionMethod? partitionMethod,
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
         partitionBy: partitionBy,
         partitionMethod: partitionMethod,
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
    Object? partitionBy = _Undefined,
    Object? partitionMethod = _Undefined,
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
      partitionBy: partitionBy is List<String>?
          ? partitionBy
          : this.partitionBy?.map((e0) => e0).toList(),
      partitionMethod: partitionMethod is _i5.PartitionMethod?
          ? partitionMethod
          : this.partitionMethod,
    );
  }
}
