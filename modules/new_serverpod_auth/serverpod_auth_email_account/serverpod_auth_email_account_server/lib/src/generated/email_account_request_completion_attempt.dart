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
import 'email_account_request.dart' as _i2;

/// Database table for tracking email account completion requests.
/// A new entry will be created whenever the user tries to complete the email account setup.
abstract class EmailAccountRequestCompletionAttempt
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountRequestCompletionAttempt._({
    this.id,
    DateTime? attemptedAt,
    required this.ipAddress,
    required this.emailAccountRequestId,
    this.emailAccountRequest,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  factory EmailAccountRequestCompletionAttempt({
    _i1.UuidValue? id,
    DateTime? attemptedAt,
    required String ipAddress,
    required _i1.UuidValue emailAccountRequestId,
    _i2.EmailAccountRequest? emailAccountRequest,
  }) = _EmailAccountRequestCompletionAttemptImpl;

  factory EmailAccountRequestCompletionAttempt.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountRequestCompletionAttempt(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      attemptedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['attemptedAt']),
      ipAddress: jsonSerialization['ipAddress'] as String,
      emailAccountRequestId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['emailAccountRequestId']),
      emailAccountRequest: jsonSerialization['emailAccountRequest'] == null
          ? null
          : _i2.EmailAccountRequest.fromJson(
              (jsonSerialization['emailAccountRequest']
                  as Map<String, dynamic>)),
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

  _i1.UuidValue emailAccountRequestId;

  _i2.EmailAccountRequest? emailAccountRequest;

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
    _i2.EmailAccountRequest? emailAccountRequest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'attemptedAt': attemptedAt.toJson(),
      'ipAddress': ipAddress,
      'emailAccountRequestId': emailAccountRequestId.toJson(),
      if (emailAccountRequest != null)
        'emailAccountRequest': emailAccountRequest?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountRequestCompletionAttemptInclude include(
      {_i2.EmailAccountRequestInclude? emailAccountRequest}) {
    return EmailAccountRequestCompletionAttemptInclude._(
        emailAccountRequest: emailAccountRequest);
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
    _i2.EmailAccountRequest? emailAccountRequest,
  }) : super._(
          id: id,
          attemptedAt: attemptedAt,
          ipAddress: ipAddress,
          emailAccountRequestId: emailAccountRequestId,
          emailAccountRequest: emailAccountRequest,
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
    Object? emailAccountRequest = _Undefined,
  }) {
    return EmailAccountRequestCompletionAttempt(
      id: id is _i1.UuidValue? ? id : this.id,
      attemptedAt: attemptedAt ?? this.attemptedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      emailAccountRequestId:
          emailAccountRequestId ?? this.emailAccountRequestId,
      emailAccountRequest: emailAccountRequest is _i2.EmailAccountRequest?
          ? emailAccountRequest
          : this.emailAccountRequest?.copyWith(),
    );
  }
}

class EmailAccountRequestCompletionAttemptTable
    extends _i1.Table<_i1.UuidValue?> {
  EmailAccountRequestCompletionAttemptTable({super.tableRelation})
      : super(
            tableName:
                'serverpod_auth_email_account_request_completion_attempt') {
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

  /// The time of the reset attempt.
  late final _i1.ColumnDateTime attemptedAt;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnUuid emailAccountRequestId;

  _i2.EmailAccountRequestTable? _emailAccountRequest;

  _i2.EmailAccountRequestTable get emailAccountRequest {
    if (_emailAccountRequest != null) return _emailAccountRequest!;
    _emailAccountRequest = _i1.createRelationTable(
      relationFieldName: 'emailAccountRequest',
      field: EmailAccountRequestCompletionAttempt.t.emailAccountRequestId,
      foreignField: _i2.EmailAccountRequest.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EmailAccountRequestTable(tableRelation: foreignTableRelation),
    );
    return _emailAccountRequest!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        attemptedAt,
        ipAddress,
        emailAccountRequestId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'emailAccountRequest') {
      return emailAccountRequest;
    }
    return null;
  }
}

class EmailAccountRequestCompletionAttemptInclude extends _i1.IncludeObject {
  EmailAccountRequestCompletionAttemptInclude._(
      {_i2.EmailAccountRequestInclude? emailAccountRequest}) {
    _emailAccountRequest = emailAccountRequest;
  }

  _i2.EmailAccountRequestInclude? _emailAccountRequest;

  @override
  Map<String, _i1.Include?> get includes =>
      {'emailAccountRequest': _emailAccountRequest};

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

  final attachRow =
      const EmailAccountRequestCompletionAttemptAttachRowRepository._();

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
    EmailAccountRequestCompletionAttemptInclude? include,
  }) async {
    return session.db.find<EmailAccountRequestCompletionAttempt>(
      where: where?.call(EmailAccountRequestCompletionAttempt.t),
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    EmailAccountRequestCompletionAttemptInclude? include,
  }) async {
    return session.db.findFirstRow<EmailAccountRequestCompletionAttempt>(
      where: where?.call(EmailAccountRequestCompletionAttempt.t),
      orderBy: orderBy?.call(EmailAccountRequestCompletionAttempt.t),
      orderByList: orderByList?.call(EmailAccountRequestCompletionAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [EmailAccountRequestCompletionAttempt] by its [id] or null if no such row exists.
  Future<EmailAccountRequestCompletionAttempt?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EmailAccountRequestCompletionAttemptInclude? include,
  }) async {
    return session.db.findById<EmailAccountRequestCompletionAttempt>(
      id,
      transaction: transaction,
      include: include,
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
    required _i1
        .WhereExpressionBuilder<EmailAccountRequestCompletionAttemptTable>
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

class EmailAccountRequestCompletionAttemptAttachRowRepository {
  const EmailAccountRequestCompletionAttemptAttachRowRepository._();

  /// Creates a relation between the given [EmailAccountRequestCompletionAttempt] and [EmailAccountRequest]
  /// by setting the [EmailAccountRequestCompletionAttempt]'s foreign key `emailAccountRequestId` to refer to the [EmailAccountRequest].
  Future<void> emailAccountRequest(
    _i1.Session session,
    EmailAccountRequestCompletionAttempt emailAccountRequestCompletionAttempt,
    _i2.EmailAccountRequest emailAccountRequest, {
    _i1.Transaction? transaction,
  }) async {
    if (emailAccountRequestCompletionAttempt.id == null) {
      throw ArgumentError.notNull('emailAccountRequestCompletionAttempt.id');
    }
    if (emailAccountRequest.id == null) {
      throw ArgumentError.notNull('emailAccountRequest.id');
    }

    var $emailAccountRequestCompletionAttempt =
        emailAccountRequestCompletionAttempt.copyWith(
            emailAccountRequestId: emailAccountRequest.id);
    await session.db.updateRow<EmailAccountRequestCompletionAttempt>(
      $emailAccountRequestCompletionAttempt,
      columns: [EmailAccountRequestCompletionAttempt.t.emailAccountRequestId],
      transaction: transaction,
    );
  }
}
