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

/// Database table for tracking password reset attempts.
/// A new entry will be created whenever the user tries to complete the password reset.
abstract class EmailAccountPasswordResetCompleteAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountPasswordResetCompleteAttempt._({
    this.id,
    DateTime? attemptedAt,
    required this.ipAddress,
    required this.passwordResetRequestId,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountPasswordResetCompleteAttempt({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue passwordResetRequestId,
  }) = _EmailAccountPasswordResetCompleteAttemptImpl;

  factory EmailAccountPasswordResetCompleteAttempt.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetCompleteAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      attemptedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['attemptedAt']),
      ipAddress: jsonSerialization['ipAddress'] as String,
      passwordResetRequestId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['passwordResetRequestId']),
    );
  }

  static final t = EmailAccountPasswordResetCompleteAttemptTable();

  static const db = EmailAccountPasswordResetCompleteAttemptRepository._();

  @override
  _i1.UuidValue? id;

  /// The time of the reset attempt.
  DateTime attemptedAt;

  /// The IP address of the sign in attempt.
  String ipAddress;

  /// The ID of the password reset request.
  /// This is explicitly not a relation to be able to track dummy requests.
  _i1.UuidValue passwordResetRequestId;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountPasswordResetCompleteAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetCompleteAttempt copyWith({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? passwordResetRequestId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'attemptedAt': attemptedAt.toJson(),
      'ipAddress': ipAddress,
      'passwordResetRequestId': passwordResetRequestId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static EmailAccountPasswordResetCompleteAttemptInclude include() {
    return EmailAccountPasswordResetCompleteAttemptInclude._();
  }

  static EmailAccountPasswordResetCompleteAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetCompleteAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        orderByList,
    EmailAccountPasswordResetCompleteAttemptInclude? include,
  }) {
    return EmailAccountPasswordResetCompleteAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderDescending: orderDescending,
      orderByList:
          orderByList?.call(EmailAccountPasswordResetCompleteAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetCompleteAttemptImpl
    extends EmailAccountPasswordResetCompleteAttempt {
  _EmailAccountPasswordResetCompleteAttemptImpl({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue passwordResetRequestId,
  }) : super._(
          id: id,
          attemptedAt: attemptedAt,
          ipAddress: ipAddress,
          passwordResetRequestId: passwordResetRequestId,
        );

  /// Returns a shallow copy of this [EmailAccountPasswordResetCompleteAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetCompleteAttempt copyWith({
    Object? id = _Undefined,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? passwordResetRequestId,
  }) {
    return EmailAccountPasswordResetCompleteAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      passwordResetRequestId:
          passwordResetRequestId ?? this.passwordResetRequestId,
    );
  }
}

