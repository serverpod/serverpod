/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UserNoteWithALongName extends _i1.TableRow {
  UserNoteWithALongName._({
    int? id,
    required this.name,
  }) : super(id);

  factory UserNoteWithALongName({
    int? id,
    required String name,
  }) = _UserNoteWithALongNameImpl;

  factory UserNoteWithALongName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteWithALongName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
    );
  }

  static final t = UserNoteWithALongNameTable();

  static const db = UserNoteWithALongNameRepository._();

  String name;

  int? _userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  _i1.Table get table => t;

  UserNoteWithALongName copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId !=
          null)
        '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId':
            _userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
    };
  }

  static UserNoteWithALongNameInclude include() {
    return UserNoteWithALongNameInclude._();
  }

  static UserNoteWithALongNameIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    UserNoteWithALongNameInclude? include,
  }) {
    return UserNoteWithALongNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UserNoteWithALongNameImpl extends UserNoteWithALongName {
  _UserNoteWithALongNameImpl({
    int? id,
    required String name,
  }) : super._(
          id: id,
          name: name,
        );

  @override
  UserNoteWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return UserNoteWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
    );
  }
}

class UserNoteWithALongNameImplicit extends _UserNoteWithALongNameImpl {
  UserNoteWithALongNameImplicit._({
    int? id,
    required String name,
    this.$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
  }) : super(
          id: id,
          name: name,
        );

  factory UserNoteWithALongNameImplicit(
    UserNoteWithALongName userNoteWithALongName, {
    int? $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
  }) {
    return UserNoteWithALongNameImplicit._(
      id: userNoteWithALongName.id,
      name: userNoteWithALongName.name,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
          $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
    );
  }

  int? $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({
      '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId':
          $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
    });
    return jsonMap;
  }
}

class UserNoteWithALongNameTable extends _i1.Table {
  UserNoteWithALongNameTable({super.tableRelation})
      : super(tableName: 'user_note_with_a_long_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId =
        _i1.ColumnInt(
      '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      ];
}

class UserNoteWithALongNameInclude extends _i1.IncludeObject {
  UserNoteWithALongNameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => UserNoteWithALongName.t;
}

class UserNoteWithALongNameIncludeList extends _i1.IncludeList {
  UserNoteWithALongNameIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteWithALongName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteWithALongName.t;
}

class UserNoteWithALongNameRepository {
  const UserNoteWithALongNameRepository._();

  Future<List<UserNoteWithALongName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserNoteWithALongName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      orderBy: orderBy?.call(UserNoteWithALongName.t),
      orderByList: orderByList?.call(UserNoteWithALongName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<UserNoteWithALongName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserNoteWithALongName>(
      id,
      transaction: transaction,
    );
  }

  Future<List<UserNoteWithALongName>> insert(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNoteWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserNoteWithALongName> insertRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteWithALongName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserNoteWithALongName>> update(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.ColumnSelections<UserNoteWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNoteWithALongName>(
      rows,
      columns: columns?.call(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  Future<UserNoteWithALongName> updateRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.ColumnSelections<UserNoteWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteWithALongName>(
      row,
      columns: columns?.call(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UserNoteWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNoteWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UserNoteWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteWithALongName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteWithALongNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNoteWithALongName>(
      where: where(UserNoteWithALongName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteWithALongNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteWithALongName>(
      where: where?.call(UserNoteWithALongName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
