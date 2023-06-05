/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ChannelExpressionBuilder = _i1.Expression Function(ChannelTable);

/// Represents a chat channel.
abstract class Channel extends _i1.TableRow {
  const Channel._();

  const factory Channel({
    int? id,
    required String name,
    required String channel,
  }) = _Channel;

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

  static const t = ChannelTable();

  Channel copyWith({
    int? id,
    String? name,
    String? channel,
  });
  @override
  String get tableName => 'channel';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<Channel> insert(
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

  /// The name of the channel.
  String get name;

  /// The id of the channel.
  String get channel;
}

class _Undefined {}

/// Represents a chat channel.
class _Channel extends Channel {
  const _Channel({
    int? id,
    required this.name,
    required this.channel,
  }) : super._();

  /// The name of the channel.
  @override
  final String name;

  /// The id of the channel.
  @override
  final String channel;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is Channel &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel));
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        channel,
      );

  @override
  Channel copyWith({
    Object? id = _Undefined,
    String? name,
    String? channel,
  }) {
    return Channel(
      id: id == _Undefined ? this.id : (id as int?),
      name: name ?? this.name,
      channel: channel ?? this.channel,
    );
  }
}

class ChannelTable extends _i1.Table {
  const ChannelTable() : super(tableName: 'channel');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The name of the channel.
  final name = const _i1.ColumnString('name');

  /// The id of the channel.
  final channel = const _i1.ColumnString('channel');

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        channel,
      ];
}

@Deprecated('Use ChannelTable.t instead.')
ChannelTable tChannel = const ChannelTable();
