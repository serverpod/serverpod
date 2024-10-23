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

/// Database bindings for an phone number reset.
abstract class PhoneReset implements _i1.TableRow, _i1.ProtocolSerialization {
  PhoneReset._({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
  });

  factory PhoneReset({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) = _PhoneResetImpl;

  factory PhoneReset.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhoneReset(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      verificationCode: jsonSerialization['verificationCode'] as String,
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
    );
  }

  static final t = PhoneResetTable();

  static const db = PhoneResetRepository._();

  @override
  int? id;

  /// The id of the user that is resetting his/her password.
  int userId;

  /// The verification code for the password reset.
  String verificationCode;

  /// The expiration time for the password reset.
  DateTime expiration;

  @override
  _i1.Table get table => t;

  PhoneReset copyWith({
    int? id,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toJson(),
    };
  }

  static PhoneResetInclude include() {
    return PhoneResetInclude._();
  }

  static PhoneResetIncludeList includeList({
    _i1.WhereExpressionBuilder<PhoneResetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneResetTable>? orderByList,
    PhoneResetInclude? include,
  }) {
    return PhoneResetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PhoneReset.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PhoneReset.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneResetImpl extends PhoneReset {
  _PhoneResetImpl({
    int? id,
    required int userId,
    required String verificationCode,
    required DateTime expiration,
  }) : super._(
          id: id,
          userId: userId,
          verificationCode: verificationCode,
          expiration: expiration,
        );

  @override
  PhoneReset copyWith({
    Object? id = _Undefined,
    int? userId,
    String? verificationCode,
    DateTime? expiration,
  }) {
    return PhoneReset(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      verificationCode: verificationCode ?? this.verificationCode,
      expiration: expiration ?? this.expiration,
    );
  }
}

class PhoneResetTable extends _i1.Table {
  PhoneResetTable({super.tableRelation})
      : super(tableName: 'serverpod_phone_reset') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    verificationCode = _i1.ColumnString(
      'verificationCode',
      this,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      this,
    );
  }

  /// The id of the user that is resetting his/her password.
  late final _i1.ColumnInt userId;

  /// The verification code for the password reset.
  late final _i1.ColumnString verificationCode;

  /// The expiration time for the password reset.
  late final _i1.ColumnDateTime expiration;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        verificationCode,
        expiration,
      ];
}

class PhoneResetInclude extends _i1.IncludeObject {
  PhoneResetInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => PhoneReset.t;
}

class PhoneResetIncludeList extends _i1.IncludeList {
  PhoneResetIncludeList._({
    _i1.WhereExpressionBuilder<PhoneResetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PhoneReset.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => PhoneReset.t;
}

class PhoneResetRepository {
  const PhoneResetRepository._();

  Future<List<PhoneReset>> find(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneResetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PhoneResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneResetTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.find<PhoneReset>(
      where: where?.call(PhoneReset.t),
      orderBy: orderBy?.call(PhoneReset.t),
      orderByList: orderByList?.call(PhoneReset.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneReset?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneResetTable>? where,
    int? offset,
    _i1.OrderByBuilder<PhoneResetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PhoneResetTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findFirstRow<PhoneReset>(
      where: where?.call(PhoneReset.t),
      orderBy: orderBy?.call(PhoneReset.t),
      orderByList: orderByList?.call(PhoneReset.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneReset?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.findById<PhoneReset>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneReset>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneReset> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<PhoneReset>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneReset> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneReset row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<PhoneReset>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneReset>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneReset> rows, {
    _i1.ColumnSelections<PhoneResetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<PhoneReset>(
      rows,
      columns: columns?.call(PhoneReset.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneReset> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneReset row, {
    _i1.ColumnSelections<PhoneResetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<PhoneReset>(
      row,
      columns: columns?.call(PhoneReset.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneReset>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<PhoneReset> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<PhoneReset>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<PhoneReset> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    PhoneReset row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<PhoneReset>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<PhoneReset>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<PhoneResetTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<PhoneReset>(
      where: where(PhoneReset.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<PhoneResetTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<PhoneReset>(
      where: where?.call(PhoneReset.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
