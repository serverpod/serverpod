/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class UserNoteCollection extends _i1.TableRow {
  UserNoteCollection._({
    int? id,
    required this.name,
    this.userNotesPropertyName,
  }) : super(id);

  factory UserNoteCollection({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) = _UserNoteCollectionImpl;

  factory UserNoteCollection.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteCollection(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      userNotesPropertyName:
          serializationManager.deserialize<List<_i2.UserNote>?>(
              jsonSerialization['userNotesPropertyName']),
    );
  }

  static final t = UserNoteCollectionTable();

  static const db = UserNoteCollectionRepository._();

  String name;

  List<_i2.UserNote>? userNotesPropertyName;

  @override
  _i1.Table get table => t;

  UserNoteCollection copyWith({
    int? id,
    String? name,
    List<_i2.UserNote>? userNotesPropertyName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName':
            userNotesPropertyName?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName':
            userNotesPropertyName?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static UserNoteCollectionInclude include(
      {_i2.UserNoteIncludeList? userNotesPropertyName}) {
    return UserNoteCollectionInclude._(
        userNotesPropertyName: userNotesPropertyName);
  }

  static UserNoteCollectionIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    UserNoteCollectionInclude? include,
  }) {
    return UserNoteCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteCollection.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UserNoteCollectionImpl extends UserNoteCollection {
  _UserNoteCollectionImpl({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) : super._(
          id: id,
          name: name,
          userNotesPropertyName: userNotesPropertyName,
        );

  @override
  UserNoteCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? userNotesPropertyName = _Undefined,
  }) {
    return UserNoteCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      userNotesPropertyName: userNotesPropertyName is List<_i2.UserNote>?
          ? userNotesPropertyName
          : this.userNotesPropertyName?.clone(),
    );
  }
}

class UserNoteCollectionTable extends _i1.Table {
  UserNoteCollectionTable({super.tableRelation})
      : super(tableName: 'user_note_collections') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.UserNoteTable? ___userNotesPropertyName;

  _i1.ManyRelation<_i2.UserNoteTable>? _userNotesPropertyName;

  _i2.UserNoteTable get __userNotesPropertyName {
    if (___userNotesPropertyName != null) return ___userNotesPropertyName!;
    ___userNotesPropertyName = _i1.createRelationTable(
      relationFieldName: '__userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _i2.UserNote.t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteTable(tableRelation: foreignTableRelation),
    );
    return ___userNotesPropertyName!;
  }

  _i1.ManyRelation<_i2.UserNoteTable> get userNotesPropertyName {
    if (_userNotesPropertyName != null) return _userNotesPropertyName!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'userNotesPropertyName',
      field: UserNoteCollection.t.id,
      foreignField: _i2.UserNote.t
          .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteTable(tableRelation: foreignTableRelation),
    );
    _userNotesPropertyName = _i1.ManyRelation<_i2.UserNoteTable>(
      tableWithRelations: relationTable,
      table: _i2.UserNoteTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _userNotesPropertyName!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userNotesPropertyName') {
      return __userNotesPropertyName;
    }
    return null;
  }
}

class UserNoteCollectionInclude extends _i1.IncludeObject {
  UserNoteCollectionInclude._(
      {_i2.UserNoteIncludeList? userNotesPropertyName}) {
    _userNotesPropertyName = userNotesPropertyName;
  }

  _i2.UserNoteIncludeList? _userNotesPropertyName;

  @override
  Map<String, _i1.Include?> get includes =>
      {'userNotesPropertyName': _userNotesPropertyName};

  @override
  _i1.Table get table => UserNoteCollection.t;
}

class UserNoteCollectionIncludeList extends _i1.IncludeList {
  UserNoteCollectionIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteCollection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteCollection.t;
}

class UserNoteCollectionRepository {
  const UserNoteCollectionRepository._();

  final attach = const UserNoteCollectionAttachRepository._();

  final attachRow = const UserNoteCollectionAttachRowRepository._();

  final detach = const UserNoteCollectionDetachRepository._();

  final detachRow = const UserNoteCollectionDetachRowRepository._();

  Future<List<UserNoteCollection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.dbNext.find<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<UserNoteCollection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.dbNext.findFirstRow<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<UserNoteCollection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return session.dbNext.findById<UserNoteCollection>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<UserNoteCollection>> insert(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<UserNoteCollection>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserNoteCollection> insertRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<UserNoteCollection>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserNoteCollection>> update(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<UserNoteCollection>(
      rows,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  Future<UserNoteCollection> updateRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<UserNoteCollection>(
      row,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<UserNoteCollection>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<UserNoteCollection>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteCollectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<UserNoteCollection>(
      where: where(UserNoteCollection.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionAttachRepository {
  const UserNoteCollectionAttachRepository._();

  Future<void> userNotesPropertyName(
    _i1.Session session,
    UserNoteCollection userNoteCollection,
    List<_i2.UserNote> userNote,
  ) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = userNote
        .map((e) => _i2.UserNoteImplicit(
              e,
              $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                  userNoteCollection.id,
            ))
        .toList();
    await session.dbNext.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
    );
  }
}

class UserNoteCollectionAttachRowRepository {
  const UserNoteCollectionAttachRowRepository._();

  Future<void> userNotesPropertyName(
    _i1.Session session,
    UserNoteCollection userNoteCollection,
    _i2.UserNote userNote,
  ) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }
    if (userNoteCollection.id == null) {
      throw ArgumentError.notNull('userNoteCollection.id');
    }

    var $userNote = _i2.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
          userNoteCollection.id,
    );
    await session.dbNext.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
    );
  }
}

class UserNoteCollectionDetachRepository {
  const UserNoteCollectionDetachRepository._();

  Future<void> userNotesPropertyName(
    _i1.Session session,
    List<_i2.UserNote> userNote,
  ) async {
    if (userNote.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = userNote
        .map((e) => _i2.UserNoteImplicit(
              e,
              $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId:
                  null,
            ))
        .toList();
    await session.dbNext.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
    );
  }
}

class UserNoteCollectionDetachRowRepository {
  const UserNoteCollectionDetachRowRepository._();

  Future<void> userNotesPropertyName(
    _i1.Session session,
    _i2.UserNote userNote,
  ) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = _i2.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId: null,
    );
    await session.dbNext.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
    );
  }
}
