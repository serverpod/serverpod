/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'email_account_password_reset_request.dart' as _i2;

/// Database table for tracking password reset attempts.
/// A new entry will be created whenever the user tries to complete the password reset.
abstract class EmailAccountPasswordResetAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountPasswordResetAttempt._({
    this.id,
    DateTime? attemptedAt,
    required this.ipAddress,
    required this.passwordResetRequestId,
    this.passwordResetRequest,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountPasswordResetAttempt({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue passwordResetRequestId,
    _i2.EmailAccountPasswordResetRequest? passwordResetRequest,
  }) = _EmailAccountPasswordResetAttemptImpl;

  factory EmailAccountPasswordResetAttempt.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      attemptedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['attemptedAt']),
      ipAddress: jsonSerialization['ipAddress'] as String,
      passwordResetRequestId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['passwordResetRequestId']),
      passwordResetRequest: jsonSerialization['passwordResetRequest'] == null
          ? null
          : _i2.EmailAccountPasswordResetRequest.fromJson(
              (jsonSerialization['passwordResetRequest']
                  as Map<String, dynamic>)),
    );
  }

  static final t = EmailAccountPasswordResetAttemptTable();

  static const db = EmailAccountPasswordResetAttemptRepository._();

  @override
  _i1.UuidValue? id;

  /// The time of the reset attempt.
  DateTime attemptedAt;

  /// The IP address of the sign in attempt.
  String ipAddress;

  _i1.UuidValue passwordResetRequestId;

  _i2.EmailAccountPasswordResetRequest? passwordResetRequest;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountPasswordResetAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetAttempt copyWith({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? passwordResetRequestId,
    _i2.EmailAccountPasswordResetRequest? passwordResetRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'attemptedAt': attemptedAt.toJson(),
      'ipAddress': ipAddress,
      'passwordResetRequestId': passwordResetRequestId.toJson(),
      if (passwordResetRequest != null)
        'passwordResetRequest': passwordResetRequest?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountPasswordResetAttemptInclude include(
      {_i2.EmailAccountPasswordResetRequestInclude? passwordResetRequest}) {
    return EmailAccountPasswordResetAttemptInclude._(
        passwordResetRequest: passwordResetRequest);
  }

  static EmailAccountPasswordResetAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetAttemptTable>? orderByList,
    EmailAccountPasswordResetAttemptInclude? include,
  }) {
    return EmailAccountPasswordResetAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountPasswordResetAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetAttemptImpl
    extends EmailAccountPasswordResetAttempt {
  _EmailAccountPasswordResetAttemptImpl({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue passwordResetRequestId,
    _i2.EmailAccountPasswordResetRequest? passwordResetRequest,
  }) : super._(
          id: id,
          attemptedAt: attemptedAt,
          ipAddress: ipAddress,
          passwordResetRequestId: passwordResetRequestId,
          passwordResetRequest: passwordResetRequest,
        );

  /// Returns a shallow copy of this [EmailAccountPasswordResetAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetAttempt copyWith({
    Object? id = _Undefined,
    DateTime? attemptedAt,
    String? ipAddress,
    _i1.UuidValue? passwordResetRequestId,
    Object? passwordResetRequest = _Undefined,
  }) {
    return EmailAccountPasswordResetAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      passwordResetRequestId:
          passwordResetRequestId ?? this.passwordResetRequestId,
      passwordResetRequest:
          passwordResetRequest is _i2.EmailAccountPasswordResetRequest?
              ? passwordResetRequest
              : this.passwordResetRequest?.copyWith(),
    );
  }
}

class EmailAccountPasswordResetAttemptTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountPasswordResetAttemptTable({super.tableRelation})
      : super(
            tableName: 'serverpod_auth_email_account_password_reset_attempt') {
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

  /// The time of the reset attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnUuid passwordResetRequestId;

  _i2.EmailAccountPasswordResetRequestTable? _passwordResetRequest;

  _i2.EmailAccountPasswordResetRequestTable get passwordResetRequest {
    if (_passwordResetRequest != null) return _passwordResetRequest!;
    _passwordResetRequest = _i1.createRelationTable(
      relationFieldName: 'passwordResetRequest',
      field: EmailAccountPasswordResetAttempt.t.passwordResetRequestId,
      foreignField: _i2.EmailAccountPasswordResetRequest.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EmailAccountPasswordResetRequestTable(
              tableRelation: foreignTableRelation),
    );
    return _passwordResetRequest!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        attemptedAt,
        ipAddress,
        passwordResetRequestId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'passwordResetRequest') {
      return passwordResetRequest;
    }
    return null;
  }
}

class EmailAccountPasswordResetAttemptInclude extends _i1.IncludeObject {
  EmailAccountPasswordResetAttemptInclude._(
      {_i2.EmailAccountPasswordResetRequestInclude? passwordResetRequest}) {
    _passwordResetRequest = passwordResetRequest;
  }

