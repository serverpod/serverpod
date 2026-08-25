/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'projected_order.dart';

abstract class ProjectedOrderSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedOrderSummary._({
    this.id,
    this.summary,
  });

  factory ProjectedOrderSummary({
    _is.UuidValue? id,
    String? summary,
  }) = _ProjectedOrderSummaryImpl;

  factory ProjectedOrderSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedOrderSummary(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      summary: jsonSerialization['summary'] as String?,
    );
  }

  static const db = ProjectedOrderSummaryRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  String? summary;

  /// Returns a shallow copy of this [ProjectedOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedOrderSummary copyWith({
    _is.UuidValue? id,
    String? summary,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrderSummary',
      if (id != null) 'id': id?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrderSummary',
      if (id != null) 'id': id?.toJson(),
      if (summary != null) 'summary': summary,
    };
  }

  static ProjectedOrderInclude include() {
    return ProjectedOrder.include(
      select: (t) => [
        ProjectedOrder.t.id,
        ProjectedOrder.t.summary,
      ],
    );
  }

  static ProjectedOrderIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
  }) {
    return ProjectedOrder.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedOrderSummary.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderSummaryImpl extends ProjectedOrderSummary {
  _ProjectedOrderSummaryImpl({
    _is.UuidValue? id,
    String? summary,
  }) : super._(
         id: id,
         summary: summary,
       );

  /// Returns a shallow copy of this [ProjectedOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedOrderSummary copyWith({
    Object? id = _Undefined,
    Object? summary = _Undefined,
  }) {
    return ProjectedOrderSummary(
      id: id is _is.UuidValue? ? id : this.id,
      summary: summary is String? ? summary : this.summary,
    );
  }
}

class ProjectedOrderSummaryRepository {
  const ProjectedOrderSummaryRepository._();

  /// Returns a list of [ProjectedOrder]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ProjectedOrderSummary>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedOrder>(
          where: where?.call(ProjectedOrder.t),
          orderBy: orderBy?.call(ProjectedOrder.t),
          orderByList: orderByList?.call(ProjectedOrder.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedOrderSummary.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) => rows.map((e) => ProjectedOrderSummary.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedOrder] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ProjectedOrderSummary?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedOrder>(
          where: where?.call(ProjectedOrder.t),
          orderBy: orderBy?.call(ProjectedOrder.t),
          orderByList: orderByList?.call(ProjectedOrder.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedOrderSummary.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedOrderSummary.fromJson(e));
  }

  /// Finds a single [ProjectedOrder] by its [id] or null if no such row exists.
  Future<ProjectedOrderSummary?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedOrder>(
          id,
          transaction: transaction,
          include: ProjectedOrderSummary.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedOrderSummary.fromJson(e));
  }
}
