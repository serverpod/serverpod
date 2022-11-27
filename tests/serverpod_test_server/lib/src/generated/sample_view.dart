/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class SampleView extends _i1.ViewRow {
  SampleView({
    required this.description,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory SampleView.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SampleView(
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      createdBy: serializationManager
          .deserialize<String>(jsonSerialization['createdBy']),
      modifiedBy: serializationManager
          .deserialize<String>(jsonSerialization['modifiedBy']),
    );
  }

  static final t = SampleViewTable();

  String description;

  String createdBy;

  String modifiedBy;

  @override
  String get viewName => 'sample_view';
  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'description':
        description = value;
        return;
      case 'createdBy':
        createdBy = value;
        return;
      case 'modifiedBy':
        modifiedBy = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<SampleView>> find(
    _i1.Session session, {
    SampleViewExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SampleView>(
      where: where != null ? where(SampleView.t) : null,
      limit: limit,
      viewTable: true,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SampleView?> findSingleRow(
    _i1.Session session, {
    SampleViewExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SampleView>(
      where: where != null ? where(SampleView.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SampleView?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SampleView>(id);
  }

  static Future<int> count(
    _i1.Session session, {
    SampleViewExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SampleView>(
      where: where != null ? where(SampleView.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef SampleViewExpressionBuilder = _i1.Expression Function(SampleViewTable);

class SampleViewTable extends _i1.View {
  SampleViewTable() : super(viewName: 'sample_view');

  final description = _i1.ColumnString('description');

  final createdBy = _i1.ColumnString('createdBy');

  final modifiedBy = _i1.ColumnString('modifiedBy');

  @override
  List<_i1.Column> get columns => [
        description,
        createdBy,
        modifiedBy,
      ];
}

@Deprecated('Use SampleViewTable.t instead.')
SampleViewTable tSampleView = SampleViewTable();
