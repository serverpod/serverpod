/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Author extends _i1.TableRow {
  Author._({
    int? id,
    required this.name,
    this.blockedBy,
    this.blocked,
  }) : super(id);

  factory Author({
    int? id,
    required String name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  }) = _AuthorImpl;

  factory Author.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Author(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      blockedBy: serializationManager
          .deserialize<List<_i2.Blocked>?>(jsonSerialization['blockedBy']),
      blocked: serializationManager
          .deserialize<List<_i2.Blocked>?>(jsonSerialization['blocked']),
    );
  }

  static final t = AuthorTable();

  String name;

  List<_i2.Blocked>? blockedBy;

  List<_i2.Blocked>? blocked;

  @override
  _i1.Table get table => t;

  Author copyWith({
    int? id,
    String? name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'blockedBy': blockedBy,
      'blocked': blocked,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'blockedBy': blockedBy,
      'blocked': blocked,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Author>> find(
    _i1.Session session, {
    AuthorExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Author>(
      where: where != null ? where(Author.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Author?> findSingleRow(
    _i1.Session session, {
    AuthorExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Author>(
      where: where != null ? where(Author.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Author?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Author>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required AuthorWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Author>(
      where: where(Author.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Author row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Author row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Author row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    AuthorExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Author>(
      where: where != null ? where(Author.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static AuthorInclude include() {
    return AuthorInclude._();
  }
}

class _Undefined {}

class _AuthorImpl extends Author {
  _AuthorImpl({
    int? id,
    required String name,
    List<_i2.Blocked>? blockedBy,
    List<_i2.Blocked>? blocked,
  }) : super._(
          id: id,
          name: name,
          blockedBy: blockedBy,
          blocked: blocked,
        );

  @override
  Author copyWith({
    Object? id = _Undefined,
    String? name,
    Object? blockedBy = _Undefined,
    Object? blocked = _Undefined,
  }) {
    return Author(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      blockedBy:
          blockedBy is List<_i2.Blocked>? ? blockedBy : this.blockedBy?.clone(),
      blocked: blocked is List<_i2.Blocked>? ? blocked : this.blocked?.clone(),
    );
  }
}

typedef AuthorExpressionBuilder = _i1.Expression Function(AuthorTable);
typedef AuthorWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    AuthorWithoutManyRelationsTable);

class AuthorTable extends AuthorWithoutManyRelationsTable {
  AuthorTable({
    super.queryPrefix,
    super.tableRelations,
  });

  _i2.BlockedWithoutManyRelationsTable? _blockedBy;

  _i2.BlockedWithoutManyRelationsTable? _blocked;

  _i2.BlockedWithoutManyRelationsTable get _blockedByTable {
    if (_blockedBy != null) return _blockedBy!;
    _blockedBy = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'blockedBy',
      foreignTableName: _i2.Blocked.t.tableName,
      column: id,
      foreignColumnName: _i2.Blocked.t.blockerId.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.BlockedWithoutManyRelationsTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _blockedBy!;
  }

  _i2.BlockedWithoutManyRelationsTable get _blockedTable {
    if (_blocked != null) return _blocked!;
    _blocked = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'blocked',
      foreignTableName: _i2.Blocked.t.tableName,
      column: id,
      foreignColumnName: _i2.Blocked.t.blockeeId.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.BlockedWithoutManyRelationsTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _blocked!;
  }

  _i1.ManyRelationExpression blockedBy(
      _i2.BlockedWithoutManyRelationsExpressionBuilder where) {
    return _i1.ManyRelationExpression(
      table: _blockedByTable,
      where: where(_blockedByTable),
      foreignIdColumnName: 'blockerId',
    );
  }

  _i1.ManyRelationExpression blocked(
      _i2.BlockedWithoutManyRelationsExpressionBuilder where) {
    return _i1.ManyRelationExpression(
      table: _blockedTable,
      where: where(_blockedTable),
      foreignIdColumnName: 'blockeeId',
    );
  }
}

class AuthorWithoutManyRelationsTable extends _i1.Table {
  AuthorWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'author') {
    name = _i1.ColumnString(
      'name',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString name;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

@Deprecated('Use AuthorTable.t instead.')
AuthorTable tAuthor = AuthorTable();

class AuthorInclude extends _i1.Include {
  AuthorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Author.t;
}
