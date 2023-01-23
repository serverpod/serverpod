/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class ObjectWithDuration extends _i1.TableRow {
  ObjectWithDuration({
    int? id,
    required this.duration,
  }) : super(id);

  factory ObjectWithDuration.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithDuration(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      duration: serializationManager
          .deserialize<Duration>(jsonSerialization['duration']),
    );
  }

  static final t = ObjectWithDurationTable();

  Duration duration;

  @override
  String get tableName => 'object_with_duration';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'duration': duration,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'duration': duration,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'duration':
        duration = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectWithDuration>> find(
    _i1.Session session, {
    ObjectWithDurationExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithDuration>(
      where: where != null ? where(ObjectWithDuration.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithDuration?> findSingleRow(
    _i1.Session session, {
    ObjectWithDurationExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithDuration>(
      where: where != null ? where(ObjectWithDuration.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithDuration?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ObjectWithDuration>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ObjectWithDurationExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithDuration>(
      where: where(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ObjectWithDurationExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithDuration>(
      where: where != null ? where(ObjectWithDuration.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectWithDurationExpressionBuilder = _i1.Expression Function(
    ObjectWithDurationTable);

class ObjectWithDurationTable extends _i1.Table {
  ObjectWithDurationTable() : super(tableName: 'object_with_duration');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  final duration = _i1.ColumnDuration('duration');

  @override
  List<_i1.Column> get columns => [
        id,
        duration,
      ];
}

@Deprecated('Use ObjectWithDurationTable.t instead.')
ObjectWithDurationTable tObjectWithDuration = ObjectWithDurationTable();
