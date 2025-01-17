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
import '../../changed_id_type/one_to_one/town.dart' as _i2;

abstract class CompanyUuid
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  CompanyUuid._({
    this.id,
    required this.name,
    required this.townId,
    this.town,
  });

  factory CompanyUuid({
    _i1.UuidValue? id,
    required String name,
    required int townId,
    _i2.TownInt? town,
  }) = _CompanyUuidImpl;

  factory CompanyUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CompanyUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      townId: jsonSerialization['townId'] as int,
      town: jsonSerialization['town'] == null
          ? null
          : _i2.TownInt.fromJson(
              (jsonSerialization['town'] as Map<String, dynamic>)),
    );
  }

  static final t = CompanyUuidTable();

  static const db = CompanyUuidRepository._();

  @override
  _i1.UuidValue? id;

  String name;

  int townId;

  _i2.TownInt? town;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  CompanyUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    int? townId,
    _i2.TownInt? town,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'townId': townId,
      if (town != null) 'town': town?.toJsonForProtocol(),
    };
  }

  static CompanyUuidInclude include({_i2.TownIntInclude? town}) {
    return CompanyUuidInclude._(town: town);
  }

  static CompanyUuidIncludeList includeList({
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    CompanyUuidInclude? include,
  }) {
    return CompanyUuidIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CompanyUuid.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyUuidImpl extends CompanyUuid {
  _CompanyUuidImpl({
    _i1.UuidValue? id,
    required String name,
    required int townId,
    _i2.TownInt? town,
  }) : super._(
          id: id,
          name: name,
          townId: townId,
          town: town,
        );

  @override
  CompanyUuid copyWith({
    Object? id = _Undefined,
    String? name,
    int? townId,
    Object? town = _Undefined,
  }) {
    return CompanyUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      townId: townId ?? this.townId,
      town: town is _i2.TownInt? ? town : this.town?.copyWith(),
    );
  }
}

class CompanyUuidTable extends _i1.Table<_i1.UuidValue> {
  CompanyUuidTable({super.tableRelation}) : super(tableName: 'company_uuid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    townId = _i1.ColumnInt(
      'townId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt townId;

  _i2.TownIntTable? _town;

  _i2.TownIntTable get town {
    if (_town != null) return _town!;
    _town = _i1.createRelationTable(
      relationFieldName: 'town',
      field: CompanyUuid.t.townId,
      foreignField: _i2.TownInt.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.TownIntTable(tableRelation: foreignTableRelation),
    );
    return _town!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        townId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'town') {
      return town;
    }
    return null;
  }
}

class CompanyUuidInclude extends _i1.IncludeObject {
  CompanyUuidInclude._({_i2.TownIntInclude? town}) {
    _town = town;
  }

  _i2.TownIntInclude? _town;

  @override
  Map<String, _i1.Include?> get includes => {'town': _town};

  @override
  _i1.Table<_i1.UuidValue> get table => CompanyUuid.t;
}

class CompanyUuidIncludeList extends _i1.IncludeList {
  CompanyUuidIncludeList._({
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CompanyUuid.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => CompanyUuid.t;
}

class CompanyUuidRepository {
  const CompanyUuidRepository._();

  final attachRow = const CompanyUuidAttachRowRepository._();

  Future<List<CompanyUuid>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.find<_i1.UuidValue, CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      orderBy: orderBy?.call(CompanyUuid.t),
      orderByList: orderByList?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CompanyUuid?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? offset,
    _i1.OrderByBuilder<CompanyUuidTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyUuidTable>? orderByList,
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.findFirstRow<_i1.UuidValue, CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      orderBy: orderBy?.call(CompanyUuid.t),
      orderByList: orderByList?.call(CompanyUuid.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CompanyUuid?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    CompanyUuidInclude? include,
  }) async {
    return session.db.findById<_i1.UuidValue, CompanyUuid>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<CompanyUuid>> insert(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<_i1.UuidValue, CompanyUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<CompanyUuid> insertRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<_i1.UuidValue, CompanyUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CompanyUuid>> update(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.ColumnSelections<CompanyUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<_i1.UuidValue, CompanyUuid>(
      rows,
      columns: columns?.call(CompanyUuid.t),
      transaction: transaction,
    );
  }

  Future<CompanyUuid> updateRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.ColumnSelections<CompanyUuidTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<_i1.UuidValue, CompanyUuid>(
      row,
      columns: columns?.call(CompanyUuid.t),
      transaction: transaction,
    );
  }

  Future<List<CompanyUuid>> delete(
    _i1.Session session,
    List<CompanyUuid> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<_i1.UuidValue, CompanyUuid>(
      rows,
      transaction: transaction,
    );
  }

  Future<CompanyUuid> deleteRow(
    _i1.Session session,
    CompanyUuid row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<_i1.UuidValue, CompanyUuid>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CompanyUuid>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CompanyUuidTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<_i1.UuidValue, CompanyUuid>(
      where: where(CompanyUuid.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyUuidTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<_i1.UuidValue, CompanyUuid>(
      where: where?.call(CompanyUuid.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CompanyUuidAttachRowRepository {
  const CompanyUuidAttachRowRepository._();

  Future<void> town(
    _i1.Session session,
    CompanyUuid companyUuid,
    _i2.TownInt town, {
    _i1.Transaction? transaction,
  }) async {
    if (companyUuid.id == null) {
      throw ArgumentError.notNull('companyUuid.id');
    }
    if (town.id == null) {
      throw ArgumentError.notNull('town.id');
    }

    var $companyUuid = companyUuid.copyWith(townId: town.id);
    await session.db.updateRow<_i1.UuidValue, CompanyUuid>(
      $companyUuid,
      columns: [CompanyUuid.t.townId],
      transaction: transaction,
    );
  }
}
