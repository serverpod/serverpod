/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Represents a chat channel.
abstract class Channel extends _i1.TableRow {
  Channel._({
    int? id,
    required this.name,
    required this.channel,
  }) : super(id);

  factory Channel({
    int? id,
    required String name,
    required String channel,
  }) = _ChannelImpl;

  factory Channel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Channel(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
    );
  }

  static final t = ChannelTable();

  static const db = ChannelRepository._();

  /// The name of the channel.
  String name;

  /// The id of the channel.
  String channel;

  @override
  _i1.Table get table => t;

  Channel copyWith({
    int? id,
    String? name,
    String? channel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
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
      case 'channel':
        channel = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Channel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Channel>(
      where: where != null ? where(Channel.t) : null,
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
  static Future<Channel?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Channel>(
      where: where != null ? where(Channel.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Channel?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Channel>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChannelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Channel>(
      where: where(Channel.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Channel row, {
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
    Channel row, {
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
    Channel row, {
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
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Channel>(
      where: where != null ? where(Channel.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ChannelInclude include() {
    return ChannelInclude._();
  }

  static ChannelIncludeList includeList({
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    ChannelInclude? include,
  }) {
    return ChannelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _ChannelImpl extends Channel {
  _ChannelImpl({
    int? id,
    required String name,
    required String channel,
  }) : super._(
          id: id,
          name: name,
          channel: channel,
        );

  @override
  Channel copyWith({
    Object? id = _Undefined,
    String? name,
    String? channel,
  }) {
    return Channel(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      channel: channel ?? this.channel,
    );
  }
}

class ChannelTable extends _i1.Table {
  ChannelTable({super.tableRelation}) : super(tableName: 'channel') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    channel = _i1.ColumnString(
      'channel',
      this,
    );
  }

  /// The name of the channel.
  late final _i1.ColumnString name;

  /// The id of the channel.
  late final _i1.ColumnString channel;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        channel,
      ];
}

@Deprecated('Use ChannelTable.t instead.')
ChannelTable tChannel = ChannelTable();

class ChannelInclude extends _i1.IncludeObject {
  ChannelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Channel.t;
}

class ChannelIncludeList extends _i1.IncludeList {
  ChannelIncludeList._({
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Channel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Channel.t;
}

class ChannelRepository {
  const ChannelRepository._();

  Future<List<Channel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<Channel>(
      where: where?.call(Channel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<Channel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<Channel>(
      where: where?.call(Channel.t),
      transaction: transaction,
    );
  }

  Future<Channel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<Channel>(
      id,
      transaction: transaction,
    );
  }

  Future<List<Channel>> insert(
    _i1.Session session,
    List<Channel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Channel>(
      rows,
      transaction: transaction,
    );
  }

  Future<Channel> insertRow(
    _i1.Session session,
    Channel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Channel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Channel>> update(
    _i1.Session session,
    List<Channel> rows, {
    _i1.ColumnSelections<ChannelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Channel>(
      rows,
      columns: columns?.call(Channel.t),
      transaction: transaction,
    );
  }

  Future<Channel> updateRow(
    _i1.Session session,
    Channel row, {
    _i1.ColumnSelections<ChannelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Channel>(
      row,
      columns: columns?.call(Channel.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Channel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Channel>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Channel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Channel>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChannelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Channel>(
      where: where(Channel.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Channel>(
      where: where?.call(Channel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
