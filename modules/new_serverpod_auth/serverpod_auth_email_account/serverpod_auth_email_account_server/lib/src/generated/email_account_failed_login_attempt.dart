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

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
abstract class EmailAccountFailedLoginAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountFailedLoginAttempt._({
    this.id,
    required this.email,
    DateTime? attemptedAt,
    required this.ipAddress,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountFailedLoginAttempt({
    _i1.UuidValue? id,
    required String email,
    DateTime? attemptedAt,
    required String ipAddress,
  }) = _EmailAccountFailedLoginAttemptImpl;

  factory EmailAccountFailedLoginAttempt.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountFailedLoginAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      attemptedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['attemptedAt']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = EmailAccountFailedLoginAttemptTable();

  static const db = EmailAccountFailedLoginAttemptRepository._();

  @override
  _i1.UuidValue? id;

  /// Email attempting to sign in with.
  ///
  /// Stored in lower-case.
  String email;

  /// The time of the sign in attempt.
  DateTime attemptedAt;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountFailedLoginAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountFailedLoginAttempt copyWith({
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

  static EmailAccountFailedLoginAttemptInclude include() {
    return EmailAccountFailedLoginAttemptInclude._();
  }

  static EmailAccountFailedLoginAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountFailedLoginAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountFailedLoginAttemptTable>? orderByList,
    EmailAccountFailedLoginAttemptInclude? include,
  }) {
    return EmailAccountFailedLoginAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountFailedLoginAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountFailedLoginAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountFailedLoginAttemptImpl
    extends EmailAccountFailedLoginAttempt {
  _EmailAccountFailedLoginAttemptImpl({
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

  /// Returns a shallow copy of this [EmailAccountFailedLoginAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountFailedLoginAttempt copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? attemptedAt,
    String? ipAddress,
  }) {
    return EmailAccountFailedLoginAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email ?? this.email,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class EmailAccountFailedLoginAttemptTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountFailedLoginAttemptTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_email_account_failed_login_attempt') {
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

  /// Email attempting to sign in with.
  ///
  /// Stored in lower-case.
  late final _i1.ColumnString email;

  /// The time of the sign in attempt.
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

class EmailAccountFailedLoginAttemptInclude extends _i1.IncludeObject {
  EmailAccountFailedLoginAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountFailedLoginAttempt.t;
}

class EmailAccountFailedLoginAttemptIncludeList extends _i1.IncludeList {
  EmailAccountFailedLoginAttemptIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountFailedLoginAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountFailedLoginAttempt.t;
}

class EmailAccountFailedLoginAttemptRepository {
  const EmailAccountFailedLoginAttemptRepository._();

  /// Returns a list of [EmailAccountFailedLoginAttempt]s matching the given query parameters.
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
  Future<List<EmailAccountFailedLoginAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountFailedLoginAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountFailedLoginAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountFailedLoginAttempt>(
      where: where?.call(EmailAccountFailedLoginAttempt.t),
      orderBy: orderBy?.call(EmailAccountFailedLoginAttempt.t),
      orderByList: orderByList?.call(EmailAccountFailedLoginAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountFailedLoginAttempt] matching the given query parameters.
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
  Future<EmailAccountFailedLoginAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountFailedLoginAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountFailedLoginAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountFailedLoginAttempt>(
      where: where?.call(EmailAccountFailedLoginAttempt.t),
      orderBy: orderBy?.call(EmailAccountFailedLoginAttempt.t),
      orderByList: orderByList?.call(EmailAccountFailedLoginAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountFailedLoginAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountFailedLoginAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountFailedLoginAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountFailedLoginAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountFailedLoginAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountFailedLoginAttempt>> insert(
    _i1.Session session,
    List<EmailAccountFailedLoginAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountFailedLoginAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountFailedLoginAttempt] and returns the inserted row.
  ///
  /// The returned [EmailAccountFailedLoginAttempt] will have its `id` field set.
  Future<EmailAccountFailedLoginAttempt> insertRow(
    _i1.Session session,
    EmailAccountFailedLoginAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountFailedLoginAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountFailedLoginAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountFailedLoginAttempt>> update(
    _i1.Session session,
    List<EmailAccountFailedLoginAttempt> rows, {
    _i1.ColumnSelections<EmailAccountFailedLoginAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountFailedLoginAttempt>(
      rows,
      columns: columns?.call(EmailAccountFailedLoginAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountFailedLoginAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountFailedLoginAttempt> updateRow(
    _i1.Session session,
    EmailAccountFailedLoginAttempt row, {
    _i1.ColumnSelections<EmailAccountFailedLoginAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountFailedLoginAttempt>(
      row,
      columns: columns?.call(EmailAccountFailedLoginAttempt.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountFailedLoginAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountFailedLoginAttempt>> delete(
    _i1.Session session,
    List<EmailAccountFailedLoginAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountFailedLoginAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountFailedLoginAttempt].
  Future<EmailAccountFailedLoginAttempt> deleteRow(
    _i1.Session session,
    EmailAccountFailedLoginAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountFailedLoginAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountFailedLoginAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountFailedLoginAttempt>(
      where: where(EmailAccountFailedLoginAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountFailedLoginAttemptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountFailedLoginAttempt>(
      where: where?.call(EmailAccountFailedLoginAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
