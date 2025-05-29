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

/// Database table for tracking password reset requests attempts.
abstract class EmailAccountPasswordResetRequestAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountPasswordResetRequestAttempt._({
    this.id,
    required this.email,
    DateTime? attemptedAt,
    required this.ipAddress,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountPasswordResetRequestAttempt({
    _i1.UuidValue? id,
    required String email,
    DateTime? attemptedAt,
    required String ipAddress,
  }) = _EmailAccountPasswordResetRequestAttemptImpl;

  factory EmailAccountPasswordResetRequestAttempt.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetRequestAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      attemptedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['attemptedAt']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = EmailAccountPasswordResetRequestAttemptTable();

  static const db = EmailAccountPasswordResetRequestAttemptRepository._();

  @override
  _i1.UuidValue? id;

  /// Email the reset was attempted for.
  ///
  /// Stored in lower-case.
  String email;

  /// The time of the reset attempt.
  DateTime attemptedAt;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetRequestAttempt copyWith({
    _i1.UuidValue? id,
    String? email,
    DateTime? attemptedAt,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'attemptedAt': attemptedAt.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountPasswordResetRequestAttemptInclude include() {
    return EmailAccountPasswordResetRequestAttemptInclude._();
  }

  static EmailAccountPasswordResetRequestAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        orderByList,
    EmailAccountPasswordResetRequestAttemptInclude? include,
  }) {
    return EmailAccountPasswordResetRequestAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountPasswordResetRequestAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetRequestAttemptImpl
    extends EmailAccountPasswordResetRequestAttempt {
  _EmailAccountPasswordResetRequestAttemptImpl({
    _i1.UuidValue? id,
    required String email,
    DateTime? attemptedAt,
    required String ipAddress,
  }) : super._(
          id: id,
          email: email,
          attemptedAt: attemptedAt,
          ipAddress: ipAddress,
        );

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetRequestAttempt copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? attemptedAt,
    String? ipAddress,
  }) {
    return EmailAccountPasswordResetRequestAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email ?? this.email,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class EmailAccountPasswordResetRequestAttemptTable
    extends _i1.Table<_i1.UuidValue?> {
  EmailAccountPasswordResetRequestAttemptTable({super.tableRelation})
      : super(
            tableName:
                'serverpod_auth_email_account_pw_reset_request_attempt') {
    email = _i1.ColumnString(
      'email',
      this,
    );
    attemptedAt = _i1.ColumnDateTime(
      'attemptedAt',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
  }

  /// Email the reset was attempted for.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The time of the reset attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
        id,
        email,
        attemptedAt,
        ipAddress,
      ];
}

class EmailAccountPasswordResetRequestAttemptInclude extends _i1.IncludeObject {
  EmailAccountPasswordResetRequestAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table =>
      EmailAccountPasswordResetRequestAttempt.t;
}

class EmailAccountPasswordResetRequestAttemptIncludeList
    extends _i1.IncludeList {
  EmailAccountPasswordResetRequestAttemptIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountPasswordResetRequestAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table =>
      EmailAccountPasswordResetRequestAttempt.t;
}

class EmailAccountPasswordResetRequestAttemptRepository {
  const EmailAccountPasswordResetRequestAttemptRepository._();

  /// Returns a list of [EmailAccountPasswordResetRequestAttempt]s matching the given query parameters.
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
  Future<List<EmailAccountPasswordResetRequestAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountPasswordResetRequestAttempt>(
      where: where?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountPasswordResetRequestAttempt] matching the given query parameters.
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
  Future<EmailAccountPasswordResetRequestAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountPasswordResetRequestAttempt>(
      where: where?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequestAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountPasswordResetRequestAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountPasswordResetRequestAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountPasswordResetRequestAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountPasswordResetRequestAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountPasswordResetRequestAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountPasswordResetRequestAttempt>> insert(
    _i1.Session session,
    List<EmailAccountPasswordResetRequestAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountPasswordResetRequestAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountPasswordResetRequestAttempt] and returns the inserted row.
  ///
  /// The returned [EmailAccountPasswordResetRequestAttempt] will have its `id` field set.
  Future<EmailAccountPasswordResetRequestAttempt> insertRow(
    _i1.Session session,
    EmailAccountPasswordResetRequestAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountPasswordResetRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetRequestAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountPasswordResetRequestAttempt>> update(
    _i1.Session session,
    List<EmailAccountPasswordResetRequestAttempt> rows, {
    _i1.ColumnSelections<EmailAccountPasswordResetRequestAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountPasswordResetRequestAttempt>(
      rows,
      columns: columns?.call(EmailAccountPasswordResetRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetRequestAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountPasswordResetRequestAttempt> updateRow(
    _i1.Session session,
    EmailAccountPasswordResetRequestAttempt row, {
    _i1.ColumnSelections<EmailAccountPasswordResetRequestAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountPasswordResetRequestAttempt>(
      row,
      columns: columns?.call(EmailAccountPasswordResetRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountPasswordResetRequestAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountPasswordResetRequestAttempt>> delete(
    _i1.Session session,
    List<EmailAccountPasswordResetRequestAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountPasswordResetRequestAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountPasswordResetRequestAttempt].
  Future<EmailAccountPasswordResetRequestAttempt> deleteRow(
    _i1.Session session,
    EmailAccountPasswordResetRequestAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountPasswordResetRequestAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountPasswordResetRequestAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1
        .WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountPasswordResetRequestAttempt>(
      where: where(EmailAccountPasswordResetRequestAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestAttemptTable>?
        where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountPasswordResetRequestAttempt>(
      where: where?.call(EmailAccountPasswordResetRequestAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
