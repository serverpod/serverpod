/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef SimpleDataExpressionBuilder = _i1.Expression Function(SimpleDataTable);

/// Just some simple data.
abstract class SimpleData extends _i1.TableRow {
  const SimpleData._();

  const factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleData;

  factory SimpleData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      num: serializationManager.deserialize<int>(jsonSerialization['num']),
    );
  }

  static const t = SimpleDataTable();

  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  String get tableName => 'simple_data';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'num': num,
    };
  }

  static Future<List<SimpleData>> find(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findSingleRow(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SimpleData>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SimpleDataExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SimpleData>(
      where: where(SimpleData.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    SimpleData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int get num;
}

class _Undefined {}

/// Just some simple data.
class _SimpleData extends SimpleData {
  const _SimpleData({
    int? id,
    required this.num,
  }) : super._();

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  @override
  final int num;

  @override
  String get tableName => 'simple_data';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SimpleData &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.num,
                  num,
                ) ||
                other.num == num));
  }

  @override
  int get hashCode => Object.hash(
        id,
        num,
      );

  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id == _Undefined ? this.id : (id as int?),
      num: num ?? this.num,
    );
  }
}

class SimpleDataTable extends _i1.Table {
  const SimpleDataTable() : super(tableName: 'simple_data');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  final num = const _i1.ColumnInt('num');

  @override
  List<_i1.Column> get columns => [
        id,
        num,
      ];
}

@Deprecated('Use SimpleDataTable.t instead.')
SimpleDataTable tSimpleData = const SimpleDataTable();
