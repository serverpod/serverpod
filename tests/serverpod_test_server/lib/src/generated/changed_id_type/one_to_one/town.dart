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
import '../../changed_id_type/one_to_one/citizen.dart' as _i2;

abstract class TownInt implements _i1.TableRow<int>, _i1.ProtocolSerialization {
  TownInt._({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory TownInt({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) = _TownIntImpl;

  factory TownInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return TownInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      mayorId: jsonSerialization['mayorId'] as int?,
      mayor: jsonSerialization['mayor'] == null
          ? null
          : _i2.CitizenInt.fromJson(
              (jsonSerialization['mayor'] as Map<String, dynamic>)),
    );
  }

  static final t = TownIntTable();

  static const db = TownIntRepository._();

  @override
  int? id;

  String name;

  int? mayorId;

  _i2.CitizenInt? mayor;

  @override
  _i1.Table<int> get table => t;

  TownInt copyWith({
    int? id,
    String? name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (mayorId != null) 'mayorId': mayorId,
      if (mayor != null) 'mayor': mayor?.toJsonForProtocol(),
    };
  }

  static TownIntInclude include({_i2.CitizenIntInclude? mayor}) {
    return TownIntInclude._(mayor: mayor);
  }

  static TownIntIncludeList includeList({
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    TownIntInclude? include,
  }) {
    return TownIntIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TownInt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TownInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TownIntImpl extends TownInt {
  _TownIntImpl({
    int? id,
    required String name,
    int? mayorId,
    _i2.CitizenInt? mayor,
  }) : super._(
          id: id,
          name: name,
          mayorId: mayorId,
          mayor: mayor,
        );

  @override
  TownInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? mayorId = _Undefined,
    Object? mayor = _Undefined,
  }) {
    return TownInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      mayorId: mayorId is int? ? mayorId : this.mayorId,
      mayor: mayor is _i2.CitizenInt? ? mayor : this.mayor?.copyWith(),
    );
  }
}

class TownIntTable extends _i1.Table<int> {
  TownIntTable({super.tableRelation}) : super(tableName: 'town_int') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    mayorId = _i1.ColumnInt(
      'mayorId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt mayorId;

  _i2.CitizenIntTable? _mayor;

  _i2.CitizenIntTable get mayor {
    if (_mayor != null) return _mayor!;
    _mayor = _i1.createRelationTable(
      relationFieldName: 'mayor',
      field: TownInt.t.mayorId,
      foreignField: _i2.CitizenInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CitizenIntTable(tableRelation: foreignTableRelation),
    );
    return _mayor!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        mayorId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'mayor') {
      return mayor;
    }
    return null;
  }
}

class TownIntInclude extends _i1.IncludeObject {
  TownIntInclude._({_i2.CitizenIntInclude? mayor}) {
    _mayor = mayor;
  }

  _i2.CitizenIntInclude? _mayor;

  @override
  Map<String, _i1.Include?> get includes => {'mayor': _mayor};

  @override
  _i1.Table<int> get table => TownInt.t;
}

class TownIntIncludeList extends _i1.IncludeList {
  TownIntIncludeList._({
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TownInt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int> get table => TownInt.t;
}

class TownIntRepository {
  const TownIntRepository._();

  final attachRow = const TownIntAttachRowRepository._();

  final detachRow = const TownIntDetachRowRepository._();

  Future<List<TownInt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.find<int, TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<TownInt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? offset,
    _i1.OrderByBuilder<TownIntTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TownIntTable>? orderByList,
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.findFirstRow<int, TownInt>(
      where: where?.call(TownInt.t),
      orderBy: orderBy?.call(TownInt.t),
      orderByList: orderByList?.call(TownInt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<TownInt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TownIntInclude? include,
  }) async {
    return session.db.findById<int, TownInt>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<TownInt>> insert(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<int, TownInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<TownInt> insertRow(
    _i1.Session session,
    TownInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<int, TownInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<TownInt>> update(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.ColumnSelections<TownIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<int, TownInt>(
      rows,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
    );
  }

  Future<TownInt> updateRow(
    _i1.Session session,
    TownInt row, {
    _i1.ColumnSelections<TownIntTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<int, TownInt>(
      row,
      columns: columns?.call(TownInt.t),
      transaction: transaction,
    );
  }

  Future<List<TownInt>> delete(
    _i1.Session session,
    List<TownInt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<int, TownInt>(
      rows,
      transaction: transaction,
    );
  }

  Future<TownInt> deleteRow(
    _i1.Session session,
    TownInt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<int, TownInt>(
      row,
      transaction: transaction,
    );
  }

  Future<List<TownInt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TownIntTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<int, TownInt>(
      where: where(TownInt.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TownIntTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<int, TownInt>(
      where: where?.call(TownInt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TownIntAttachRowRepository {
  const TownIntAttachRowRepository._();

  Future<void> mayor(
    _i1.Session session,
    TownInt townInt,
    _i2.CitizenInt mayor, {
    _i1.Transaction? transaction,
  }) async {
    if (townInt.id == null) {
      throw ArgumentError.notNull('townInt.id');
    }
    if (mayor.id == null) {
      throw ArgumentError.notNull('mayor.id');
    }

    var $townInt = townInt.copyWith(mayorId: mayor.id);
    await session.db.updateRow<int, TownInt>(
      $townInt,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}

class TownIntDetachRowRepository {
  const TownIntDetachRowRepository._();

  Future<void> mayor(
    _i1.Session session,
    TownInt townint, {
    _i1.Transaction? transaction,
  }) async {
    if (townint.id == null) {
      throw ArgumentError.notNull('townint.id');
    }

    var $townint = townint.copyWith(mayorId: null);
    await session.db.updateRow<int, TownInt>(
      $townint,
      columns: [TownInt.t.mayorId],
      transaction: transaction,
    );
  }
}
