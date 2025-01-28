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

abstract class StringDefault
    implements _i1.TableRow, _i1.ProtocolSerialization {
  StringDefault._({
    this.id,
    String? stringDefault,
    String? stringDefaultNull,
  })  : stringDefault = stringDefault ?? 'This is a default value',
        stringDefaultNull = stringDefaultNull ?? 'This is a default null value';

  factory StringDefault({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) = _StringDefaultImpl;

  factory StringDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefault(
      id: jsonSerialization['id'] as int?,
      stringDefault: jsonSerialization['stringDefault'] as String,
      stringDefaultNull: jsonSerialization['stringDefaultNull'] as String?,
    );
  }

  static final t = StringDefaultTable();

  static const db = StringDefaultRepository._();

  @override
  int? id;

  String stringDefault;

  String? stringDefaultNull;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefault copyWith({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  static StringDefaultInclude include() {
    return StringDefaultInclude._();
  }

  static StringDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    StringDefaultInclude? include,
  }) {
    return StringDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefault.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(StringDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultImpl extends StringDefault {
  _StringDefaultImpl({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) : super._(
          id: id,
          stringDefault: stringDefault,
          stringDefaultNull: stringDefaultNull,
        );

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefault copyWith({
    Object? id = _Undefined,
    String? stringDefault,
    Object? stringDefaultNull = _Undefined,
  }) {
    return StringDefault(
      id: id is int? ? id : this.id,
      stringDefault: stringDefault ?? this.stringDefault,
      stringDefaultNull: stringDefaultNull is String?
          ? stringDefaultNull
          : this.stringDefaultNull,
    );
  }
}

class StringDefaultTable extends _i1.Table {
  StringDefaultTable({super.tableRelation})
      : super(tableName: 'string_default') {
    stringDefault = _i1.ColumnString(
      'stringDefault',
      this,
      hasDefault: true,
    );
    stringDefaultNull = _i1.ColumnString(
      'stringDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnString stringDefault;

  late final _i1.ColumnString stringDefaultNull;

  @override
  List<_i1.Column> get columns => [
        id,
        stringDefault,
        stringDefaultNull,
      ];
}

class StringDefaultInclude extends _i1.IncludeObject {
  StringDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => StringDefault.t;
}

class StringDefaultIncludeList extends _i1.IncludeList {
  StringDefaultIncludeList._({
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StringDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => StringDefault.t;
}

class StringDefaultRepository {
  const StringDefaultRepository._();

  Future<List<StringDefault>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefault?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<StringDefaultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<StringDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<StringDefault?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<StringDefault>(
      id,
      transaction: transaction,
    );
  }

  Future<List<StringDefault>> insert(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<StringDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefault> insertRow(
    _i1.Session session,
    StringDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefault>> update(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.ColumnSelections<StringDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<StringDefault>(
      rows,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  Future<StringDefault> updateRow(
    _i1.Session session,
    StringDefault row, {
    _i1.ColumnSelections<StringDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefault>(
      row,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  Future<List<StringDefault>> delete(
    _i1.Session session,
    List<StringDefault> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<StringDefault>(
      rows,
      transaction: transaction,
    );
  }

  Future<StringDefault> deleteRow(
    _i1.Session session,
    StringDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefault>(
      row,
      transaction: transaction,
    );
  }

  Future<List<StringDefault>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<StringDefaultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<StringDefault>(
      where: where(StringDefault.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<StringDefault>(
      where: where?.call(StringDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
