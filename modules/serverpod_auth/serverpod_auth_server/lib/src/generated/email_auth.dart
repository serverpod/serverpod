/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a sign in with email.
abstract class EmailAuth extends _i1.TableRow {
  EmailAuth._({
    int? id,
    required this.userId,
    required this.email,
    required this.hash,
  }) : super(id);

  factory EmailAuth({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) = _EmailAuthImpl;

  factory EmailAuth.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailAuth(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      hash: serializationManager.deserialize<String>(jsonSerialization['hash']),
    );
  }

  static final t = EmailAuthTable();

  static const db = EmailAuthRepository._();

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The email of the user.
  String email;

  /// The hashed password of the user.
  String hash;

  @override
  _i1.Table get table => t;

  EmailAuth copyWith({
    int? id,
    int? userId,
    String? email,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'email': email,
      'hash': hash,
    };
  }

  static EmailAuthInclude include() {
    return EmailAuthInclude._();
  }

  static EmailAuthIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    EmailAuthInclude? include,
  }) {
    return EmailAuthIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailAuth.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailAuth.t),
      include: include,
    );
  }
}

class _Undefined {}

class _EmailAuthImpl extends EmailAuth {
  _EmailAuthImpl({
    int? id,
    required int userId,
    required String email,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          email: email,
          hash: hash,
        );

  @override
  EmailAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? email,
    String? hash,
  }) {
    return EmailAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      hash: hash ?? this.hash,
    );
  }
}

class EmailAuthTable extends _i1.Table {
  EmailAuthTable({super.tableRelation})
      : super(tableName: 'serverpod_email_auth') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    hash = _i1.ColumnString(
      'hash',
      this,
    );
  }

  /// The id of the user, corresponds to the id field in [UserInfo].
  late final _i1.ColumnInt userId;

  /// The email of the user.
  late final _i1.ColumnString email;

  /// The hashed password of the user.
  late final _i1.ColumnString hash;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        email,
        hash,
      ];
}

class EmailAuthInclude extends _i1.IncludeObject {
  EmailAuthInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailAuth.t;
}

class EmailAuthIncludeList extends _i1.IncludeList {
  EmailAuthIncludeList._({
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailAuth.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailAuth.t;
}

class EmailAuthRepository {
  const EmailAuthRepository._();

  Future<List<EmailAuth>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailAuth?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailAuthTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailAuthTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<EmailAuth>(
      where: where?.call(EmailAuth.t),
      orderBy: orderBy?.call(EmailAuth.t),
      orderByList: orderByList?.call(EmailAuth.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailAuth?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<EmailAuth>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EmailAuth>> insert(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<EmailAuth>(
      rows,
      transaction: transaction,
    );
  }

  Future<EmailAuth> insertRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<EmailAuth>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EmailAuth>> update(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.ColumnSelections<EmailAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<EmailAuth>(
      rows,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  Future<EmailAuth> updateRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.ColumnSelections<EmailAuthTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<EmailAuth>(
      row,
      columns: columns?.call(EmailAuth.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<EmailAuth> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<EmailAuth>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    EmailAuth row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<EmailAuth>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailAuthTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<EmailAuth>(
      where: where(EmailAuth.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailAuthTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<EmailAuth>(
      where: where?.call(EmailAuth.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
