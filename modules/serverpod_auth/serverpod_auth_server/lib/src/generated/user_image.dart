/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Database bindings for a user image.
abstract class UserImage extends _i1.TableRow {
  UserImage._({
    int? id,
    required this.userId,
    required this.version,
    required this.url,
  }) : super(id);

  factory UserImage({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) = _UserImageImpl;

  factory UserImage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserImage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      version:
          serializationManager.deserialize<int>(jsonSerialization['version']),
      url: serializationManager.deserialize<String>(jsonSerialization['url']),
    );
  }

  static final t = UserImageTable();

  static const db = UserImageRepository._();

  /// The id of the user.
  int userId;

  /// Version of the image. Increased by one for every uploaded image.
  int version;

  /// The URL to the image.
  String url;

  @override
  _i1.Table get table => t;

  UserImage copyWith({
    int? id,
    int? userId,
    int? version,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
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
      case 'userId':
        userId = value;
        return;
      case 'version':
        version = value;
        return;
      case 'url':
        url = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<UserImage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserImage>(
      where: where != null ? where(UserImage.t) : null,
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
  static Future<UserImage?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<UserImage?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<UserImage>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserImage>(
      where: where(UserImage.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    UserImage row, {
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
    UserImage row, {
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
    UserImage row, {
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
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static UserImageInclude include() {
    return UserImageInclude._();
  }

  static UserImageIncludeList includeList({
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserImageTable>? orderByList,
    UserImageInclude? include,
  }) {
    return UserImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserImage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserImage.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UserImageImpl extends UserImage {
  _UserImageImpl({
    int? id,
    required int userId,
    required int version,
    required String url,
  }) : super._(
          id: id,
          userId: userId,
          version: version,
          url: url,
        );

  @override
  UserImage copyWith({
    Object? id = _Undefined,
    int? userId,
    int? version,
    String? url,
  }) {
    return UserImage(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      version: version ?? this.version,
      url: url ?? this.url,
    );
  }
}

class UserImageTable extends _i1.Table {
  UserImageTable({super.tableRelation})
      : super(tableName: 'serverpod_user_image') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    version = _i1.ColumnInt(
      'version',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
  }

  /// The id of the user.
  late final _i1.ColumnInt userId;

  /// Version of the image. Increased by one for every uploaded image.
  late final _i1.ColumnInt version;

  /// The URL to the image.
  late final _i1.ColumnString url;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        version,
        url,
      ];
}

@Deprecated('Use UserImageTable.t instead.')
UserImageTable tUserImage = UserImageTable();

class UserImageInclude extends _i1.IncludeObject {
  UserImageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UserImage.t;
}

class UserImageIncludeList extends _i1.IncludeList {
  UserImageIncludeList._({
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserImage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserImage.t;
}

class UserImageRepository {
  const UserImageRepository._();

  Future<List<UserImage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserImageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<UserImage>(
      where: where?.call(UserImage.t),
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserImage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserImageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<UserImage>(
      where: where?.call(UserImage.t),
      orderBy: orderBy?.call(UserImage.t),
      orderByList: orderByList?.call(UserImage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserImage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<UserImage>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UserImage>> insert(
    _i1.Session session,
    List<UserImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<UserImage>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserImage> insertRow(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<UserImage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserImage>> update(
    _i1.Session session,
    List<UserImage> rows, {
    _i1.ColumnSelections<UserImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<UserImage>(
      rows,
      columns: columns?.call(UserImage.t),
      transaction: transaction,
    );
  }

  Future<UserImage> updateRow(
    _i1.Session session,
    UserImage row, {
    _i1.ColumnSelections<UserImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<UserImage>(
      row,
      columns: columns?.call(UserImage.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UserImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<UserImage>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<UserImage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<UserImage>(
      where: where(UserImage.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserImageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<UserImage>(
      where: where?.call(UserImage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
