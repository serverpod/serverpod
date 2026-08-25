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
import 'projected_enrollment_course.dart' as _ika7thts;
import 'projected_student.dart';

abstract class ProjectedStudentCourses
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedStudentCourses._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory ProjectedStudentCourses({
    int? id,
    required String name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  }) = _ProjectedStudentCoursesImpl;

  factory ProjectedStudentCourses.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedStudentCourses(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_ika7thts.ProjectedEnrollmentCourse>>(
                  jsonSerialization['enrollments'],
                ),
    );
  }

  static const db = ProjectedStudentCoursesRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_ika7thts.ProjectedEnrollmentCourse>? enrollments;

  /// Returns a shallow copy of this [ProjectedStudentCourses]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedStudentCourses copyWith({
    int? id,
    String? name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedStudentCourses',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedStudentCourses',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) =>
              // ignore: unnecessary_type_check
              v is _is.ProtocolSerialization
              ? (v as _is.ProtocolSerialization).toJsonForProtocol()
              :
                // ignore: dead_code
                v.toJson(),
        ),
    };
  }

  static ProjectedStudentInclude include() {
    return ProjectedStudent.include(
      select: (t) => [
        ProjectedStudent.t.id,
        ProjectedStudent.t.name,
      ],
      enrollments: _ika7thts.ProjectedEnrollmentCourse.includeList(),
    );
  }

  static ProjectedStudentIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedStudentTable>? orderByList,
  }) {
    return ProjectedStudent.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedStudentCourses.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedStudentCoursesImpl extends ProjectedStudentCourses {
  _ProjectedStudentCoursesImpl({
    int? id,
    required String name,
    List<_ika7thts.ProjectedEnrollmentCourse>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [ProjectedStudentCourses]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedStudentCourses copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return ProjectedStudentCourses(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_ika7thts.ProjectedEnrollmentCourse>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class ProjectedStudentCoursesRepository {
  const ProjectedStudentCoursesRepository._();

  /// Returns a list of [ProjectedStudent]s matching the given query parameters.
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
  Future<List<ProjectedStudentCourses>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedStudent>(
          where: where?.call(ProjectedStudent.t),
          orderBy: orderBy?.call(ProjectedStudent.t),
          orderByList: orderByList?.call(ProjectedStudent.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedStudentCourses.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedStudentCourses.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedStudent] matching the given query parameters.
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
  Future<ProjectedStudentCourses?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedStudentTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedStudentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedStudentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedStudent>(
          where: where?.call(ProjectedStudent.t),
          orderBy: orderBy?.call(ProjectedStudent.t),
          orderByList: orderByList?.call(ProjectedStudent.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedStudentCourses.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedStudentCourses.fromJson(e));
  }

  /// Finds a single [ProjectedStudent] by its [id] or null if no such row exists.
  Future<ProjectedStudentCourses?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedStudent>(
          id,
          transaction: transaction,
          include: ProjectedStudentCourses.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedStudentCourses.fromJson(e));
  }
}
