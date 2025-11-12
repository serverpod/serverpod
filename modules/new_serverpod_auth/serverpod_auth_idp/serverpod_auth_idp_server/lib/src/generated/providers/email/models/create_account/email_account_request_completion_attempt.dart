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

/// Database table for tracking email account completion requests.
/// A new entry will be created whenever the user tries to complete the email account setup.
abstract class EmailAccountRequestCompletionAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountRequestCompletionAttempt._({
    this.id,
    DateTime? attemptedAt,
    required this.ipAddress,
    required this.emailAccountRequestId,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountRequestCompletionAttempt({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue emailAccountRequestId,
  }) = _EmailAccountRequestCompletionAttemptImpl;

  factory EmailAccountRequestCompletionAttempt.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAccountRequestCompletionAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      attemptedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['attemptedAt'],
      ),
      ipAddress: jsonSerialization['ipAddress'] as String,
      emailAccountRequestId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['emailAccountRequestId'],
      ),
    );
  }

  static final t = EmailAccountRequestCompletionAttemptTable();

  static const db = EmailAccountRequestCompletionAttemptRepository._();

  @override
  _i1.UuidValue? id;

  /// The time of the reset attempt.
  DateTime attemptedAt;

  /// The IP address of the sign in attempt.
  String ipAddress;

  /// The ID of the email account request.
  /// This is explicitly not a relation to be able to track dummy requests.
  _i1.UuidValue emailAccountRequestId;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountRequestCompletionAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountRequestCompletionAttempt copyWith({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? emailAccountRequestId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'attemptedAt': attemptedAt.toJson(),
      'ipAddress': ipAddress,
      'emailAccountRequestId': emailAccountRequestId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountRequestCompletionAttemptInclude include() {
    return EmailAccountRequestCompletionAttemptInclude._();
  }

  static EmailAccountRequestCompletionAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestCompletionAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestCompletionAttemptTable>?
    orderByList,
    EmailAccountRequestCompletionAttemptInclude? include,
  }) {
    return EmailAccountRequestCompletionAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountRequestCompletionAttemptImpl
    extends EmailAccountRequestCompletionAttempt {
  _EmailAccountRequestCompletionAttemptImpl({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue emailAccountRequestId,
  }) : super._(
         id: id,
         attemptedAt: attemptedAt,
         ipAddress: ipAddress,
         emailAccountRequestId: emailAccountRequestId,
       );

  /// Returns a shallow copy of this [EmailAccountRequestCompletionAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountRequestCompletionAttempt copyWith({
    Object? id = _Undefined,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? emailAccountRequestId,
  }) {
    return EmailAccountRequestCompletionAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      emailAccountRequestId:
          emailAccountRequestId ?? this.emailAccountRequestId,
    );
  }
}

class EmailAccountRequestCompletionAttemptUpdateTable
    extends _i1.UpdateTable<EmailAccountRequestCompletionAttemptTable> {
  EmailAccountRequestCompletionAttemptUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> attemptedAt(DateTime value) =>
      _i1.ColumnValue(
        table.attemptedAt,
        value,
      );

  _i1.ColumnValue<String, String> ipAddress(String value) => _i1.ColumnValue(
    table.ipAddress,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> emailAccountRequestId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.emailAccountRequestId,
    value,
  );
}

