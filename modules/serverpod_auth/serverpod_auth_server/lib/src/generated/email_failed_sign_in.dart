/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
abstract class EmailFailedSignIn extends _i1.TableRow {
  EmailFailedSignIn._({
    int? id,
    required this.email,
    required this.time,
    required this.ipAddress,
  }) : super(id);

  factory EmailFailedSignIn({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) = _EmailFailedSignInImpl;

  factory EmailFailedSignIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return EmailFailedSignIn(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      time: _i1.DateTimeExt.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  static final t = EmailFailedSignInTable();

  static const db = EmailFailedSignInRepository._();

  /// Email attempting to sign in with.
  String email;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  _i1.Table get table => t;

  EmailFailedSignIn copyWith({
    int? id,
    String? email,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  static EmailFailedSignInInclude include() {
    return EmailFailedSignInInclude._();
  }

  static EmailFailedSignInIncludeList includeList({
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    EmailFailedSignInInclude? include,
  }) {
    return EmailFailedSignInIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      include: include,
    );
  }
}

class _Undefined {}

class _EmailFailedSignInImpl extends EmailFailedSignIn {
  _EmailFailedSignInImpl({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) : super._(
          id: id,
          email: email,
          time: time,
          ipAddress: ipAddress,
        );

  @override
  EmailFailedSignIn copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? time,
    String? ipAddress,
  }) {
    return EmailFailedSignIn(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

class EmailFailedSignInTable extends _i1.Table {
  EmailFailedSignInTable({super.tableRelation})
      : super(tableName: 'serverpod_email_failed_sign_in') {
    email = _i1.ColumnString(
      'email',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
  }

  /// Email attempting to sign in with.
  late final _i1.ColumnString email;

  /// The time of the sign in attempt.
  late final _i1.ColumnDateTime time;

  /// The IP address of the sign in attempt.
  late final _i1.ColumnString ipAddress;

  @override
  List<_i1.Column> get columns => [
        id,
        email,
        time,
        ipAddress,
      ];
}

class EmailFailedSignInInclude extends _i1.IncludeObject {
  EmailFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => EmailFailedSignIn.t;
}

class EmailFailedSignInIncludeList extends _i1.IncludeList {
  EmailFailedSignInIncludeList._({
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EmailFailedSignIn.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => EmailFailedSignIn.t;
}

class EmailFailedSignInRepository {
  const EmailFailedSignInRepository._();

  Future<List<EmailFailedSignIn>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailFailedSignIn?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? offset,
    _i1.OrderByBuilder<EmailFailedSignInTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EmailFailedSignInTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      orderBy: orderBy?.call(EmailFailedSignIn.t),
      orderByList: orderByList?.call(EmailFailedSignIn.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<EmailFailedSignIn?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<EmailFailedSignIn>(
      id,
      transaction: transaction,
    );
  }

  Future<List<EmailFailedSignIn>> insert(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<EmailFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  Future<EmailFailedSignIn> insertRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmailFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  Future<List<EmailFailedSignIn>> update(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.ColumnSelections<EmailFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EmailFailedSignIn>(
      rows,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  Future<EmailFailedSignIn> updateRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.ColumnSelections<EmailFailedSignInTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmailFailedSignIn>(
      row,
      columns: columns?.call(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<EmailFailedSignIn> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmailFailedSignIn>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<EmailFailedSignInTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<EmailFailedSignInTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where?.call(EmailFailedSignIn.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
