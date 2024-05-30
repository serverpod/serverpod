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
abstract class UserImage extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory UserImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserImage(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      version: jsonSerialization['version'] as int,
      url: jsonSerialization['url'] as String,
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
      if (id != null) 'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    };
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    return session.db.find<UserImage>(
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
    return session.db.findFirstRow<UserImage>(
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
    return session.db.findById<UserImage>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UserImage>> insert(
    _i1.Session session,
    List<UserImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserImage>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserImage> insertRow(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserImage>(
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
    return session.db.update<UserImage>(
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
    return session.db.updateRow<UserImage>(
      row,
      columns: columns?.call(UserImage.t),
      transaction: transaction,
    );
  }

  Future<List<UserImage>> delete(
    _i1.Session session,
    List<UserImage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserImage>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserImage> deleteRow(
    _i1.Session session,
    UserImage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserImage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserImage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserImage>(
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
    return session.db.count<UserImage>(
      where: where?.call(UserImage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
