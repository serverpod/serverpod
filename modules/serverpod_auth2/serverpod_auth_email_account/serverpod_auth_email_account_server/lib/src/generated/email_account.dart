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

abstract class EmailAccount
    implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  EmailAccount._({
    this.id,
    required this.userId,
    required this.created,
    required this.email,
    required this.passwordHash,
  });

  factory EmailAccount({
    int? id,
    required int userId,
    required DateTime created,
    required String email,
    required String passwordHash,
  }) = _EmailAccountImpl;

  factory EmailAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailAccount(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
    );
  }

  static final t = EmailAccountTable();

  static const db = EmailAccountRepository._();

  @override
  int? id;

  /// The id of the [AuthUser] this login belongs to.
  int userId;

  /// The time when this authentication was created.
  DateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  String email;

  /// The hashed password of the user.
  String passwordHash;

  @override
  _i1.Table<int> get table => t;

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccount copyWith({
    int? id,
    int? userId,
    DateTime? created,
    String? email,
    String? passwordHash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'created': created.toJson(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'created': created.toJson(),
      'email': email,
      'passwordHash': passwordHash,
    };
  }

  static EmailAccountInclude include() {
    return EmailAccountInclude._();
  }

  static EmailAccountIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    EmailAccountInclude? include,
  }) {
    return EmailAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAccount.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmailAccountImpl extends EmailAccount {
  _EmailAccountImpl({
    int? id,
    required int userId,
    required DateTime created,
    required String email,
    required String passwordHash,
  }) : super._(
          id: id,
          userId: userId,
          created: created,
          email: email,
          passwordHash: passwordHash,
        );

  /// Returns a shallow copy of this [EmailAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccount copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? created,
    String? email,
    String? passwordHash,
  }) {
    return EmailAccount(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      created: created ?? this.created,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}

class EmailAccountTable extends _i1.Table<int> {
  EmailAccountTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_email_account') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
  }

  /// The id of the [AuthUser] this login belongs to.
  late final _i1.ColumnInt userId;

  /// The time when this authentication was created.
  late final _i1.ColumnDateTime created;

  /// The email of the user.
  ///
  /// Stored in lower-case by convention.
  late final _i1.ColumnString email;

  /// The hashed password of the user.
  late final _i1.ColumnString passwordHash;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        created,
        email,
        passwordHash,
      ];
}

class EmailAccountInclude extends _i1.IncludeObject {
  EmailAccountInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int> get table => EmailAccount.t;
}

class EmailAccountIncludeList extends _i1.IncludeList {
  EmailAccountIncludeList._({
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAccount.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => EmailAccount.t;
}

class EmailAccountRepository {
  const EmailAccountRepository._();

  /// Returns a list of [EmailAccount]s matching the given query parameters.
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
  Future<List<EmailAccount>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [EmailAccount] matching the given query parameters.
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
  Future<EmailAccount?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAccountTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAccountTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailAccount>(
      where: where?.call(EmailAccount.t),
      orderBy: orderBy?.call(EmailAccount.t),
      orderByList: orderByList?.call(EmailAccount.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [EmailAccount] by its [id] or null if no such row exists.
  Future<EmailAccount?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailAccount>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [EmailAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [EmailAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<EmailAccount>> insert(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [EmailAccount] and returns the inserted row.
  ///
  /// The returned [EmailAccount] will have its `id` field set.
  Future<EmailAccount> insertRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EmailAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EmailAccount>> update(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.ColumnSelections<EmailAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailAccount>(
      rows,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmailAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmailAccount> updateRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.ColumnSelections<EmailAccountTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailAccount>(
      row,
      columns: columns?.call(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Deletes all [EmailAccount]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EmailAccount>> delete(
    _i1.Session session,
    List<EmailAccount> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailAccount>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EmailAccount].
  Future<EmailAccount> deleteRow(
    _i1.Session session,
    EmailAccount row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EmailAccount>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAccountTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailAccount>(
      where: where(EmailAccount.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAccountTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailAccount>(
      where: where?.call(EmailAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
