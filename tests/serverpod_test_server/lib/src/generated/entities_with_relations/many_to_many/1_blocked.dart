/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Blocked extends _i1.TableRow {
  Blocked._({
    int? id,
    required this.blockerId,
    this.blocker,
    required this.blockeeId,
    this.blockee,
  }) : super(id);

  factory Blocked({
    int? id,
    required int blockerId,
    _i2.Author? blocker,
    required int blockeeId,
    _i2.Author? blockee,
  }) = _BlockedImpl;

  factory Blocked.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blocked(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      blockerId:
          serializationManager.deserialize<int>(jsonSerialization['blockerId']),
      blocker: serializationManager
          .deserialize<_i2.Author?>(jsonSerialization['blocker']),
      blockeeId:
          serializationManager.deserialize<int>(jsonSerialization['blockeeId']),
      blockee: serializationManager
          .deserialize<_i2.Author?>(jsonSerialization['blockee']),
    );
  }

  static final t = BlockedTable();

  static final db = BlockedRepository._();

  int blockerId;

  _i2.Author? blocker;

  int blockeeId;

  _i2.Author? blockee;

  @override
  _i1.Table get table => t;

  Blocked copyWith({
    int? id,
    int? blockerId,
    _i2.Author? blocker,
    int? blockeeId,
    _i2.Author? blockee,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blocker': blocker,
      'blockeeId': blockeeId,
      'blockee': blockee,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blockeeId': blockeeId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blocker': blocker,
      'blockeeId': blockeeId,
      'blockee': blockee,
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
      case 'blockerId':
        blockerId = value;
        return;
      case 'blockeeId':
        blockeeId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Blocked>> find(
    _i1.Session session, {
    BlockedExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    BlockedInclude? include,
  }) async {
    return session.db.find<Blocked>(
      where: where != null ? where(Blocked.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Blocked?> findSingleRow(
    _i1.Session session, {
    BlockedExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    BlockedInclude? include,
  }) async {
    return session.db.findSingleRow<Blocked>(
      where: where != null ? where(Blocked.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Blocked?> findById(
    _i1.Session session,
    int id, {
    BlockedInclude? include,
  }) async {
    return session.db.findById<Blocked>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required BlockedWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Blocked>(
      where: where(Blocked.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Blocked row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Blocked row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Blocked row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    BlockedExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Blocked>(
      where: where != null ? where(Blocked.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static BlockedInclude include({
    _i2.AuthorInclude? blocker,
    _i2.AuthorInclude? blockee,
  }) {
    return BlockedInclude._(
      blocker: blocker,
      blockee: blockee,
    );
  }
}

class _Undefined {}

class _BlockedImpl extends Blocked {
  _BlockedImpl({
    int? id,
    required int blockerId,
    _i2.Author? blocker,
    required int blockeeId,
    _i2.Author? blockee,
  }) : super._(
          id: id,
          blockerId: blockerId,
          blocker: blocker,
          blockeeId: blockeeId,
          blockee: blockee,
        );

  @override
  Blocked copyWith({
    Object? id = _Undefined,
    int? blockerId,
    Object? blocker = _Undefined,
    int? blockeeId,
    Object? blockee = _Undefined,
  }) {
    return Blocked(
      id: id is int? ? id : this.id,
      blockerId: blockerId ?? this.blockerId,
      blocker: blocker is _i2.Author? ? blocker : this.blocker?.copyWith(),
      blockeeId: blockeeId ?? this.blockeeId,
      blockee: blockee is _i2.Author? ? blockee : this.blockee?.copyWith(),
    );
  }
}

typedef BlockedExpressionBuilder = _i1.Expression Function(BlockedTable);
typedef BlockedWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    BlockedWithoutManyRelationsTable);

class BlockedTable extends BlockedWithoutManyRelationsTable {
  BlockedTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class BlockedWithoutManyRelationsTable extends _i1.Table {
  BlockedWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'blocked') {
    blockerId = _i1.ColumnInt(
      'blockerId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    blockeeId = _i1.ColumnInt(
      'blockeeId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnInt blockerId;

  _i2.AuthorTable? _blocker;

  late final _i1.ColumnInt blockeeId;

  _i2.AuthorTable? _blockee;

  _i2.AuthorTable get blocker {
    if (_blocker != null) return _blocker!;
    _blocker = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'blocker',
      foreignTableName: _i2.Author.t.tableName,
      column: blockerId,
      foreignColumnName: _i2.Author.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.AuthorTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _blocker!;
  }

  _i2.AuthorTable get blockee {
    if (_blockee != null) return _blockee!;
    _blockee = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'blockee',
      foreignTableName: _i2.Author.t.tableName,
      column: blockeeId,
      foreignColumnName: _i2.Author.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.AuthorTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _blockee!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        blockerId,
        blockeeId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'blocker') {
      return blocker;
    }
    if (relationField == 'blockee') {
      return blockee;
    }
    return null;
  }
}

@Deprecated('Use BlockedTable.t instead.')
BlockedTable tBlocked = BlockedTable();

class BlockedInclude extends _i1.Include {
  BlockedInclude._({
    _i2.AuthorInclude? blocker,
    _i2.AuthorInclude? blockee,
  }) {
    _blocker = blocker;
    _blockee = blockee;
  }

  _i2.AuthorInclude? _blocker;

  _i2.AuthorInclude? _blockee;

  @override
  Map<String, _i1.Include?> get includes => {
        'blocker': _blocker,
        'blockee': _blockee,
      };

  @override
  _i1.Table get table => Blocked.t;
}

class BlockedRepository {
  const BlockedRepository._();

  final attach = const BlockedAttachRepository._();
}

class BlockedAttachRepository {
  const BlockedAttachRepository._();

  Future<void> blocker(
    _i1.Session session,
    Blocked blocked,
    _i2.Author blocker,
  ) async {
    if (blocked.id == null) {
      throw ArgumentError.notNull('blocked.id');
    }
    if (blocker.id == null) {
      throw ArgumentError.notNull('blocker.id');
    }

    var $blocked = blocked.copyWith(blockerId: blocker.id);
    await session.db.update(
      $blocked,
      columns: [Blocked.t.blockerId],
    );
  }

  Future<void> blockee(
    _i1.Session session,
    Blocked blocked,
    _i2.Author blockee,
  ) async {
    if (blocked.id == null) {
      throw ArgumentError.notNull('blocked.id');
    }
    if (blockee.id == null) {
      throw ArgumentError.notNull('blockee.id');
    }

    var $blocked = blocked.copyWith(blockeeId: blockee.id);
    await session.db.update(
      $blocked,
      columns: [Blocked.t.blockeeId],
    );
  }
}
