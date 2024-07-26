/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class StringDefaultPersist extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  StringDefaultPersist._({
    int? id,
    this.stringDefaultPersist,
  }) : super(id);

  factory StringDefaultPersist({
    int? id,
    String? stringDefaultPersist,
  }) = _StringDefaultPersistImpl;

  factory StringDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StringDefaultPersist(
      id: jsonSerialization['id'] as int?,
      stringDefaultPersist:
          jsonSerialization['stringDefaultPersist'] as String?,
    );
  }

  static final t = StringDefaultPersistTable();

  static const db = StringDefaultPersistRepository._();

  String? stringDefaultPersist;

  @override
  _i1.Table get table => t;

  StringDefaultPersist copyWith({
    int? id,
    String? stringDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
    };
  }

  static StringDefaultPersistInclude include() {
    return StringDefaultPersistInclude._();
  }

  static StringDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    StringDefaultPersistInclude? include,
  }) {
    return StringDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultPersistImpl extends StringDefaultPersist {
  _StringDefaultPersistImpl({
    int? id,
    String? stringDefaultPersist,
  }) : super._(
          id: id,
          stringDefaultPersist: stringDefaultPersist,
        );

  @override
  StringDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? stringDefaultPersist = _Undefined,
  }) {
    return StringDefaultPersist(
      id: id is int? ? id : this.id,
      stringDefaultPersist: stringDefaultPersist is String?
          ? stringDefaultPersist
          : this.stringDefaultPersist,
    );
  }
}

class StringDefaultPersistTable extends _i1.Table {
  StringDefaultPersistTable({super.tableRelation})
      : super(tableName: 'string_default_persist') {
    stringDefaultPersist = _i1.ColumnString(
      'stringDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString stringDefaultPersist;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefaultPersist,
      ];
}

class StringDefaultPersistInclude extends _i1.IncludeObject {
  StringDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefaultPersist.t;
}

class StringDefaultPersistIncludeList extends _i1.IncludeList {
  StringDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefaultPersist.t;
}

class StringDefaultPersistRepository {
  const StringDefaultPersistRepository._();

  Future<List<StringDefaultPersist>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefaultPersist?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultPersistTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      orderBy: orderBy?.call(StringDefaultPersist.t),
      orderByList: orderByList?.call(StringDefaultPersist.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefaultPersist?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefaultPersist>(
      id,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultPersist>> insert(
    _i1.Session session,
    List<StringDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefaultPersist> insertRow(
    _i1.Session session,
    StringDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultPersist>> update(
    _i1.Session session,
    List<StringDefaultPersist> rows, {
    _i1.ColumnSelections<StringDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefaultPersist>(
      rows,
      columns: columns?.call(StringDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<StringDefaultPersist> updateRow(
    _i1.Session session,
    StringDefaultPersist row, {
    _i1.ColumnSelections<StringDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefaultPersist>(
      row,
      columns: columns?.call(StringDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<List<StringDefaultPersist>> delete(
    _i1.Session session,
    List<StringDefaultPersist> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefaultPersist>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefaultPersist> deleteRow(
    _i1.Session session,
    StringDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefaultPersist>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultPersistTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefaultPersist>(
      where: where(StringDefaultPersist.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefaultPersist>(
      where: where?.call(StringDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
