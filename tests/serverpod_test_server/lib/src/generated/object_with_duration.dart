/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ObjectWithDurationExpressionBuilder = _i1.Expression Function(
    ObjectWithDurationTable);

abstract class ObjectWithDuration extends _i1.TableRow {
  const ObjectWithDuration._();

  const factory ObjectWithDuration({
    int? id,
    required Duration duration,
  }) = _ObjectWithDuration;

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

  static const t = ObjectWithDurationTable();

  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  });
  @override
  String get tableName => 'object_with_duration';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'duration': duration,
    };
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

  Duration get duration;
}

class _Undefined {}

class _ObjectWithDuration extends ObjectWithDuration {
  const _ObjectWithDuration({
    int? id,
    required this.duration,
  }) : super._();

  @override
  final Duration duration;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithDuration &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
        id,
        duration,
      );

  @override
  ObjectWithDuration copyWith({
    Object? id = _Undefined,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id == _Undefined ? this.id : (id as int?),
      duration: duration ?? this.duration,
    );
  }
}

class ObjectWithDurationTable extends _i1.Table {
  const ObjectWithDurationTable() : super(tableName: 'object_with_duration');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  final duration = const _i1.ColumnDuration('duration');

  @override
  List<_i1.Column> get columns => [
        id,
        duration,
      ];
}

@Deprecated('Use ObjectWithDurationTable.t instead.')
ObjectWithDurationTable tObjectWithDuration = const ObjectWithDurationTable();