  _i2.EmailAccountPasswordResetRequestInclude? _passwordResetRequest;

  @override
  Map<String, _i1.Include?> get includes =>
      {'passwordResetRequest': _passwordResetRequest};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountPasswordResetAttempt.t;
}

class EmailAccountPasswordResetAttemptIncludeList extends _i1.IncludeList {
  EmailAccountPasswordResetAttemptIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountPasswordResetAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountPasswordResetAttempt.t;
}

class EmailAccountPasswordResetAttemptRepository {
  const EmailAccountPasswordResetAttemptRepository._();

  final attachRow =
      const EmailAccountPasswordResetAttemptAttachRowRepository._();

  /// Returns a list of [EmailAccountPasswordResetAttempt]s matching the given query parameters.
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
  Future<List<EmailAccountPasswordResetAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetAttemptTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountPasswordResetAttemptInclude? include,
  }) async {
    return session.db.find<EmailAccountPasswordResetAttempt>(
      where: where?.call(EmailAccountPasswordResetAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetAttempt.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [EmailAccountPasswordResetAttempt] matching the given query parameters.
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
  Future<EmailAccountPasswordResetAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetAttemptTable>? orderByList,
    _i1.Transaction? transaction,
    EmailAccountPasswordResetAttemptInclude? include,
  }) async {
    return session.db.findFirstRow<EmailAccountPasswordResetAttempt>(
      where: where?.call(EmailAccountPasswordResetAttempt.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetAttempt.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EmailAccountPasswordResetAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountPasswordResetAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EmailAccountPasswordResetAttemptInclude? include,
  }) async {
    return session.db.findById<EmailAccountPasswordResetAttempt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [EmailAccountPasswordResetAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountPasswordResetAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountPasswordResetAttempt>> insert(
    _i1.Session session,
    List<EmailAccountPasswordResetAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountPasswordResetAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountPasswordResetAttempt] and returns the inserted row.
  ///
  /// The returned [EmailAccountPasswordResetAttempt] will have its `id` field set.
  Future<EmailAccountPasswordResetAttempt> insertRow(
    _i1.Session session,
    EmailAccountPasswordResetAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountPasswordResetAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountPasswordResetAttempt>> update(
    _i1.Session session,
    List<EmailAccountPasswordResetAttempt> rows, {
    _i1.ColumnSelections<EmailAccountPasswordResetAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountPasswordResetAttempt>(
      rows,
      columns: columns?.call(EmailAccountPasswordResetAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountPasswordResetAttempt> updateRow(
    _i1.Session session,
    EmailAccountPasswordResetAttempt row, {
    _i1.ColumnSelections<EmailAccountPasswordResetAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountPasswordResetAttempt>(
      row,
      columns: columns?.call(EmailAccountPasswordResetAttempt.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountPasswordResetAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountPasswordResetAttempt>> delete(
    _i1.Session session,
    List<EmailAccountPasswordResetAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountPasswordResetAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountPasswordResetAttempt].
  Future<EmailAccountPasswordResetAttempt> deleteRow(
    _i1.Session session,
    EmailAccountPasswordResetAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountPasswordResetAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountPasswordResetAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountPasswordResetAttempt>(
      where: where(EmailAccountPasswordResetAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetAttemptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountPasswordResetAttempt>(
      where: where?.call(EmailAccountPasswordResetAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class EmailAccountPasswordResetAttemptAttachRowRepository {
  const EmailAccountPasswordResetAttemptAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountPasswordResetAttempt] and [EmailAccountPasswordResetRequest]
  /// by setting the [EmailAccountPasswordResetAttempt]'s foreign key `passwordResetRequestId` to refer to the [EmailAccountPasswordResetRequest].
  Future<void> passwordResetRequest(
    _i1.Session session,
    EmailAccountPasswordResetAttempt emailAccountPasswordResetAttempt,
    _i2.EmailAccountPasswordResetRequest passwordResetRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccountPasswordResetAttempt.id == null) {
      throw ArgumentError.notNull('emailAccountPasswordResetAttempt.id');
    }
    if (passwordResetRequest.id == null) {
      throw ArgumentError.notNull('passwordResetRequest.id');
    }

    var $emailAccountPasswordResetAttempt = emailAccountPasswordResetAttempt
        .copyWith(passwordResetRequestId: passwordResetRequest.id);
    await session.db.updateRow<EmailAccountPasswordResetAttempt>(
      $emailAccountPasswordResetAttempt,
      columns: [EmailAccountPasswordResetAttempt.t.passwordResetRequestId],
      transaction: transaction,
    );
  }
}
