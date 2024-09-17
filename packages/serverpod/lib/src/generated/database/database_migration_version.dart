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

/// Represents a version of a database migration.
abstract class DatabaseMigrationVersion extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  DatabaseMigrationVersion._({
    int? id,
    required this.module,
    required this.version,
    this.timestamp,
  }) : super(id);

  factory DatabaseMigrationVersion({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) = _DatabaseMigrationVersionImpl;

  factory DatabaseMigrationVersion.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DatabaseMigrationVersion(
      id: jsonSerialization['id'] as int?,
      module: jsonSerialization['module'] as String,
      version: jsonSerialization['version'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = DatabaseMigrationVersionTable();

  static const db = DatabaseMigrationVersionRepository._();

  /// The module the migration belongs to.
  String module;

  /// The version of the migration.
  String version;

  /// The timestamp of the migration. Only set if the migration is applied.
  DateTime? timestamp;

  @override
  _i1.Table get table => t;

  DatabaseMigrationVersion copyWith({
    int? id,
    String? module,
    String? version,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  static DatabaseMigrationVersionInclude include() {
    return DatabaseMigrationVersionInclude._();
  }

  static DatabaseMigrationVersionIncludeList includeList({
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    DatabaseMigrationVersionInclude? include,
  }) {
    return DatabaseMigrationVersionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatabaseMigrationVersionImpl extends DatabaseMigrationVersion {
  _DatabaseMigrationVersionImpl({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) : super._(
          id: id,
          module: module,
          version: version,
          timestamp: timestamp,
        );

  @override
  DatabaseMigrationVersion copyWith({
    Object? id = _Undefined,
    String? module,
    String? version,
    Object? timestamp = _Undefined,
  }) {
    return DatabaseMigrationVersion(
      id: id is int? ? id : this.id,
      module: module ?? this.module,
      version: version ?? this.version,
      timestamp: timestamp is DateTime? ? timestamp : this.timestamp,
    );
  }
}

class DatabaseMigrationVersionTable extends _i1.Table {
  DatabaseMigrationVersionTable({super.tableRelation})
      : super(tableName: 'serverpod_migrations') {
    module = _i1.ColumnString(
      'module',
      this,
    );
    version = _i1.ColumnString(
      'version',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  /// The module the migration belongs to.
  late final _i1.ColumnString module;

  /// The version of the migration.
  late final _i1.ColumnString version;

  /// The timestamp of the migration. Only set if the migration is applied.
  late final _i1.ColumnDateTime timestamp;

  @override
  List<_i1.Column> get columns => [
        id,
        module,
        version,
        timestamp,
      ];
}

class DatabaseMigrationVersionInclude extends _i1.IncludeObject {
  DatabaseMigrationVersionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => DatabaseMigrationVersion.t;
}

class DatabaseMigrationVersionIncludeList extends _i1.IncludeList {
  DatabaseMigrationVersionIncludeList._({
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DatabaseMigrationVersion.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => DatabaseMigrationVersion.t;
}

class DatabaseMigrationVersionRepository {
  const DatabaseMigrationVersionRepository._();

  Future<List<DatabaseMigrationVersion>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DatabaseMigrationVersion?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? offset,
    _i1.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DatabaseMigrationVersion?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<DatabaseMigrationVersion>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<DatabaseMigrationVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<DatabaseMigrationVersion>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DatabaseMigrationVersion> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<DatabaseMigrationVersion>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<DatabaseMigrationVersion> rows, {
    _i1.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<DatabaseMigrationVersion>(
      rows,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DatabaseMigrationVersion> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    DatabaseMigrationVersion row, {
    _i1.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<DatabaseMigrationVersion>(
      row,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<DatabaseMigrationVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<DatabaseMigrationVersion>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<DatabaseMigrationVersion> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<DatabaseMigrationVersion>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<DatabaseMigrationVersion>(
      where: where(DatabaseMigrationVersion.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
