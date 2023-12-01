/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class CitizenEmploymentView extends _i1.TableRow {
  CitizenEmploymentView._({
    required this.citizenId,
    required this.name,
    required this.homeAddress,
    required this.currentCompany,
    required this.companyLocation,
  });

  factory CitizenEmploymentView({
    required int citizenId,
    required String name,
    required String homeAddress,
    required String currentCompany,
    required String companyLocation,
  }) = _CitizenEmploymentViewImpl;

  factory CitizenEmploymentView.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CitizenEmploymentView(
      citizenId:
          serializationManager.deserialize<int>(jsonSerialization['citizenId']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      homeAddress: serializationManager
          .deserialize<String>(jsonSerialization['homeAddress']),
      currentCompany: serializationManager
          .deserialize<String>(jsonSerialization['currentCompany']),
      companyLocation: serializationManager
          .deserialize<String>(jsonSerialization['companyLocation']),
    );
  }

  static final t = CitizenEmploymentViewTable();

  static const db = CitizenEmploymentViewRepository._();

  int citizenId;

  String name;

  String homeAddress;

  String currentCompany;

  String companyLocation;

  @override
  _i1.Table get table => t;

  CitizenEmploymentView copyWith({
    int? citizenId,
    String? name,
    String? homeAddress,
    String? currentCompany,
    String? companyLocation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'citizenId': citizenId,
      'name': name,
      'homeAddress': homeAddress,
      'currentCompany': currentCompany,
      'companyLocation': companyLocation,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'citizenId': citizenId,
      'name': name,
      'homeAddress': homeAddress,
      'currentCompany': currentCompany,
      'companyLocation': companyLocation,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'citizenId': citizenId,
      'name': name,
      'homeAddress': homeAddress,
      'currentCompany': currentCompany,
      'companyLocation': companyLocation,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'citizenId':
        citizenId = value;
        return;
      case 'name':
        name = value;
        return;
      case 'homeAddress':
        homeAddress = value;
        return;
      case 'currentCompany':
        currentCompany = value;
        return;
      case 'companyLocation':
        companyLocation = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<CitizenEmploymentView>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CitizenEmploymentView>(
      where: where != null ? where(CitizenEmploymentView.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      viewTable: true,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CitizenEmploymentView>(
      where: where != null ? where(CitizenEmploymentView.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

class _CitizenEmploymentViewImpl extends CitizenEmploymentView {
  _CitizenEmploymentViewImpl({
    required int citizenId,
    required String name,
    required String homeAddress,
    required String currentCompany,
    required String companyLocation,
  }) : super._(
          citizenId: citizenId,
          name: name,
          homeAddress: homeAddress,
          currentCompany: currentCompany,
          companyLocation: companyLocation,
        );

  @override
  CitizenEmploymentView copyWith({
    int? citizenId,
    String? name,
    String? homeAddress,
    String? currentCompany,
    String? companyLocation,
  }) {
    return CitizenEmploymentView(
      citizenId: citizenId ?? this.citizenId,
      name: name ?? this.name,
      homeAddress: homeAddress ?? this.homeAddress,
      currentCompany: currentCompany ?? this.currentCompany,
      companyLocation: companyLocation ?? this.companyLocation,
    );
  }
}

class CitizenEmploymentViewTable extends _i1.Table {
  CitizenEmploymentViewTable() : super(tableName: 'citizen_employment_view') {
    citizenId = _i1.ColumnInt(
      'citizenId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    homeAddress = _i1.ColumnString(
      'homeAddress',
      this,
    );
    currentCompany = _i1.ColumnString(
      'currentCompany',
      this,
    );
    companyLocation = _i1.ColumnString(
      'companyLocation',
      this,
    );
  }

  late final _i1.ColumnInt citizenId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString homeAddress;

  late final _i1.ColumnString currentCompany;

  late final _i1.ColumnString companyLocation;

  @override
  List<_i1.Column> get columns => [
        citizenId,
        name,
        homeAddress,
        currentCompany,
        companyLocation,
      ];
}

@Deprecated('Use CitizenEmploymentViewTable.t instead.')
CitizenEmploymentViewTable tCitizenEmploymentView =
    CitizenEmploymentViewTable();

class CitizenEmploymentViewInclude extends _i1.IncludeObject {
  CitizenEmploymentViewInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => CitizenEmploymentView.t;
}

class CitizenEmploymentViewIncludeList extends _i1.IncludeList {
  CitizenEmploymentViewIncludeList._({
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CitizenEmploymentView.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => CitizenEmploymentView.t;
}

class CitizenEmploymentViewRepository {
  const CitizenEmploymentViewRepository._();

  Future<List<CitizenEmploymentView>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CitizenEmploymentViewTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenEmploymentViewTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<CitizenEmploymentView>(
      where: where?.call(CitizenEmploymentView.t),
      orderBy: orderBy?.call(CitizenEmploymentView.t),
      orderByList: orderByList?.call(CitizenEmploymentView.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      viewTable: true,
    );
  }

  Future<CitizenEmploymentView?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    int? offset,
    _i1.OrderByBuilder<CitizenEmploymentViewTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CitizenEmploymentViewTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<CitizenEmploymentView>(
      where: where?.call(CitizenEmploymentView.t),
      orderBy: orderBy?.call(CitizenEmploymentView.t),
      orderByList: orderByList?.call(CitizenEmploymentView.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      viewTable: true,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CitizenEmploymentViewTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<CitizenEmploymentView>(
      where: where?.call(CitizenEmploymentView.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
