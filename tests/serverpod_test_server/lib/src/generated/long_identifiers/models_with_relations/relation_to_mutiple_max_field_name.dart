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

abstract class RelationToMultipleMaxFieldName extends _i1.TableRow {
  RelationToMultipleMaxFieldName._({
    int? id,
    required this.name,
    this.multipleMaxFieldNames,
  }) : super(id);

  factory RelationToMultipleMaxFieldName({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) = _RelationToMultipleMaxFieldNameImpl;

  factory RelationToMultipleMaxFieldName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RelationToMultipleMaxFieldName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      multipleMaxFieldNames:
          (jsonSerialization['multipleMaxFieldNames'] as List<dynamic>?)
              ?.map((e) =>
                  _i2.MultipleMaxFieldName.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  static final t = RelationToMultipleMaxFieldNameTable();

  static const db = RelationToMultipleMaxFieldNameRepository._();

  String name;

  List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames;

  @override
  _i1.Table get table => t;

  RelationToMultipleMaxFieldName copyWith({
    int? id,
    String? name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames':
            multipleMaxFieldNames?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames':
            multipleMaxFieldNames?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static RelationToMultipleMaxFieldNameInclude include(
      {_i2.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames}) {
    return RelationToMultipleMaxFieldNameInclude._(
        multipleMaxFieldNames: multipleMaxFieldNames);
  }

  static RelationToMultipleMaxFieldNameIncludeList includeList({
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    RelationToMultipleMaxFieldNameInclude? include,
  }) {
    return RelationToMultipleMaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _RelationToMultipleMaxFieldNameImpl
    extends RelationToMultipleMaxFieldName {
  _RelationToMultipleMaxFieldNameImpl({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) : super._(
          id: id,
          name: name,
          multipleMaxFieldNames: multipleMaxFieldNames,
        );

  @override
  RelationToMultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? multipleMaxFieldNames = _Undefined,
  }) {
    return RelationToMultipleMaxFieldName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      multipleMaxFieldNames:
          multipleMaxFieldNames is List<_i2.MultipleMaxFieldName>?
              ? multipleMaxFieldNames
              : this.multipleMaxFieldNames?.clone(),
    );
  }
}

class RelationToMultipleMaxFieldNameTable extends _i1.Table {
  RelationToMultipleMaxFieldNameTable({super.tableRelation})
      : super(tableName: 'relation_to_multiple_max_field_name') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.MultipleMaxFieldNameTable? ___multipleMaxFieldNames;

  _i1.ManyRelation<_i2.MultipleMaxFieldNameTable>? _multipleMaxFieldNames;

  _i2.MultipleMaxFieldNameTable get __multipleMaxFieldNames {
    if (___multipleMaxFieldNames != null) return ___multipleMaxFieldNames!;
    ___multipleMaxFieldNames = _i1.createRelationTable(
      relationFieldName: '__multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _i2.MultipleMaxFieldName.t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MultipleMaxFieldNameTable(tableRelation: foreignTableRelation),
    );
    return ___multipleMaxFieldNames!;
  }

  _i1.ManyRelation<_i2.MultipleMaxFieldNameTable> get multipleMaxFieldNames {
    if (_multipleMaxFieldNames != null) return _multipleMaxFieldNames!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'multipleMaxFieldNames',
      field: RelationToMultipleMaxFieldName.t.id,
      foreignField: _i2.MultipleMaxFieldName.t
          .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MultipleMaxFieldNameTable(tableRelation: foreignTableRelation),
    );
    _multipleMaxFieldNames = _i1.ManyRelation<_i2.MultipleMaxFieldNameTable>(
      tableWithRelations: relationTable,
      table: _i2.MultipleMaxFieldNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _multipleMaxFieldNames!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'multipleMaxFieldNames') {
      return __multipleMaxFieldNames;
    }
    return null;
  }
}

class RelationToMultipleMaxFieldNameInclude extends _i1.IncludeObject {
  RelationToMultipleMaxFieldNameInclude._(
      {_i2.MultipleMaxFieldNameIncludeList? multipleMaxFieldNames}) {
    _multipleMaxFieldNames = multipleMaxFieldNames;
  }

  _i2.MultipleMaxFieldNameIncludeList? _multipleMaxFieldNames;

  @override
  Map<String, _i1.Include?> get includes =>
      {'multipleMaxFieldNames': _multipleMaxFieldNames};

  @override
  _i1.Table get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameIncludeList extends _i1.IncludeList {
  RelationToMultipleMaxFieldNameIncludeList._({
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RelationToMultipleMaxFieldName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => RelationToMultipleMaxFieldName.t;
}

class RelationToMultipleMaxFieldNameRepository {
  const RelationToMultipleMaxFieldNameRepository._();

  final attach = const RelationToMultipleMaxFieldNameAttachRepository._();

  final attachRow = const RelationToMultipleMaxFieldNameAttachRowRepository._();

  final detach = const RelationToMultipleMaxFieldNameDetachRepository._();

  final detachRow = const RelationToMultipleMaxFieldNameDetachRowRepository._();

  Future<List<RelationToMultipleMaxFieldName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.find<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelationToMultipleMaxFieldName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<RelationToMultipleMaxFieldNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RelationToMultipleMaxFieldNameTable>? orderByList,
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.findFirstRow<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      orderBy: orderBy?.call(RelationToMultipleMaxFieldName.t),
      orderByList: orderByList?.call(RelationToMultipleMaxFieldName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<RelationToMultipleMaxFieldName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    RelationToMultipleMaxFieldNameInclude? include,
  }) async {
    return session.db.findById<RelationToMultipleMaxFieldName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<RelationToMultipleMaxFieldName>> insert(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<RelationToMultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<RelationToMultipleMaxFieldName> insertRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelationToMultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<RelationToMultipleMaxFieldName>> update(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RelationToMultipleMaxFieldName>(
      rows,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<RelationToMultipleMaxFieldName> updateRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.ColumnSelections<RelationToMultipleMaxFieldNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelationToMultipleMaxFieldName>(
      row,
      columns: columns?.call(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<RelationToMultipleMaxFieldName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RelationToMultipleMaxFieldName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    RelationToMultipleMaxFieldName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelationToMultipleMaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RelationToMultipleMaxFieldName>(
      where: where(RelationToMultipleMaxFieldName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RelationToMultipleMaxFieldNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RelationToMultipleMaxFieldName>(
      where: where?.call(RelationToMultipleMaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRepository {
  const RelationToMultipleMaxFieldNameAttachRepository._();

  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    List<_i2.MultipleMaxFieldName> multipleMaxFieldName,
  ) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map((e) => _i2.MultipleMaxFieldNameImplicit(
              e,
              $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                  relationToMultipleMaxFieldName.id,
            ))
        .toList();
    await session.db.update<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
    );
  }
}

class RelationToMultipleMaxFieldNameAttachRowRepository {
  const RelationToMultipleMaxFieldNameAttachRowRepository._();

  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    RelationToMultipleMaxFieldName relationToMultipleMaxFieldName,
    _i2.MultipleMaxFieldName multipleMaxFieldName,
  ) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }
    if (relationToMultipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('relationToMultipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _i2.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
          relationToMultipleMaxFieldName.id,
    );
    await session.db.updateRow<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRepository {
  const RelationToMultipleMaxFieldNameDetachRepository._();

  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    List<_i2.MultipleMaxFieldName> multipleMaxFieldName,
  ) async {
    if (multipleMaxFieldName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = multipleMaxFieldName
        .map((e) => _i2.MultipleMaxFieldNameImplicit(
              e,
              $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId:
                  null,
            ))
        .toList();
    await session.db.update<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
    );
  }
}

class RelationToMultipleMaxFieldNameDetachRowRepository {
  const RelationToMultipleMaxFieldNameDetachRowRepository._();

  Future<void> multipleMaxFieldNames(
    _i1.Session session,
    _i2.MultipleMaxFieldName multipleMaxFieldName,
  ) async {
    if (multipleMaxFieldName.id == null) {
      throw ArgumentError.notNull('multipleMaxFieldName.id');
    }

    var $multipleMaxFieldName = _i2.MultipleMaxFieldNameImplicit(
      multipleMaxFieldName,
      $_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId: null,
    );
    await session.db.updateRow<_i2.MultipleMaxFieldName>(
      $multipleMaxFieldName,
      columns: [
        _i2.MultipleMaxFieldName.t
            .$_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId
      ],
    );
  }
}
