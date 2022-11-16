/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class Channel extends _i1.TableRow {
  Channel({
    int? id,
    required this.name,
    required this.channel,
  }) : super(id);

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

  String name;

  String channel;

  @override
  String get tableName => 'channel';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
  }

  @override
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

  static Future<List<Channel>> find(
    _i1.Session session, {
    ChannelExpressionBuilder? where,
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

  static Future<Channel?> findSingleRow(
    _i1.Session session, {
    ChannelExpressionBuilder? where,
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

  static Future<Channel?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Channel>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ChannelExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Channel>(
      where: where(Channel.t),
      transaction: transaction,
    );
  }

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

  static Future<int> count(
    _i1.Session session, {
    ChannelExpressionBuilder? where,
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
}

typedef ChannelExpressionBuilder = _i1.Expression Function(ChannelTable);

class ChannelTable extends _i1.Table {
  ChannelTable() : super(tableName: 'channel');

  final id = _i1.ColumnInt('id');

  final name = _i1.ColumnString('name');

  final channel = _i1.ColumnString('channel');

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        channel,
      ];
}

@Deprecated('Use ChannelTable.t instead.')
ChannelTable tChannel = ChannelTable();
