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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart'
    as _i99s0abf;

/// Database table for tracking rate limited request attempts.
/// A new entry will be created whenever the request is attempted.
abstract class RateLimitedRequestAttempt
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  RateLimitedRequestAttempt._({
    this.id,
    required this.domain,
    required this.source,
    required this.nonce,
    this.ipAddress,
    DateTime? attemptedAt,
    this.extraData,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory RateLimitedRequestAttempt({
    _is.UuidValue? id,
    required String domain,
    required String source,
    required String nonce,
    String? ipAddress,
    DateTime? attemptedAt,
    Map<String, String>? extraData,
  }) = _RateLimitedRequestAttemptImpl;

  factory RateLimitedRequestAttempt.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RateLimitedRequestAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      domain: jsonSerialization['domain'] as String,
      source: jsonSerialization['source'] as String,
      nonce: jsonSerialization['nonce'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      attemptedAt: jsonSerialization['attemptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['attemptedAt'],
            ),
      extraData: jsonSerialization['extraData'] == null
          ? null
          : _i99s0abf.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['extraData'],
            ),
    );
  }

  static final t = RateLimitedRequestAttemptTable();

  static const db = RateLimitedRequestAttemptRepository._();

  @override
  _is.UuidValue? id;

  /// The domain of the attempt.
  /// Example: "email", "sms", etc.
  String domain;

  /// The source of the attempt.
  /// Example: "password_reset", "login_attempt", etc.
  String source;

  /// The unique identifier for the request.
  /// Can be a request ID, a token, an email address, etc.
  String nonce;

  /// The IP address calling the request, in case it is relevant.
  /// Should only be used for logging and auditing purposes.
  String? ipAddress;

  /// The time of the attempt.
  DateTime attemptedAt;

  /// Additional data to be logged for the attempt.
  Map<String, String>? extraData;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RateLimitedRequestAttempt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RateLimitedRequestAttempt copyWith({
    _is.UuidValue? id,
    String? domain,
    String? source,
    String? nonce,
    String? ipAddress,
    DateTime? attemptedAt,
    Map<String, String>? extraData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.RateLimitedRequestAttempt',
      if (id != null) 'id': id?.toJson(),
      'domain': domain,
      'source': source,
      'nonce': nonce,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'attemptedAt': attemptedAt.toJson(),
      if (extraData != null) 'extraData': extraData?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static RateLimitedRequestAttemptInclude include({
    _is.SelectColumnsBuilder<RateLimitedRequestAttemptTable>? select,
  }) {
    return RateLimitedRequestAttemptInclude._(
      selectedColumns: select?.call(RateLimitedRequestAttempt.t),
    );
  }

  static RateLimitedRequestAttemptIncludeList includeList({
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    RateLimitedRequestAttemptInclude? include,
    _is.SelectColumnsBuilder<RateLimitedRequestAttemptTable>? select,
  }) {
    return RateLimitedRequestAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      include: include,
      selectedColumns: select?.call(RateLimitedRequestAttempt.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RateLimitedRequestAttemptImpl extends RateLimitedRequestAttempt {
  _RateLimitedRequestAttemptImpl({
    _is.UuidValue? id,
    required String domain,
    required String source,
    required String nonce,
    String? ipAddress,
    DateTime? attemptedAt,
    Map<String, String>? extraData,
  }) : super._(
         id: id,
         domain: domain,
         source: source,
         nonce: nonce,
         ipAddress: ipAddress,
         attemptedAt: attemptedAt,
         extraData: extraData,
       );

  /// Returns a shallow copy of this [RateLimitedRequestAttempt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RateLimitedRequestAttempt copyWith({
    Object? id = _Undefined,
    String? domain,
    String? source,
    String? nonce,
    Object? ipAddress = _Undefined,
    DateTime? attemptedAt,
    Object? extraData = _Undefined,
  }) {
    return RateLimitedRequestAttempt(
      id: id is _is.UuidValue? ? id : this.id,
      domain: domain ?? this.domain,
      source: source ?? this.source,
      nonce: nonce ?? this.nonce,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      extraData: extraData is Map<String, String>?
          ? extraData
          : this.extraData?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
    );
  }
}

class RateLimitedRequestAttemptUpdateTable
    extends _is.UpdateTable<RateLimitedRequestAttemptTable> {
  RateLimitedRequestAttemptUpdateTable(super.table);

  _is.ColumnValue<String, String> domain(String value) => _is.ColumnValue(
    table.domain,
    value,
  );

  _is.ColumnValue<String, String> source(String value) => _is.ColumnValue(
    table.source,
    value,
  );

  _is.ColumnValue<String, String> nonce(String value) => _is.ColumnValue(
    table.nonce,
    value,
  );

  _is.ColumnValue<String, String> ipAddress(String? value) => _is.ColumnValue(
    table.ipAddress,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> attemptedAt(DateTime value) =>
      _is.ColumnValue(
        table.attemptedAt,
        value,
      );

  _is.ColumnValue<Map<String, String>, Map<String, String>> extraData(
    Map<String, String>? value,
  ) => _is.ColumnValue(
    table.extraData,
    value,
  );
}

class RateLimitedRequestAttemptTable extends _is.Table<_is.UuidValue?> {
  RateLimitedRequestAttemptTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_rate_limited_request_attempt') {
    updateTable = RateLimitedRequestAttemptUpdateTable(this);
    domain = _is.ColumnString(
      'domain',
      this,
    );
    source = _is.ColumnString(
      'source',
      this,
    );
    nonce = _is.ColumnString(
      'nonce',
      this,
    );
    ipAddress = _is.ColumnString(
      'ipAddress',
      this,
    );
    attemptedAt = _is.ColumnDateTime(
      'attemptedAt',
      this,
    );
    extraData = _is.ColumnSerializable<Map<String, String>>(
      'extraData',
      this,
    );
  }

  late final RateLimitedRequestAttemptUpdateTable updateTable;

  /// The domain of the attempt.
  /// Example: "email", "sms", etc.
  late final _is.ColumnString domain;

  /// The source of the attempt.
  /// Example: "password_reset", "login_attempt", etc.
  late final _is.ColumnString source;

  /// The unique identifier for the request.
  /// Can be a request ID, a token, an email address, etc.
  late final _is.ColumnString nonce;

  /// The IP address calling the request, in case it is relevant.
  /// Should only be used for logging and auditing purposes.
  late final _is.ColumnString ipAddress;

  /// The time of the attempt.
  late final _is.ColumnDateTime attemptedAt;

  /// Additional data to be logged for the attempt.
  late final _is.ColumnSerializable<Map<String, String>> extraData;

  @override
  List<_is.Column> get columns => [
    id,
    domain,
    source,
    nonce,
    ipAddress,
    attemptedAt,
    extraData,
  ];
}

class RateLimitedRequestAttemptInclude extends _is.IncludeObject {
  RateLimitedRequestAttemptInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => RateLimitedRequestAttempt.t;
}

class RateLimitedRequestAttemptIncludeList extends _is.IncludeList {
  RateLimitedRequestAttemptIncludeList._({
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RateLimitedRequestAttempt.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => RateLimitedRequestAttempt.t;
}

class RateLimitedRequestAttemptRepository {
  const RateLimitedRequestAttemptRepository._();

  /// Returns a list of [RateLimitedRequestAttempt]s matching the given query parameters.
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
  Future<List<RateLimitedRequestAttempt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RateLimitedRequestAttempt] matching the given query parameters.
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
  Future<RateLimitedRequestAttempt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RateLimitedRequestAttempt] by its [id] or null if no such row exists.
  Future<RateLimitedRequestAttempt?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RateLimitedRequestAttempt>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<RateLimitedRequestAttemptTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(RateLimitedRequestAttempt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<RateLimitedRequestAttemptTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(RateLimitedRequestAttempt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<RateLimitedRequestAttemptTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<RateLimitedRequestAttempt>(
      id,
      transaction: transaction,
      select: select?.call(RateLimitedRequestAttempt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RateLimitedRequestAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [RateLimitedRequestAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> insert(
    _is.DatabaseSession session,
    List<RateLimitedRequestAttempt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RateLimitedRequestAttempt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RateLimitedRequestAttempt] and returns the inserted row.
  ///
  /// The returned [RateLimitedRequestAttempt] will have its `id` field set.
  Future<RateLimitedRequestAttempt> insertRow(
    _is.DatabaseSession session,
    RateLimitedRequestAttempt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RateLimitedRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RateLimitedRequestAttempt]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [RateLimitedRequestAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> upsert(
    _is.DatabaseSession session,
    List<RateLimitedRequestAttempt> rows, {
    required _is.ColumnSelections<RateLimitedRequestAttemptTable>
    conflictColumns,
    _is.ColumnSelections<RateLimitedRequestAttemptTable>? updateColumns,
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RateLimitedRequestAttempt>(
      rows,
      conflictColumns: conflictColumns(RateLimitedRequestAttempt.t),
      updateColumns: updateColumns?.call(RateLimitedRequestAttempt.t),
      updateWhere: updateWhere?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RateLimitedRequestAttempt] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [RateLimitedRequestAttempt] will have its `id` field set.
  Future<RateLimitedRequestAttempt?> upsertRow(
    _is.DatabaseSession session,
    RateLimitedRequestAttempt row, {
    required _is.ColumnSelections<RateLimitedRequestAttemptTable>
    conflictColumns,
    _is.ColumnSelections<RateLimitedRequestAttemptTable>? updateColumns,
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RateLimitedRequestAttempt>(
      row,
      conflictColumns: conflictColumns(RateLimitedRequestAttempt.t),
      updateColumns: updateColumns?.call(RateLimitedRequestAttempt.t),
      updateWhere: updateWhere?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates all [RateLimitedRequestAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> update(
    _is.DatabaseSession session,
    List<RateLimitedRequestAttempt> rows, {
    _is.ColumnSelections<RateLimitedRequestAttemptTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RateLimitedRequestAttempt>(
      rows,
      columns: columns?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RateLimitedRequestAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RateLimitedRequestAttempt> updateRow(
    _is.DatabaseSession session,
    RateLimitedRequestAttempt row, {
    _is.ColumnSelections<RateLimitedRequestAttemptTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RateLimitedRequestAttempt>(
      row,
      columns: columns?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RateLimitedRequestAttempt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RateLimitedRequestAttempt?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<RateLimitedRequestAttemptUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RateLimitedRequestAttempt>(
      id,
      columnValues: columnValues(RateLimitedRequestAttempt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RateLimitedRequestAttempt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RateLimitedRequestAttemptUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RateLimitedRequestAttempt>(
      columnValues: columnValues(RateLimitedRequestAttempt.t.updateTable),
      where: where(RateLimitedRequestAttempt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RateLimitedRequestAttempt]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> delete(
    _is.DatabaseSession session,
    List<RateLimitedRequestAttempt> rows, {
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RateLimitedRequestAttempt>(
      rows,
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RateLimitedRequestAttempt].
  Future<RateLimitedRequestAttempt> deleteRow(
    _is.DatabaseSession session,
    RateLimitedRequestAttempt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RateLimitedRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateLimitedRequestAttempt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    _is.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _is.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RateLimitedRequestAttempt>(
      where: where(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RateLimitedRequestAttempt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RateLimitedRequestAttempt>(
      where: where(RateLimitedRequestAttempt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
