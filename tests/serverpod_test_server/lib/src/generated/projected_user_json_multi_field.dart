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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'projected_user.dart';

abstract class ProjectedUserJsonMultiField
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedUserJsonMultiField._({
    this.id,
    required this.name,
    this.jsonFieldText,
    this.jsonFieldValue,
    this.jsonFieldMapA,
    this.jsonFieldListA,
    this.jsonFieldDateValue,
  });

  factory ProjectedUserJsonMultiField({
    int? id,
    required String name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  }) = _ProjectedUserJsonMultiFieldImpl;

  factory ProjectedUserJsonMultiField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserJsonMultiField(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      jsonFieldText:
          (jsonSerialization['jsonFieldText'] ??
                  (jsonSerialization['jsonField'] as Map?)?['text'])
              as String?,
      jsonFieldValue:
          (jsonSerialization['jsonFieldValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['value'])
              as int?,
      jsonFieldMapA:
          (jsonSerialization['jsonFieldMapA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['mapA']) ==
              null
          ? null
          : _igqrxdcj.Protocol().deserialize<Map<String, int>>(
              (jsonSerialization['jsonFieldMapA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['mapA']),
            ),
      jsonFieldListA:
          (jsonSerialization['jsonFieldListA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['listA']) ==
              null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<int>>(
              (jsonSerialization['jsonFieldListA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['listA']),
            ),
      jsonFieldDateValue:
          (jsonSerialization['jsonFieldDateValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['dateValue']) ==
              null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              (jsonSerialization['jsonFieldDateValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['dateValue']),
            ),
    );
  }

  static const db = ProjectedUserJsonMultiFieldRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? jsonFieldText;

  int? jsonFieldValue;

  Map<String, int>? jsonFieldMapA;

  List<int>? jsonFieldListA;

  DateTime? jsonFieldDateValue;

  /// Returns a shallow copy of this [ProjectedUserJsonMultiField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedUserJsonMultiField copyWith({
    int? id,
    String? name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserJsonMultiField',
      if (id != null) 'id': id,
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
      if (jsonFieldValue != null) 'jsonFieldValue': jsonFieldValue,
      if (jsonFieldMapA != null) 'jsonFieldMapA': jsonFieldMapA?.toJson(),
      if (jsonFieldListA != null) 'jsonFieldListA': jsonFieldListA?.toJson(),
      if (jsonFieldDateValue != null)
        'jsonFieldDateValue': jsonFieldDateValue?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserJsonMultiField',
      if (id != null) 'id': id,
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
      if (jsonFieldValue != null) 'jsonFieldValue': jsonFieldValue,
      if (jsonFieldMapA != null) 'jsonFieldMapA': jsonFieldMapA?.toJson(),
      if (jsonFieldListA != null) 'jsonFieldListA': jsonFieldListA?.toJson(),
      if (jsonFieldDateValue != null)
        'jsonFieldDateValue': jsonFieldDateValue?.toJson(),
    };
  }

  static ProjectedUserInclude include() {
    return ProjectedUserInclude.internal_(
      selectedColumns: [
        ProjectedUser.t.id,
        ProjectedUser.t.name,
        ProjectedUser.t.jsonField.jsonKey(
          'text',
          fieldName: 'jsonFieldText',
        ),
        ProjectedUser.t.jsonField.jsonKey(
          'value',
          fieldName: 'jsonFieldValue',
        ),
        ProjectedUser.t.jsonField.jsonKey(
          'mapA',
          fieldName: 'jsonFieldMapA',
        ),
        ProjectedUser.t.jsonField.jsonKey(
          'listA',
          fieldName: 'jsonFieldListA',
        ),
        ProjectedUser.t.jsonField.jsonKey(
          'dateValue',
          fieldName: 'jsonFieldDateValue',
        ),
      ],
    );
  }

  static ProjectedUserIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
  }) {
    return ProjectedUser.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedUserJsonMultiField.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserJsonMultiFieldImpl extends ProjectedUserJsonMultiField {
  _ProjectedUserJsonMultiFieldImpl({
    int? id,
    required String name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  }) : super._(
         id: id,
         name: name,
         jsonFieldText: jsonFieldText,
         jsonFieldValue: jsonFieldValue,
         jsonFieldMapA: jsonFieldMapA,
         jsonFieldListA: jsonFieldListA,
         jsonFieldDateValue: jsonFieldDateValue,
       );

  /// Returns a shallow copy of this [ProjectedUserJsonMultiField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedUserJsonMultiField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? jsonFieldText = _Undefined,
    Object? jsonFieldValue = _Undefined,
    Object? jsonFieldMapA = _Undefined,
    Object? jsonFieldListA = _Undefined,
    Object? jsonFieldDateValue = _Undefined,
  }) {
    return ProjectedUserJsonMultiField(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      jsonFieldText: jsonFieldText is String?
          ? jsonFieldText
          : this.jsonFieldText,
      jsonFieldValue: jsonFieldValue is int?
          ? jsonFieldValue
          : this.jsonFieldValue,
      jsonFieldMapA: jsonFieldMapA is Map<String, int>?
          ? jsonFieldMapA
          : this.jsonFieldMapA?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      jsonFieldListA: jsonFieldListA is List<int>?
          ? jsonFieldListA
          : this.jsonFieldListA?.map((e0) => e0).toList(),
      jsonFieldDateValue: jsonFieldDateValue is DateTime?
          ? jsonFieldDateValue
          : this.jsonFieldDateValue,
    );
  }
}

class ProjectedUserJsonMultiFieldRepository {
  const ProjectedUserJsonMultiFieldRepository._();

  /// Returns a list of [ProjectedUser]s matching the given query parameters.
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
  Future<List<ProjectedUserJsonMultiField>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedUserJsonMultiField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedUserJsonMultiField.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedUser] matching the given query parameters.
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
  Future<ProjectedUserJsonMultiField?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedUser>(
          where: where?.call(ProjectedUser.t),
          orderBy: orderBy?.call(ProjectedUser.t),
          orderByList: orderByList?.call(ProjectedUser.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedUserJsonMultiField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserJsonMultiField.fromJson(e),
        );
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserJsonMultiField?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedUser>(
          id,
          transaction: transaction,
          include: ProjectedUserJsonMultiField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedUserJsonMultiField.fromJson(e),
        );
  }
}
