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

abstract class UserNoteCollectionWithALongName extends _i1.TableRow {
  UserNoteCollectionWithALongName._({
    int? id,
    required this.name,
    this.notes,
  }) : super(id);

  factory UserNoteCollectionWithALongName({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) = _UserNoteCollectionWithALongNameImpl;

  factory UserNoteCollectionWithALongName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteCollectionWithALongName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      notes: serializationManager.deserialize<List<_i2.UserNoteWithALongName>?>(
          jsonSerialization['notes']),
    );
  }

  static final t = UserNoteCollectionWithALongNameTable();

  static const db = UserNoteCollectionWithALongNameRepository._();

  String name;

  List<_i2.UserNoteWithALongName>? notes;

  @override
  _i1.Table get table => t;

  UserNoteCollectionWithALongName copyWith({
    int? id,
    String? name,
    List<_i2.UserNoteWithALongName>? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (notes != null) 'notes': notes?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (notes != null)
        'notes': notes?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static UserNoteCollectionWithALongNameInclude include(
      {_i2.UserNoteWithALongNameIncludeList? notes}) {
    return UserNoteCollectionWithALongNameInclude._(notes: notes);
  }

  static UserNoteCollectionWithALongNameIncludeList includeList({
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    UserNoteCollectionWithALongNameInclude? include,
  }) {
    return UserNoteCollectionWithALongNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _UserNoteCollectionWithALongNameImpl
    extends UserNoteCollectionWithALongName {
  _UserNoteCollectionWithALongNameImpl({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) : super._(
          id: id,
          name: name,
          notes: notes,
        );

  @override
  UserNoteCollectionWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? notes = _Undefined,
  }) {
    return UserNoteCollectionWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      notes: notes is List<_i2.UserNoteWithALongName>?
          ? notes
          : this.notes?.clone(),
    );
  }
}

class UserNoteCollectionWithALongNameTable extends _i1.Table {
  UserNoteCollectionWithALongNameTable({super.tableRelation})
      : super(tableName: 'user_note_collection_with_a_long_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.UserNoteWithALongNameTable? ___notes;

  _i1.ManyRelation<_i2.UserNoteWithALongNameTable>? _notes;

  _i2.UserNoteWithALongNameTable get __notes {
    if (___notes != null) return ___notes!;
    ___notes = _i1.createRelationTable(
      relationFieldName: '__notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _i2.UserNoteWithALongName.t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteWithALongNameTable(tableRelation: foreignTableRelation),
    );
    return ___notes!;
  }

  _i1.ManyRelation<_i2.UserNoteWithALongNameTable> get notes {
    if (_notes != null) return _notes!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'notes',
      field: UserNoteCollectionWithALongName.t.id,
      foreignField: _i2.UserNoteWithALongName.t
          .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserNoteWithALongNameTable(tableRelation: foreignTableRelation),
    );
    _notes = _i1.ManyRelation<_i2.UserNoteWithALongNameTable>(
      tableWithRelations: relationTable,
      table: _i2.UserNoteWithALongNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _notes!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'notes') {
      return __notes;
    }
    return null;
  }
}

class UserNoteCollectionWithALongNameInclude extends _i1.IncludeObject {
  UserNoteCollectionWithALongNameInclude._(
      {_i2.UserNoteWithALongNameIncludeList? notes}) {
    _notes = notes;
  }

  _i2.UserNoteWithALongNameIncludeList? _notes;

  @override
  Map<String, _i1.Include?> get includes => {'notes': _notes};

  @override
  _i1.Table get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameIncludeList extends _i1.IncludeList {
  UserNoteCollectionWithALongNameIncludeList._({
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserNoteCollectionWithALongName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => UserNoteCollectionWithALongName.t;
}

class UserNoteCollectionWithALongNameRepository {
  const UserNoteCollectionWithALongNameRepository._();

  final attach = const UserNoteCollectionWithALongNameAttachRepository._();

  final attachRow =
      const UserNoteCollectionWithALongNameAttachRowRepository._();

  final detach = const UserNoteCollectionWithALongNameDetachRepository._();

  final detachRow =
      const UserNoteCollectionWithALongNameDetachRowRepository._();

  Future<List<UserNoteCollectionWithALongName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.find<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<UserNoteCollectionWithALongName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserNoteCollectionWithALongNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserNoteCollectionWithALongNameTable>? orderByList,
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.findFirstRow<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      orderBy: orderBy?.call(UserNoteCollectionWithALongName.t),
      orderByList: orderByList?.call(UserNoteCollectionWithALongName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<UserNoteCollectionWithALongName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    UserNoteCollectionWithALongNameInclude? include,
  }) async {
    return session.db.findById<UserNoteCollectionWithALongName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<UserNoteCollectionWithALongName>> insert(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserNoteCollectionWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  Future<UserNoteCollectionWithALongName> insertRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserNoteCollectionWithALongName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<UserNoteCollectionWithALongName>> update(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserNoteCollectionWithALongName>(
      rows,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  Future<UserNoteCollectionWithALongName> updateRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.ColumnSelections<UserNoteCollectionWithALongNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserNoteCollectionWithALongName>(
      row,
      columns: columns?.call(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<UserNoteCollectionWithALongName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserNoteCollectionWithALongName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    UserNoteCollectionWithALongName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserNoteCollectionWithALongName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserNoteCollectionWithALongName>(
      where: where(UserNoteCollectionWithALongName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserNoteCollectionWithALongNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserNoteCollectionWithALongName>(
      where: where?.call(UserNoteCollectionWithALongName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class UserNoteCollectionWithALongNameAttachRepository {
  const UserNoteCollectionWithALongNameAttachRepository._();

  Future<void> notes(
    _i1.Session session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    List<_i2.UserNoteWithALongName> userNoteWithALongName,
  ) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map((e) => _i2.UserNoteWithALongNameImplicit(
              e,
              $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                  userNoteCollectionWithALongName.id,
            ))
        .toList();
    await session.db.update<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
    );
  }
}

class UserNoteCollectionWithALongNameAttachRowRepository {
  const UserNoteCollectionWithALongNameAttachRowRepository._();

  Future<void> notes(
    _i1.Session session,
    UserNoteCollectionWithALongName userNoteCollectionWithALongName,
    _i2.UserNoteWithALongName userNoteWithALongName,
  ) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }
    if (userNoteCollectionWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteCollectionWithALongName.id');
    }

    var $userNoteWithALongName = _i2.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
          userNoteCollectionWithALongName.id,
    );
    await session.db.updateRow<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
    );
  }
}

class UserNoteCollectionWithALongNameDetachRepository {
  const UserNoteCollectionWithALongNameDetachRepository._();

  Future<void> notes(
    _i1.Session session,
    List<_i2.UserNoteWithALongName> userNoteWithALongName,
  ) async {
    if (userNoteWithALongName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = userNoteWithALongName
        .map((e) => _i2.UserNoteWithALongNameImplicit(
              e,
              $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId:
                  null,
            ))
        .toList();
    await session.db.update<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
    );
  }
}

class UserNoteCollectionWithALongNameDetachRowRepository {
  const UserNoteCollectionWithALongNameDetachRowRepository._();

  Future<void> notes(
    _i1.Session session,
    _i2.UserNoteWithALongName userNoteWithALongName,
  ) async {
    if (userNoteWithALongName.id == null) {
      throw ArgumentError.notNull('userNoteWithALongName.id');
    }

    var $userNoteWithALongName = _i2.UserNoteWithALongNameImplicit(
      userNoteWithALongName,
      $_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId: null,
    );
    await session.db.updateRow<_i2.UserNoteWithALongName>(
      $userNoteWithALongName,
      columns: [
        _i2.UserNoteWithALongName.t
            .$_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId
      ],
    );
  }
}
