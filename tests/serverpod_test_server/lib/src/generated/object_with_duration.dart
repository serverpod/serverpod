/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class ObjectWithDuration extends _i1.TableRow {
  ObjectWithDuration._({
    int? id,
    required this.duration,
  }) : super(id);

  factory ObjectWithDuration({
    int? id,
    required Duration duration,
  }) = _ObjectWithDurationImpl;

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

  static const db = ObjectWithDurationRepository._();

  Duration duration;

  @override
  _i1.Table get table => t;

  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  static ObjectWithDurationInclude include() {
    return ObjectWithDurationInclude._();
  }

  static ObjectWithDurationIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    ObjectWithDurationInclude? include,
  }) {
    return ObjectWithDurationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ObjectWithDuration.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ObjectWithDurationImpl extends ObjectWithDuration {
  _ObjectWithDurationImpl({
    int? id,
    required Duration duration,
  }) : super._(
          id: id,
          duration: duration,
        );

  @override
  ObjectWithDuration copyWith({
    Object? id = _Undefined,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id is int? ? id : this.id,
      duration: duration ?? this.duration,
    );
  }
}

class ObjectWithDurationTable extends _i1.Table {
  ObjectWithDurationTable({super.tableRelation})
      : super(tableName: 'object_with_duration') {
    duration = _i1.ColumnDuration(
      'duration',
      this,
    );
  }

  late final _i1.ColumnDuration duration;

  @override
  List<_i1.Column> get columns => [
        id,
        duration,
      ];
}

class ObjectWithDurationInclude extends _i1.IncludeObject {
  ObjectWithDurationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ObjectWithDuration.t;
}

class ObjectWithDurationIncludeList extends _i1.IncludeList {
  ObjectWithDurationIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithDuration.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ObjectWithDuration.t;
}

class ObjectWithDurationRepository {
  const ObjectWithDurationRepository._();

  Future<List<ObjectWithDuration>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithDuration?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ObjectWithDuration?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<ObjectWithDuration>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithDuration>> insert(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<ObjectWithDuration>(
      rows,
      transaction: transaction,
    );
  }

  Future<ObjectWithDuration> insertRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<ObjectWithDuration>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ObjectWithDuration>> update(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.ColumnSelections<ObjectWithDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<ObjectWithDuration>(
      rows,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  Future<ObjectWithDuration> updateRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.ColumnSelections<ObjectWithDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<ObjectWithDuration>(
      row,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ObjectWithDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<ObjectWithDuration>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ObjectWithDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<ObjectWithDuration>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ObjectWithDurationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<ObjectWithDuration>(
      where: where(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
