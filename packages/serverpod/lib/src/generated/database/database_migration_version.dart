/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Represents a version of a database migration.
abstract class DatabaseMigrationVersion extends _i1.TableRow {
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
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationVersion(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      module:
          serializationManager.deserialize<String>(jsonSerialization['module']),
      version: serializationManager
          .deserialize<String>(jsonSerialization['version']),
      timestamp: serializationManager
          .deserialize<DateTime?>(jsonSerialization['timestamp']),
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
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'module': module,
      'version': version,
      'timestamp': timestamp,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'module':
        module = value;
        return;
      case 'version':
        version = value;
        return;
      case 'timestamp':
        timestamp = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<DatabaseMigrationVersion>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<DatabaseMigrationVersion>(
      where: where != null ? where(DatabaseMigrationVersion.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<DatabaseMigrationVersion?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<DatabaseMigrationVersion>(
      where: where != null ? where(DatabaseMigrationVersion.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<DatabaseMigrationVersion?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<DatabaseMigrationVersion>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DatabaseMigrationVersion>(
      where: where(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DatabaseMigrationVersion>(
      where: where != null ? where(DatabaseMigrationVersion.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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

@Deprecated('Use DatabaseMigrationVersionTable.t instead.')
DatabaseMigrationVersionTable tDatabaseMigrationVersion =
    DatabaseMigrationVersionTable();

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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DatabaseMigrationVersion?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? offset,
    _i1.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<DatabaseMigrationVersion?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<DatabaseMigrationVersion>(
      id,
      transaction: transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> insert(
    _i1.Session session,
    List<DatabaseMigrationVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<DatabaseMigrationVersion>(
      rows,
      transaction: transaction,
    );
  }

  Future<DatabaseMigrationVersion> insertRow(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<DatabaseMigrationVersion>(
      row,
      transaction: transaction,
    );
  }

  Future<List<DatabaseMigrationVersion>> update(
    _i1.Session session,
    List<DatabaseMigrationVersion> rows, {
    _i1.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<DatabaseMigrationVersion>(
      rows,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  Future<DatabaseMigrationVersion> updateRow(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<DatabaseMigrationVersion>(
      row,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<DatabaseMigrationVersion> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<DatabaseMigrationVersion>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    DatabaseMigrationVersion row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<DatabaseMigrationVersion>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<DatabaseMigrationVersion>(
      where: where(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
