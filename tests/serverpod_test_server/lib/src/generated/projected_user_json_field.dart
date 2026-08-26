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
import 'projected_user.dart';

abstract class ProjectedUserJsonField
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedUserJsonField._({
    this.id,
    required this.name,
    this.jsonFieldText,
  });

  factory ProjectedUserJsonField({
    _is.UuidValue? id,
    required String name,
    String? jsonFieldText,
  }) = _ProjectedUserJsonFieldImpl;

  factory ProjectedUserJsonField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserJsonField(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      jsonFieldText:
          (jsonSerialization['jsonFieldText'] ??
                  (jsonSerialization['jsonField'] as Map?)?['text'])
              as String?,
    );
  }

  static const db = ProjectedUserJsonFieldRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _is.UuidValue? id;

  String name;

  String? jsonFieldText;

  /// Returns a shallow copy of this [ProjectedUserJsonField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedUserJsonField copyWith({
    _is.UuidValue? id,
    String? name,
    String? jsonFieldText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserJsonField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserJsonField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
    };
  }

  static ProjectedUserJsonInclude include() {
    return ProjectedUser.includeJson(
      select: (t) => [
        ProjectedUser.t.id,
        ProjectedUser.t.name,
        ProjectedUser.t.jsonField.jsonKey(
          'text',
          fieldName: 'jsonFieldText',
        ),
      ],
    );
  }

  static ProjectedUserJsonIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedUserTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedUserTable>? orderBy,
    _is.OrderByListBuilder<ProjectedUserTable>? orderByList,
  }) {
    return ProjectedUser.includeJsonList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedUserJsonField.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserJsonFieldImpl extends ProjectedUserJsonField {
  _ProjectedUserJsonFieldImpl({
    _is.UuidValue? id,
    required String name,
    String? jsonFieldText,
  }) : super._(
         id: id,
         name: name,
         jsonFieldText: jsonFieldText,
       );

  /// Returns a shallow copy of this [ProjectedUserJsonField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedUserJsonField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? jsonFieldText = _Undefined,
  }) {
    return ProjectedUserJsonField(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      jsonFieldText: jsonFieldText is String?
          ? jsonFieldText
          : this.jsonFieldText,
    );
  }
}

class ProjectedUserJsonFieldRepository {
  const ProjectedUserJsonFieldRepository._();

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
  Future<List<ProjectedUserJsonField>> find(
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
          include: ProjectedUserJsonField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedUserJsonField.fromJson(e)).toList(),
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
  Future<ProjectedUserJsonField?> findFirstRow(
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
          include: ProjectedUserJsonField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserJsonField.fromJson(e));
  }

  /// Finds a single [ProjectedUser] by its [id] or null if no such row exists.
  Future<ProjectedUserJsonField?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedUser>(
          id,
          transaction: transaction,
          include: ProjectedUserJsonField.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedUserJsonField.fromJson(e));
  }
}
