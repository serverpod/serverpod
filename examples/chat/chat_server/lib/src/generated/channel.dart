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

/// Represents a chat channel.
abstract class Channel implements _i1.TableRow, _i1.ProtocolSerialization {
  Channel._({
    this.id,
    required this.name,
    required this.channel,
  });

  factory Channel({
    int? id,
    required String name,
    required String channel,
  }) = _ChannelImpl;

  factory Channel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Channel(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      channel: jsonSerialization['channel'] as String,
    );
  }

  static final t = ChannelTable();

  static const db = ChannelRepository._();

  @override
  int? id;

  /// The name of the channel.
  String name;

  /// The id of the channel.
  String channel;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Channel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Channel copyWith({
    int? id,
    String? name,
    String? channel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'channel': channel,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'channel': channel,
    };
  }

  static ChannelInclude include() {
    return ChannelInclude._();
  }

  static ChannelIncludeList includeList({
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChannelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelTable>? orderByList,
    ChannelInclude? include,
  }) {
    return ChannelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Channel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Channel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [Channel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a list of [Channel]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Channel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChannelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Channel>(
      where: where?.call(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Channel] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Channel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChannelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChannelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Channel>(
      where: where?.call(Channel.t),
      orderBy: orderBy?.call(Channel.t),
      orderByList: orderByList?.call(Channel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Channel] by its [id] or null if no such row exists.
  Future<Channel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Channel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Channel]s in the list and returns the inserted rows.
  ///
  /// The returned [Channel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Channel>> insert(
    _i1.Session session,
    List<Channel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Channel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Channel] and returns the inserted row.
  ///
  /// The returned [Channel] will have its `id` field set.
  Future<Channel> insertRow(
    _i1.Session session,
    Channel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Channel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Channel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Channel>> update(
    _i1.Session session,
    List<Channel> rows, {
    _i1.ColumnSelections<ChannelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Channel>(
      rows,
      columns: columns?.call(Channel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Channel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Channel> updateRow(
    _i1.Session session,
    Channel row, {
    _i1.ColumnSelections<ChannelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Channel>(
      row,
      columns: columns?.call(Channel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Channel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Channel>> delete(
    _i1.Session session,
    List<Channel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Channel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Channel].
  Future<Channel> deleteRow(
    _i1.Session session,
    Channel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Channel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Channel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChannelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Channel>(
      where: where(Channel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChannelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Channel>(
      where: where?.call(Channel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
