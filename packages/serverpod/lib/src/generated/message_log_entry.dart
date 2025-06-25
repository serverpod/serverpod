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

/// A log entry for a message sent in a streaming session.
abstract class MessageLogEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MessageLogEntry._({
    this.id,
    required this.sessionLogId,
    required this.serverId,
    required this.messageId,
    required this.endpoint,
    required this.messageName,
    required this.duration,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  });

  factory MessageLogEntry({
    int? id,
    required int sessionLogId,
    required String serverId,
    required int messageId,
    required String endpoint,
    required String messageName,
    required double duration,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) = _MessageLogEntryImpl;

  factory MessageLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageLogEntry(
      id: jsonSerialization['id'] as int?,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      serverId: jsonSerialization['serverId'] as String,
      messageId: jsonSerialization['messageId'] as int,
      endpoint: jsonSerialization['endpoint'] as String,
      messageName: jsonSerialization['messageName'] as String,
      duration: (jsonSerialization['duration'] as num).toDouble(),
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      slow: jsonSerialization['slow'] as bool,
      order: jsonSerialization['order'] as int,
    );
  }

  static final t = MessageLogEntryTable();

  static const db = MessageLogEntryRepository._();

  @override
  int? id;

  /// Id of the session this entry is associated with.
  int sessionLogId;

  /// The id of the server that handled the message.
  String serverId;

  /// The id of the message this entry is associated with.
  int messageId;

  /// The endpoint this message is associated with.
  String endpoint;

  /// The class name of the message this entry is associated with.
  String messageName;

  /// The duration of handling of this message.
  double duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  String? error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  String? stackTrace;

  /// The handling of this message was slow.
  bool slow;

  /// Used for sorting the message log.
  int order;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MessageLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MessageLogEntry copyWith({
    int? id,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    String? error,
    String? stackTrace,
    bool? slow,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  static MessageLogEntryInclude include() {
    return MessageLogEntryInclude._();
  }

  static MessageLogEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    MessageLogEntryInclude? include,
  }) {
    return MessageLogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MessageLogEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageLogEntryImpl extends MessageLogEntry {
  _MessageLogEntryImpl({
    int? id,
    required int sessionLogId,
    required String serverId,
    required int messageId,
    required String endpoint,
    required String messageName,
    required double duration,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) : super._(
          id: id,
          sessionLogId: sessionLogId,
          serverId: serverId,
          messageId: messageId,
          endpoint: endpoint,
          messageName: messageName,
          duration: duration,
          error: error,
          stackTrace: stackTrace,
          slow: slow,
          order: order,
        );

  /// Returns a shallow copy of this [MessageLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MessageLogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    bool? slow,
    int? order,
  }) {
    return MessageLogEntry(
      id: id is int? ? id : this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      serverId: serverId ?? this.serverId,
      messageId: messageId ?? this.messageId,
      endpoint: endpoint ?? this.endpoint,
      messageName: messageName ?? this.messageName,
      duration: duration ?? this.duration,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

class MessageLogEntryTable extends _i1.Table<int?> {
  MessageLogEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_message_log') {
    sessionLogId = _i1.ColumnInt(
      'sessionLogId',
      this,
    );
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    messageId = _i1.ColumnInt(
      'messageId',
      this,
    );
    endpoint = _i1.ColumnString(
      'endpoint',
      this,
    );
    messageName = _i1.ColumnString(
      'messageName',
      this,
    );
    duration = _i1.ColumnDouble(
      'duration',
      this,
    );
    error = _i1.ColumnString(
      'error',
      this,
    );
    stackTrace = _i1.ColumnString(
      'stackTrace',
      this,
    );
    slow = _i1.ColumnBool(
      'slow',
      this,
    );
    order = _i1.ColumnInt(
      'order',
      this,
    );
  }

  /// Id of the session this entry is associated with.
  late final _i1.ColumnInt sessionLogId;

  /// The id of the server that handled the message.
  late final _i1.ColumnString serverId;

  /// The id of the message this entry is associated with.
  late final _i1.ColumnInt messageId;

  /// The endpoint this message is associated with.
  late final _i1.ColumnString endpoint;

  /// The class name of the message this entry is associated with.
  late final _i1.ColumnString messageName;

  /// The duration of handling of this message.
  late final _i1.ColumnDouble duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  late final _i1.ColumnString error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  late final _i1.ColumnString stackTrace;

  /// The handling of this message was slow.
  late final _i1.ColumnBool slow;

  /// Used for sorting the message log.
  late final _i1.ColumnInt order;

  @override
  List<_i1.Column> get columns => [
        id,
        sessionLogId,
        serverId,
        messageId,
        endpoint,
        messageName,
        duration,
        error,
        stackTrace,
        slow,
        order,
      ];
}

class MessageLogEntryInclude extends _i1.IncludeObject {
  MessageLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MessageLogEntry.t;
}

class MessageLogEntryIncludeList extends _i1.IncludeList {
  MessageLogEntryIncludeList._({
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MessageLogEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MessageLogEntry.t;
}

class MessageLogEntryRepository {
  const MessageLogEntryRepository._();

  /// Returns a list of [MessageLogEntry]s matching the given query parameters.
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
  Future<List<MessageLogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderByList: orderByList?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MessageLogEntry] matching the given query parameters.
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
  Future<MessageLogEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderByList: orderByList?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MessageLogEntry] by its [id] or null if no such row exists.
  Future<MessageLogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MessageLogEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MessageLogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [MessageLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MessageLogEntry>> insert(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MessageLogEntry] and returns the inserted row.
  ///
  /// The returned [MessageLogEntry] will have its `id` field set.
  Future<MessageLogEntry> insertRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MessageLogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MessageLogEntry>> update(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.ColumnSelections<MessageLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MessageLogEntry>(
      rows,
      columns: columns?.call(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MessageLogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MessageLogEntry> updateRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.ColumnSelections<MessageLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MessageLogEntry>(
      row,
      columns: columns?.call(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MessageLogEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MessageLogEntry>> delete(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MessageLogEntry].
  Future<MessageLogEntry> deleteRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MessageLogEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MessageLogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MessageLogEntry>(
      where: where(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
