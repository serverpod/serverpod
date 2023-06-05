/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef EmailResetExpressionBuilder = _i1.Expression Function(EmailResetTable);

/// Database bindings for an email reset.
abstract class EmailReset extends _i1.TableRow {
  const EmailReset._();

  const factory EmailReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _EmailReset;

  factory EmailReset.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailReset(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      verificationCode: serializationManager
          .deserialize<String>(jsonSerialization['verificationCode']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
    );
  }

  static const t = EmailResetTable();

  EmailReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });
  @override
  String get tableName => 'serverpod_email_reset';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }

  static Future<List<EmailReset>> find(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findSingleRow(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<EmailReset>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required EmailResetExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EmailReset>(
      where: where(EmailReset.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<EmailReset> insert(
    _i1.Session session,
    EmailReset row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// The id of the user that is resetting his/her password.
  int get userId;

  /// The verification code for the password reset.
  String get verificationCode;

  /// The expiration time for the password reset.
  DateTime get expiration;
}

class _Undefined {}

/// Database bindings for an email reset.
class _EmailReset extends EmailReset {
  const _EmailReset({
    int? id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  }) : super._();

  /// The id of the user that is resetting his/her password.
  @override
  final int userId;

  /// The verification code for the password reset.
  @override
  final String verificationCode;

  /// The expiration time for the password reset.
  @override
  final DateTime expiration;

  @override
  String get tableName => 'serverpod_email_reset';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailReset &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.verificationCode,
                  verificationCode,
                ) ||
                other.verificationCode == verificationCode) &&
            (identical(
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration));
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        verificationCode,
        expiration,
      );

  @override
  EmailReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return EmailReset(
      id: id == _Undefined ? this.id : (id as int?),
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}

class EmailResetTable extends _i1.Table {
  const EmailResetTable() : super(tableName: 'serverpod_email_reset');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the user that is resetting his/her password.
  final userId = const _i1.ColumnInt('userId');

  /// The verification code for the password reset.
  final verificationCode = const _i1.ColumnString('verificationCode');

  /// The expiration time for the password reset.
  final expiration = const _i1.ColumnDateTime('expiration');

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        verificationCode,
        expiration,
      ];
}

@Deprecated('Use EmailResetTable.t instead.')
EmailResetTable tEmailReset = const EmailResetTable();