class EmailAccountRequestCompletionAttemptTable
    extends _i1.Table<_i1.UuidValue?> {
  EmailAccountRequestCompletionAttemptTable({super.tableRelation})
    : super(tableName: 'serverpod_auth_idp_email_account_request_completion') {
    updateTable = EmailAccountRequestCompletionAttemptUpdateTable(this);
    attemptedAt = _i1.ColumnDateTime(
      'attemptedAt',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    emailAccountRequestId = _i1.ColumnUuid(
      'emailAccountRequestId',
      this,
    );
  }

  late final EmailAccountRequestCompletionAttemptUpdateTable updateTable;

  /// The time of the reset attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  /// The ID of the email account request.
  /// This is explicitly not a relation to be able to track dummy requests.
  late final _i1.ColumnUuid emailAccountRequestId;

  @override
  List<_i1.Column> get columns => [
    id,
    attemptedAt,
    ipAddress,
    emailAccountRequestId,
  ];
}

class EmailAccountRequestCompletionAttemptInclude extends _i1.IncludeObject {
  EmailAccountRequestCompletionAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountRequestCompletionAttempt.t;
}

class EmailAccountRequestCompletionAttemptIncludeList extends _i1.IncludeList {
  EmailAccountRequestCompletionAttemptIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>?
    where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountRequestCompletionAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountRequestCompletionAttempt.t;
}

class EmailAccountRequestCompletionAttemptRepository {
  const EmailAccountRequestCompletionAttemptRepository._();

  /// Returns a list of [EmailAccountRequestCompletionAttempt]s matching the given query parameters.
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
  Future<List<EmailAccountRequestCompletionAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>?
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestCompletionAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestCompletionAttemptTable>?
    orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountRequestCompletionAttempt>(
      where: where?.call(EmailAccountRequestCompletionAttempt.t),
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountRequestCompletionAttempt] matching the given query parameters.
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
  Future<EmailAccountRequestCompletionAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>?
    where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestCompletionAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountRequestCompletionAttemptTable>?
    orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountRequestCompletionAttempt>(
      where: where?.call(EmailAccountRequestCompletionAttempt.t),
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountRequestCompletionAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountRequestCompletionAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountRequestCompletionAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountRequestCompletionAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountRequestCompletionAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountRequestCompletionAttempt>> insert(
    _i1.Session session,
    List<EmailAccountRequestCompletionAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountRequestCompletionAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountRequestCompletionAttempt] and returns the inserted row.
  ///
  /// The returned [EmailAccountRequestCompletionAttempt] will have its `id` field set.
  Future<EmailAccountRequestCompletionAttempt> insertRow(
    _i1.Session session,
    EmailAccountRequestCompletionAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountRequestCompletionAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequestCompletionAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountRequestCompletionAttempt>> update(
    _i1.Session session,
    List<EmailAccountRequestCompletionAttempt> rows, {
    _i1.ColumnSelections<EmailAccountRequestCompletionAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountRequestCompletionAttempt>(
      rows,
      columns: columns?.call(EmailAccountRequestCompletionAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountRequestCompletionAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountRequestCompletionAttempt> updateRow(
    _i1.Session session,
    EmailAccountRequestCompletionAttempt row, {
    _i1.ColumnSelections<EmailAccountRequestCompletionAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountRequestCompletionAttempt>(
      row,
      columns: columns?.call(EmailAccountRequestCompletionAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountRequestCompletionAttempt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountRequestCompletionAttempt?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<
      EmailAccountRequestCompletionAttemptUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountRequestCompletionAttempt>(
      id,
      columnValues: columnValues(
        EmailAccountRequestCompletionAttempt.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountRequestCompletionAttempt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailAccountRequestCompletionAttempt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<
      EmailAccountRequestCompletionAttemptUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<
      EmailAccountRequestCompletionAttemptTable
    >
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountRequestCompletionAttemptTable>? orderBy,
    _i1.OrderByListBuilder<EmailAccountRequestCompletionAttemptTable>?
    orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailAccountRequestCompletionAttempt>(
      columnValues: columnValues(
        EmailAccountRequestCompletionAttempt.t.updateTable,
      ),
      where: where(EmailAccountRequestCompletionAttempt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountRequestCompletionAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountRequestCompletionAttempt>> delete(
    _i1.Session session,
    List<EmailAccountRequestCompletionAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountRequestCompletionAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountRequestCompletionAttempt].
  Future<EmailAccountRequestCompletionAttempt> deleteRow(
    _i1.Session session,
    EmailAccountRequestCompletionAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountRequestCompletionAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountRequestCompletionAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<
      EmailAccountRequestCompletionAttemptTable
    >
    where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountRequestCompletionAttempt>(
      where: where(EmailAccountRequestCompletionAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>?
    where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountRequestCompletionAttempt>(
      where: where?.call(EmailAccountRequestCompletionAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
