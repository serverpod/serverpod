/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Information about a user. The [UserInfo] should only be shared with the user
/// itself as it may contain sensative information, such as the users email.
/// If you need to share a user's info with other users, use the
/// [UserInfoPublic] instead. You can retrieve a [UserInfoPublic] through the
/// toPublic() method.
abstract class UserInfo extends _i1.TableRow {
  UserInfo._({
    int? id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.blocked,
  }) : super(id);

  factory UserInfo({
    int? id,
    required String userIdentifier,
    required String userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) = _UserInfoImpl;

  factory UserInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userIdentifier: serializationManager
          .deserialize<String>(jsonSerialization['userIdentifier']),
      userName: serializationManager
          .deserialize<String>(jsonSerialization['userName']),
      fullName: serializationManager
          .deserialize<String?>(jsonSerialization['fullName']),
      email:
          serializationManager.deserialize<String?>(jsonSerialization['email']),
      created: serializationManager
          .deserialize<DateTime>(jsonSerialization['created']),
      imageUrl: serializationManager
          .deserialize<String?>(jsonSerialization['imageUrl']),
      scopeNames: serializationManager
          .deserialize<List<String>>(jsonSerialization['scopeNames']),
      blocked:
          serializationManager.deserialize<bool>(jsonSerialization['blocked']),
    );
  }

  static final t = UserInfoTable();

  static const db = UserInfoRepository._();

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  String userIdentifier;

  /// The first name of the user or the user's nickname.
  String userName;

  /// The full name of the user.
  String? fullName;

  /// The email of the user.
  String? email;

  /// The time when this user was created.
  DateTime created;

  /// A URL to the user's avatar.
  String? imageUrl;

  /// List of scopes that this user can access.
  List<String> scopeNames;

  /// True if the user is blocked from signing in.
  bool blocked;

  @override
  _i1.Table get table => t;

  UserInfo copyWith({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    String? imageUrl,
    List<String>? scopeNames,
    bool? blocked,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'blocked': blocked,
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
      case 'userIdentifier':
        userIdentifier = value;
        return;
      case 'userName':
        userName = value;
        return;
      case 'fullName':
        fullName = value;
        return;
      case 'email':
        email = value;
        return;
      case 'created':
        created = value;
        return;
      case 'imageUrl':
        imageUrl = value;
        return;
      case 'scopeNames':
        scopeNames = value;
        return;
      case 'blocked':
        blocked = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<UserInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<UserInfo?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<UserInfo?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<UserInfo>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserInfo>(
      where: where(UserInfo.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static UserInfoInclude include() {
    return UserInfoInclude._();
  }

  static UserInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    UserInfoInclude? include,
  }) {
    return UserInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserInfo.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UserInfoImpl extends UserInfo {
  _UserInfoImpl({
    int? id,
    required String userIdentifier,
    required String userName,
    String? fullName,
    String? email,
    required DateTime created,
    String? imageUrl,
    required List<String> scopeNames,
    required bool blocked,
  }) : super._(
          id: id,
          userIdentifier: userIdentifier,
          userName: userName,
          fullName: fullName,
          email: email,
          created: created,
          imageUrl: imageUrl,
          scopeNames: scopeNames,
          blocked: blocked,
        );

  @override
  UserInfo copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    String? userName,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    Object? imageUrl = _Undefined,
    List<String>? scopeNames,
    bool? blocked,
  }) {
    return UserInfo(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName ?? this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      scopeNames: scopeNames ?? this.scopeNames.clone(),
      blocked: blocked ?? this.blocked,
    );
  }
}

class UserInfoTable extends _i1.Table {
  UserInfoTable({super.tableRelation})
      : super(tableName: 'serverpod_user_info') {
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
    blocked = _i1.ColumnBool(
      'blocked',
      this,
    );
  }

  /// Unique identifier of the user, may contain different information depending
  /// on how the user was created.
  late final _i1.ColumnString userIdentifier;

  /// The first name of the user or the user's nickname.
  late final _i1.ColumnString userName;

  /// The full name of the user.
  late final _i1.ColumnString fullName;

  /// The email of the user.
  late final _i1.ColumnString email;

  /// The time when this user was created.
  late final _i1.ColumnDateTime created;

  /// A URL to the user's avatar.
  late final _i1.ColumnString imageUrl;

  /// List of scopes that this user can access.
  late final _i1.ColumnSerializable scopeNames;

  /// True if the user is blocked from signing in.
  late final _i1.ColumnBool blocked;

  @override
  List<_i1.Column> get columns => [
        id,
        userIdentifier,
        userName,
        fullName,
        email,
        created,
        imageUrl,
        scopeNames,
        blocked,
      ];
}

@Deprecated('Use UserInfoTable.t instead.')
UserInfoTable tUserInfo = UserInfoTable();

class UserInfoInclude extends _i1.IncludeObject {
  UserInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UserInfo.t;
}

class UserInfoIncludeList extends _i1.IncludeList {
  UserInfoIncludeList._({
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserInfo.t;
}

class UserInfoRepository {
  const UserInfoRepository._();

  Future<List<UserInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<UserInfo>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UserInfo>> insert(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<UserInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserInfo> insertRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<UserInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserInfo>> update(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.ColumnSelections<UserInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<UserInfo>(
      rows,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  Future<UserInfo> updateRow(
    _i1.Session session,
    UserInfo row, {
    _i1.ColumnSelections<UserInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<UserInfo>(
      row,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<UserInfo>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<UserInfo>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<UserInfo>(
      where: where(UserInfo.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<UserInfo>(
      where: where?.call(UserInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
