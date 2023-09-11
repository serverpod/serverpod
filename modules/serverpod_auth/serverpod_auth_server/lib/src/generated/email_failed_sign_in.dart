/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

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

  factory EmailFailedSignIn.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailFailedSignIn(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      ipAddress: serializationManager
          .deserialize<String>(jsonSerialization['ipAddress']),
    );
  }

  static final t = EmailFailedSignInTable();

  /// Email attempting to sign in with.
  String email;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  @override
  String get tableName => 'serverpod_email_failed_sign_in';
  EmailFailedSignIn copyWith({
    int? id,
    String? email,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'email':
        email = value;
        return;
      case 'time':
        time = value;
        return;
      case 'ipAddress':
        ipAddress = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailFailedSignIn>> find(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findSingleRow(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailFailedSignIn>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailFailedSignInExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    EmailFailedSignIn row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static EmailFailedSignInInclude include() {
    return EmailFailedSignInInclude._();
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
      id: id is! int? ? this.id : id,
      email: email ?? this.email,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}

typedef EmailFailedSignInExpressionBuilder = _i1.Expression Function(
    EmailFailedSignInTable);

class EmailFailedSignInTable extends _i1.Table {
  EmailFailedSignInTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_email_failed_sign_in') {
    email = _i1.ColumnString(
      'email',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    time = _i1.ColumnDateTime(
      'time',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    ipAddress = _i1.ColumnString(
      'ipAddress',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
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

@Deprecated('Use EmailFailedSignInTable.t instead.')
EmailFailedSignInTable tEmailFailedSignIn = EmailFailedSignInTable();

class EmailFailedSignInInclude extends _i1.Include {
  EmailFailedSignInInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => EmailFailedSignIn.t;
}