class EmailAccountPasswordResetCompleteAttemptUpdateTable
    extends _i1.UpdateTable<EmailAccountPasswordResetCompleteAttemptTable> {
  EmailAccountPasswordResetCompleteAttemptUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> attemptedAt(DateTime value) =>
      _i1.ColumnValue(
        table.attemptedAt,
        value,
      );

  _i1.ColumnValue<String, String> ipAddress(String value) => _i1.ColumnValue(
        table.ipAddress,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> passwordResetRequestId(
          _i1.UuidValue value) =>
      _i1.ColumnValue(
        table.passwordResetRequestId,
        value,
      );
}

class EmailAccountPasswordResetCompleteAttemptTable
    extends _i1.Table<_i1.UuidValue?> {
  EmailAccountPasswordResetCompleteAttemptTable({super.tableRelation})
      : super(
            tableName:
                'serverpod_auth_idp_email_account_password_reset_complete') {
    updateTable = EmailAccountPasswordResetCompleteAttemptUpdateTable(this);
    attemptedAt = _i1.ColumnDateTime(
      'attemptedAt',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    passwordResetRequestId = _i1.ColumnUuid(
      'passwordResetRequestId',
      this,
    );
  }

  late final EmailAccountPasswordResetCompleteAttemptUpdateTable updateTable;

  /// The time of the reset attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  /// The ID of the password reset request.
  /// This is explicitly not a relation to be able to track dummy requests.
  late final _i1.ColumnUuid passwordResetRequestId;

  @override
  List<_i1.Column> get columns => [
        id,
        attemptedAt,
        ipAddress,
        passwordResetRequestId,
      ];
}

class EmailAccountPasswordResetCompleteAttemptInclude
    extends _i1.IncludeObject {
  EmailAccountPasswordResetCompleteAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table =>
      EmailAccountPasswordResetCompleteAttempt.t;
}

class EmailAccountPasswordResetCompleteAttemptIncludeList
    extends _i1.IncludeList {
  EmailAccountPasswordResetCompleteAttemptIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountPasswordResetCompleteAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table =>
      EmailAccountPasswordResetCompleteAttempt.t;
}

class EmailAccountPasswordResetCompleteAttemptRepository {
  const EmailAccountPasswordResetCompleteAttemptRepository._();

  /// Returns a list of [EmailAccountPasswordResetCompleteAttempt]s matching the given query parameters.
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
  Future<List<EmailAccountPasswordResetCompleteAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetCompleteAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountPasswordResetCompleteAttempt>(
      where: where?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderByList:
          orderByList?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountPasswordResetCompleteAttempt] matching the given query parameters.
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
  Future<EmailAccountPasswordResetCompleteAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetCompleteAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountPasswordResetCompleteAttempt>(
      where: where?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderByList:
          orderByList?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountPasswordResetCompleteAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountPasswordResetCompleteAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountPasswordResetCompleteAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountPasswordResetCompleteAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountPasswordResetCompleteAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountPasswordResetCompleteAttempt>> insert(
    _i1.Session session,
    List<EmailAccountPasswordResetCompleteAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountPasswordResetCompleteAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountPasswordResetCompleteAttempt] and returns the inserted row.
  ///
  /// The returned [EmailAccountPasswordResetCompleteAttempt] will have its `id` field set.
  Future<EmailAccountPasswordResetCompleteAttempt> insertRow(
    _i1.Session session,
    EmailAccountPasswordResetCompleteAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountPasswordResetCompleteAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetCompleteAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountPasswordResetCompleteAttempt>> update(
    _i1.Session session,
    List<EmailAccountPasswordResetCompleteAttempt> rows, {
    _i1.ColumnSelections<EmailAccountPasswordResetCompleteAttemptTable>?
        columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountPasswordResetCompleteAttempt>(
      rows,
      columns: columns?.call(EmailAccountPasswordResetCompleteAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetCompleteAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountPasswordResetCompleteAttempt> updateRow(
    _i1.Session session,
    EmailAccountPasswordResetCompleteAttempt row, {
    _i1.ColumnSelections<EmailAccountPasswordResetCompleteAttemptTable>?
        columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountPasswordResetCompleteAttempt>(
      row,
      columns: columns?.call(EmailAccountPasswordResetCompleteAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetCompleteAttempt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmailAccountPasswordResetCompleteAttempt?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<
            EmailAccountPasswordResetCompleteAttemptUpdateTable>
        columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EmailAccountPasswordResetCompleteAttempt>(
      id,
      columnValues:
          columnValues(EmailAccountPasswordResetCompleteAttempt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetCompleteAttempt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EmailAccountPasswordResetCompleteAttempt>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<
            EmailAccountPasswordResetCompleteAttemptUpdateTable>
        columnValues,
    required _i1
        .WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetCompleteAttemptTable>? orderBy,
    _i1.OrderByListBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EmailAccountPasswordResetCompleteAttempt>(
      columnValues:
          columnValues(EmailAccountPasswordResetCompleteAttempt.t.updateTable),
      where: where(EmailAccountPasswordResetCompleteAttempt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderByList:
          orderByList?.call(EmailAccountPasswordResetCompleteAttempt.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountPasswordResetCompleteAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountPasswordResetCompleteAttempt>> delete(
    _i1.Session session,
    List<EmailAccountPasswordResetCompleteAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountPasswordResetCompleteAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountPasswordResetCompleteAttempt].
  Future<EmailAccountPasswordResetCompleteAttempt> deleteRow(
    _i1.Session session,
    EmailAccountPasswordResetCompleteAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountPasswordResetCompleteAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountPasswordResetCompleteAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1
        .WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountPasswordResetCompleteAttempt>(
      where: where(EmailAccountPasswordResetCompleteAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetCompleteAttemptTable>?
        where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountPasswordResetCompleteAttempt>(
      where: where?.call(EmailAccountPasswordResetCompleteAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
