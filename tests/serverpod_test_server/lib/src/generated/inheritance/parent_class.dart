/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

class ParentClass extends _i1.GrandparentClass
    implements _i2.TableRow, _i2.ProtocolSerialization {
  ParentClass({
    this.id,
    required super.grandParentField,
    required this.parentField,
  });

  factory ParentClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentClass(
      id: jsonSerialization['id'] as int?,
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
    );
  }

  static final t = ParentClassTable();

  static const db = ParentClassRepository._();

  @override
  int? id;

  String parentField;

  @override
  _i2.Table get table => t;

  /// Returns a shallow copy of this [ParentClass]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  ParentClass copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
  }) {
    return ParentClass(
      id: id is int? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  static ParentClassInclude include() {
    return ParentClassInclude._();
  }

  static ParentClassIncludeList includeList({
    _i2.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ParentClassTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ParentClassTable>? orderByList,
    ParentClassInclude? include,
  }) {
    return ParentClassIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ParentClass.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ParentClass.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class ParentClassTable extends _i2.Table {
  ParentClassTable({super.tableRelation})
      : super(tableName: 'parent_class_table') {
    grandParentField = _i2.ColumnString(
      'grandParentField',
      this,
    );
    parentField = _i2.ColumnString(
      'parentField',
      this,
    );
  }

  late final _i2.ColumnString grandParentField;

  late final _i2.ColumnString parentField;

  @override
  List<_i2.Column> get columns => [
        id,
        grandParentField,
        parentField,
      ];
}

class ParentClassInclude extends _i2.IncludeObject {
  ParentClassInclude._();

  @override
  Map<String, _i2.Include?> get includes => {};

  @override
  _i2.Table get table => ParentClass.t;
}

class ParentClassIncludeList extends _i2.IncludeList {
  ParentClassIncludeList._({
    _i2.WhereExpressionBuilder<ParentClassTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ParentClass.t);
  }

  @override
  Map<String, _i2.Include?> get includes => include?.includes ?? {};

  @override
  _i2.Table get table => ParentClass.t;
}

class ParentClassRepository {
  const ParentClassRepository._();

  Future<List<ParentClass>> find(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    int? offset,
    _i2.OrderByBuilder<ParentClassTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ParentClassTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.find<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ParentClass?> findFirstRow(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ParentClassTable>? where,
    int? offset,
    _i2.OrderByBuilder<ParentClassTable>? orderBy,
    bool orderDescending = false,
    _i2.OrderByListBuilder<ParentClassTable>? orderByList,
    _i2.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ParentClass>(
      where: where?.call(ParentClass.t),
      orderBy: orderBy?.call(ParentClass.t),
      orderByList: orderByList?.call(ParentClass.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ParentClass?> findById(
    _i2.Session session,
    int id, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.findById<ParentClass>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ParentClass>> insert(
    _i2.Session session,
    List<ParentClass> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insert<ParentClass>(
      rows,
      transaction: transaction,
    );
  }

  Future<ParentClass> insertRow(
    _i2.Session session,
    ParentClass row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.insertRow<ParentClass>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ParentClass>> update(
    _i2.Session session,
    List<ParentClass> rows, {
    _i2.ColumnSelections<ParentClassTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.update<ParentClass>(
      rows,
      columns: columns?.call(ParentClass.t),
      transaction: transaction,
    );
  }

  Future<ParentClass> updateRow(
    _i2.Session session,
    ParentClass row, {
    _i2.ColumnSelections<ParentClassTable>? columns,
    _i2.Transaction? transaction,
  }) async {
    return session.db.updateRow<ParentClass>(
      row,
      columns: columns?.call(ParentClass.t),
      transaction: transaction,
    );
  }

  Future<List<ParentClass>> delete(
    _i2.Session session,
    List<ParentClass> rows, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.delete<ParentClass>(
      rows,
      transaction: transaction,
    );
  }

  Future<ParentClass> deleteRow(
    _i2.Session session,
    ParentClass row, {
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ParentClass>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ParentClass>> deleteWhere(
    _i2.Session session, {
    required _i2.WhereExpressionBuilder<ParentClassTable> where,
    _i2.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ParentClass>(
      where: where(ParentClass.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i2.Session session, {
    _i2.WhereExpressionBuilder<ParentClassTable>? where,
    int? limit,
    _i2.Transaction? transaction,
  }) async {
    return session.db.count<ParentClass>(
      where: where?.call(ParentClass.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
