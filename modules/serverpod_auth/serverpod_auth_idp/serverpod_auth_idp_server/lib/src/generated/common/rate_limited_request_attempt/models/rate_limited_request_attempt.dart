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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_idp_server/src/generated/protocol.dart' as _i2;

/// Database table for tracking rate limited request attempts.
/// A new entry will be created whenever the request is attempted.
abstract class RateLimitedRequestAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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
    _i1.UuidValue? id,
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
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      domain: jsonSerialization['domain'] as String,
      source: jsonSerialization['source'] as String,
      nonce: jsonSerialization['nonce'] as String,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      attemptedAt: jsonSerialization['attemptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['attemptedAt'],
            ),
      extraData: jsonSerialization['extraData'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['extraData'],
            ),
    );
  }

  static final t = RateLimitedRequestAttemptTable();

  static const db = RateLimitedRequestAttemptRepository._();

  @override
  _i1.UuidValue? id;

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
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RateLimitedRequestAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RateLimitedRequestAttempt copyWith({
    _i1.UuidValue? id,
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

  static RateLimitedRequestAttemptInclude include() {
    return RateLimitedRequestAttemptInclude._();
  }

  static RateLimitedRequestAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    RateLimitedRequestAttemptInclude? include,
  }) {
    return RateLimitedRequestAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RateLimitedRequestAttemptImpl extends RateLimitedRequestAttempt {
  _RateLimitedRequestAttemptImpl({
    _i1.UuidValue? id,
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
  @_i1.useResult
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
      id: id is _i1.UuidValue? ? id : this.id,
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
    extends _i1.UpdateTable<RateLimitedRequestAttemptTable> {
  RateLimitedRequestAttemptUpdateTable(super.table);

  _i1.ColumnValue<String, String> domain(String value) => _i1.ColumnValue(
    table.domain,
    value,
  );

  _i1.ColumnValue<String, String> source(String value) => _i1.ColumnValue(
    table.source,
    value,
  );

  _i1.ColumnValue<String, String> nonce(String value) => _i1.ColumnValue(
    table.nonce,
    value,
  );

  _i1.ColumnValue<String, String> ipAddress(String? value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> attemptedAt(DateTime value) =>
      _i1.ColumnValue(
        table.attemptedAt,
        value,
      );

  _i1.ColumnValue<Map<String, String>, Map<String, String>> extraData(
    Map<String, String>? value,
  ) => _i1.ColumnValue(
    table.extraData,
    value,
  );
}

class RateLimitedRequestAttemptTable extends _i1.Table<_i1.UuidValue?> {
  RateLimitedRequestAttemptTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_rate_limited_request_attempt') {
    updateTable = RateLimitedRequestAttemptUpdateTable(this);
    domain = _i1.ColumnString(
      'domain',
      this,
    );
    source = _i1.ColumnString(
      'source',
      this,
    );
    nonce = _i1.ColumnString(
      'nonce',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    attemptedAt = _i1.ColumnDateTime(
      'attemptedAt',
      this,
    );
    extraData = _i1.ColumnSerializable<Map<String, String>>(
      'extraData',
      this,
    );
  }

  late final RateLimitedRequestAttemptUpdateTable updateTable;

  /// The domain of the attempt.
  /// Example: "email", "sms", etc.
  late final _i1.ColumnString domain;

  /// The source of the attempt.
  /// Example: "password_reset", "login_attempt", etc.
  late final _i1.ColumnString source;

  /// The unique identifier for the request.
  /// Can be a request ID, a token, an email address, etc.
  late final _i1.ColumnString nonce;

  /// The IP address calling the request, in case it is relevant.
  /// Should only be used for logging and auditing purposes.
  late final _i1.ColumnString ipAddress;

  /// The time of the attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// Additional data to be logged for the attempt.
  late final _i1.ColumnSerializable<Map<String, String>> extraData;

  @override
  List<_i1.Column> get columns => [
    id,
    domain,
    source,
    nonce,
    ipAddress,
    attemptedAt,
    extraData,
  ];
}

class RateLimitedRequestAttemptInclude extends _i1.IncludeObject {
  RateLimitedRequestAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => RateLimitedRequestAttempt.t;
}

class RateLimitedRequestAttemptIncludeList extends _i1.IncludeList {
  RateLimitedRequestAttemptIncludeList._({
    _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RateLimitedRequestAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => RateLimitedRequestAttempt.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      orderDescending: orderDescending,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? offset,
    _i1.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RateLimitedRequestAttempt] by its [id] or null if no such row exists.
  Future<RateLimitedRequestAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RateLimitedRequestAttempt>(
      id,
      transaction: transaction,
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
  Future<List<RateLimitedRequestAttempt>> insert(
    _i1.Session session,
    List<RateLimitedRequestAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RateLimitedRequestAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [RateLimitedRequestAttempt] and returns the inserted row.
  ///
  /// The returned [RateLimitedRequestAttempt] will have its `id` field set.
  Future<RateLimitedRequestAttempt> insertRow(
    _i1.Session session,
    RateLimitedRequestAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RateLimitedRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RateLimitedRequestAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RateLimitedRequestAttempt>> update(
    _i1.Session session,
    List<RateLimitedRequestAttempt> rows, {
    _i1.ColumnSelections<RateLimitedRequestAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RateLimitedRequestAttempt>(
      rows,
      columns: columns?.call(RateLimitedRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RateLimitedRequestAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RateLimitedRequestAttempt> updateRow(
    _i1.Session session,
    RateLimitedRequestAttempt row, {
    _i1.ColumnSelections<RateLimitedRequestAttemptTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<RateLimitedRequestAttemptUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RateLimitedRequestAttempt>(
      id,
      columnValues: columnValues(RateLimitedRequestAttempt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RateLimitedRequestAttempt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RateLimitedRequestAttempt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RateLimitedRequestAttemptUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RateLimitedRequestAttemptTable>? orderBy,
    _i1.OrderByListBuilder<RateLimitedRequestAttemptTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RateLimitedRequestAttempt>(
      columnValues: columnValues(RateLimitedRequestAttempt.t.updateTable),
      where: where(RateLimitedRequestAttempt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateLimitedRequestAttempt.t),
      orderByList: orderByList?.call(RateLimitedRequestAttempt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RateLimitedRequestAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RateLimitedRequestAttempt>> delete(
    _i1.Session session,
    List<RateLimitedRequestAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RateLimitedRequestAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RateLimitedRequestAttempt].
  Future<RateLimitedRequestAttempt> deleteRow(
    _i1.Session session,
    RateLimitedRequestAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RateLimitedRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RateLimitedRequestAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RateLimitedRequestAttempt>(
      where: where(RateLimitedRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RateLimitedRequestAttempt>(
      where: where?.call(RateLimitedRequestAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RateLimitedRequestAttempt] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RateLimitedRequestAttemptTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RateLimitedRequestAttempt>(
      where: where(RateLimitedRequestAttempt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
