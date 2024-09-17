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
import '../../protocol.dart' as _i2;

abstract class UserNoteCollection extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory UserNoteCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNoteCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      userNotesPropertyName:
          (jsonSerialization['userNotesPropertyName'] as List?)
              ?.map((e) => _i2.UserNote.fromJson((e as Map<String, dynamic>)))
              .toList(),
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName': userNotesPropertyName?.toJson(
            valueToJson: (v) => v.toJsonForProtocol()),
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
          : this.userNotesPropertyName?.map((e0) => e0.copyWith()).toList(),
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
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return databaseAccessor.db.find<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<UserNoteCollection?> findFirstRow(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return databaseAccessor.db.findFirstRow<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      orderBy: orderBy?.call(UserNoteCollection.t),
      orderByList: orderByList?.call(UserNoteCollection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<UserNoteCollection?> findById(
    _i1.DatabaseAccessor databaseAccessor,
    int id, {
    _i1.Transaction? transaction,
    UserNoteCollectionInclude? include,
  }) async {
    return databaseAccessor.db.findById<UserNoteCollection>(
      id,
      transaction: transaction ?? databaseAccessor.transaction,
      include: include,
    );
  }

  Future<List<UserNoteCollection>> insert(
    _i1.DatabaseAccessor databaseAccessor,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insert<UserNoteCollection>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UserNoteCollection> insertRow(
    _i1.DatabaseAccessor databaseAccessor,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.insertRow<UserNoteCollection>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UserNoteCollection>> update(
    _i1.DatabaseAccessor databaseAccessor,
    List<UserNoteCollection> rows, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.update<UserNoteCollection>(
      rows,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UserNoteCollection> updateRow(
    _i1.DatabaseAccessor databaseAccessor,
    UserNoteCollection row, {
    _i1.ColumnSelections<UserNoteCollectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.updateRow<UserNoteCollection>(
      row,
      columns: columns?.call(UserNoteCollection.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UserNoteCollection>> delete(
    _i1.DatabaseAccessor databaseAccessor,
    List<UserNoteCollection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.delete<UserNoteCollection>(
      rows,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<UserNoteCollection> deleteRow(
    _i1.DatabaseAccessor databaseAccessor,
    UserNoteCollection row, {
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteRow<UserNoteCollection>(
      row,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<List<UserNoteCollection>> deleteWhere(
    _i1.DatabaseAccessor databaseAccessor, {
    required _i1.WhereExpressionBuilder<UserNoteCollectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.deleteWhere<UserNoteCollection>(
      where: where(UserNoteCollection.t),
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }

  Future<int> count(
    _i1.DatabaseAccessor databaseAccessor, {
    _i1.WhereExpressionBuilder<UserNoteCollectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return databaseAccessor.db.count<UserNoteCollection>(
      where: where?.call(UserNoteCollection.t),
      limit: limit,
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class UserNoteCollectionAttachRepository {
  const UserNoteCollectionAttachRepository._();

  Future<void> userNotesPropertyName(
    _i1.DatabaseAccessor databaseAccessor,
    UserNoteCollection userNoteCollection,
    List<_i2.UserNote> userNote, {
    _i1.Transaction? transaction,
  }) async {
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
    await databaseAccessor.db.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class UserNoteCollectionAttachRowRepository {
  const UserNoteCollectionAttachRowRepository._();

  Future<void> userNotesPropertyName(
    _i1.DatabaseAccessor databaseAccessor,
    UserNoteCollection userNoteCollection,
    _i2.UserNote userNote, {
    _i1.Transaction? transaction,
  }) async {
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
    await databaseAccessor.db.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class UserNoteCollectionDetachRepository {
  const UserNoteCollectionDetachRepository._();

  Future<void> userNotesPropertyName(
    _i1.DatabaseAccessor databaseAccessor,
    List<_i2.UserNote> userNote, {
    _i1.Transaction? transaction,
  }) async {
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
    await databaseAccessor.db.update<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}

class UserNoteCollectionDetachRowRepository {
  const UserNoteCollectionDetachRowRepository._();

  Future<void> userNotesPropertyName(
    _i1.DatabaseAccessor databaseAccessor,
    _i2.UserNote userNote, {
    _i1.Transaction? transaction,
  }) async {
    if (userNote.id == null) {
      throw ArgumentError.notNull('userNote.id');
    }

    var $userNote = _i2.UserNoteImplicit(
      userNote,
      $_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId: null,
    );
    await databaseAccessor.db.updateRow<_i2.UserNote>(
      $userNote,
      columns: [
        _i2.UserNote.t
            .$_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId
      ],
      transaction: transaction ?? databaseAccessor.transaction,
    );
  }
}
