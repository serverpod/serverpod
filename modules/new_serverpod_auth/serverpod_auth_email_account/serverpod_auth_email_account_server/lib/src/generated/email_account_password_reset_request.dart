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

abstract class EmailAccountPasswordResetRequest
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  EmailAccountPasswordResetRequest._({
    this.id,
    required this.authenticationId,
    DateTime? created,
    required this.verificationCode,
  }) : created = created ?? DateTime.now();

  factory EmailAccountPasswordResetRequest({
    _i1.UuidValue? id,
    required _i1.UuidValue authenticationId,
    DateTime? created,
    required String verificationCode,
  }) = _EmailAccountPasswordResetRequestImpl;

  factory EmailAccountPasswordResetRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetRequest(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      authenticationId: _i1.UuidValueJsonExtension.fromJson(
          jsonSerialization['authenticationId']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  static final t = EmailAccountPasswordResetRequestTable();

  static const db = EmailAccountPasswordResetRequestRepository._();

  @override
  _i1.UuidValue? id;

  /// The id of the [EmailAccount] this request belongs to.
  _i1.UuidValue authenticationId;

  /// The time when this request was created.
  DateTime created;

  /// The verification code for the password reset.
  String verificationCode;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetRequest copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? authenticationId,
    DateTime? created,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'authenticationId': authenticationId.toJson(),
      'created': created.toJson(),
      'verificationCode': verificationCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id?.toJson()};
  }

  static EmailAccountPasswordResetRequestInclude include() {
    return EmailAccountPasswordResetRequestInclude._();
  }

  static EmailAccountPasswordResetRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    EmailAccountPasswordResetRequestInclude? include,
  }) {
    return EmailAccountPasswordResetRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountPasswordResetRequestImpl
    extends EmailAccountPasswordResetRequest {
  _EmailAccountPasswordResetRequestImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue authenticationId,
    DateTime? created,
    required String verificationCode,
  }) : super._(
          id: id,
          authenticationId: authenticationId,
          created: created,
          verificationCode: verificationCode,
        );

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetRequest copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authenticationId,
    DateTime? created,
    String? verificationCode,
  }) {
    return EmailAccountPasswordResetRequest(
      id: id is _i1.UuidValue? ? id : this.id,
      authenticationId: authenticationId ?? this.authenticationId,
      created: created ?? this.created,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}

class EmailAccountPasswordResetRequestTable extends _i1.Table<_i1.UuidValue?> {
  EmailAccountPasswordResetRequestTable({super.tableRelation})
      : super(
            tableName: 'serverpod_auth_email_account_password_reset_request') {
    authenticationId = _i1.ColumnUuid(
      'authenticationId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
      hasDefault: true,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
  }

  /// The id of the [EmailAccount] this request belongs to.
  late final _i1.ColumnUuid authenticationId;

  /// The time when this request was created.
  late final _i1.ColumnDateTime created;

  /// The verification code for the password reset.
  late final _i1.ColumnString verificationCode;

  @override
  List<_i1.Column> get columns => [
        id,
        authenticationId,
        created,
        verificationCode,
      ];
}

class EmailAccountPasswordResetRequestInclude extends _i1.IncludeObject {
  EmailAccountPasswordResetRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountPasswordResetRequest.t;
}

class EmailAccountPasswordResetRequestIncludeList extends _i1.IncludeList {
  EmailAccountPasswordResetRequestIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccountPasswordResetRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => EmailAccountPasswordResetRequest.t;
}

class EmailAccountPasswordResetRequestRepository {
  const EmailAccountPasswordResetRequestRepository._();

  /// Returns a list of [EmailAccountPasswordResetRequest]s matching the given query parameters.
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
  Future<List<EmailAccountPasswordResetRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccountPasswordResetRequest] matching the given query parameters.
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
  Future<EmailAccountPasswordResetRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountPasswordResetRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountPasswordResetRequestTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      orderBy: orderBy?.call(EmailAccountPasswordResetRequest.t),
      orderByList: orderByList?.call(EmailAccountPasswordResetRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccountPasswordResetRequest] by its [id] or null if no such row exists.
  Future<EmailAccountPasswordResetRequest?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccountPasswordResetRequest>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccountPasswordResetRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccountPasswordResetRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccountPasswordResetRequest>> insert(
    _i1.Session session,
    List<EmailAccountPasswordResetRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccountPasswordResetRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccountPasswordResetRequest] and returns the inserted row.
  ///
  /// The returned [EmailAccountPasswordResetRequest] will have its `id` field set.
  Future<EmailAccountPasswordResetRequest> insertRow(
    _i1.Session session,
    EmailAccountPasswordResetRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccountPasswordResetRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccountPasswordResetRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccountPasswordResetRequest>> update(
    _i1.Session session,
    List<EmailAccountPasswordResetRequest> rows, {
    _i1.ColumnSelections<EmailAccountPasswordResetRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccountPasswordResetRequest>(
      rows,
      columns: columns?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccountPasswordResetRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccountPasswordResetRequest> updateRow(
    _i1.Session session,
    EmailAccountPasswordResetRequest row, {
    _i1.ColumnSelections<EmailAccountPasswordResetRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccountPasswordResetRequest>(
      row,
      columns: columns?.call(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccountPasswordResetRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccountPasswordResetRequest>> delete(
    _i1.Session session,
    List<EmailAccountPasswordResetRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccountPasswordResetRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccountPasswordResetRequest].
  Future<EmailAccountPasswordResetRequest> deleteRow(
    _i1.Session session,
    EmailAccountPasswordResetRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccountPasswordResetRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccountPasswordResetRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccountPasswordResetRequest>(
      where: where(EmailAccountPasswordResetRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountPasswordResetRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccountPasswordResetRequest>(
      where: where?.call(EmailAccountPasswordResetRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
