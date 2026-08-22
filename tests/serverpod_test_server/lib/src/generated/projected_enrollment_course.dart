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
import 'projected_course_name.dart' as _icve44wq;
import 'projected_enrollment.dart';

abstract class ProjectedEnrollmentCourse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedEnrollmentCourse._({
    this.id,
    this.course,
  });

  factory ProjectedEnrollmentCourse({
    int? id,
    _icve44wq.ProjectedCourseName? course,
  }) = _ProjectedEnrollmentCourseImpl;

  factory ProjectedEnrollmentCourse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedEnrollmentCourse(
      id: jsonSerialization['id'] as int?,
      course: jsonSerialization['course'] == null
          ? null
          : _icve44wq.ProjectedCourseName.fromJson(jsonSerialization['course']),
    );
  }

  static const db = ProjectedEnrollmentCourseRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _icve44wq.ProjectedCourseName? course;

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedEnrollmentCourse copyWith({
    int? id,
    _icve44wq.ProjectedCourseName? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedEnrollmentCourse',
      if (id != null) 'id': id,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedEnrollmentCourse',
      if (id != null) 'id': id,
      if (course != null)
        'course':
            // ignore: unnecessary_type_check
            course is _is.ProtocolSerialization
            ? (course as _is.ProtocolSerialization).toJsonForProtocol()
            :
              // ignore: dead_code
              course?.toJson(),
    };
  }

  static ProjectedEnrollmentInclude include() {
    return ProjectedEnrollmentInclude.internal_(
      selectedColumns: [ProjectedEnrollment.t.id],
      course: _icve44wq.ProjectedCourseName.include(),
    );
  }

  static ProjectedEnrollmentIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
  }) {
    return ProjectedEnrollment.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedEnrollmentCourse.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentCourseImpl extends ProjectedEnrollmentCourse {
  _ProjectedEnrollmentCourseImpl({
    int? id,
    _icve44wq.ProjectedCourseName? course,
  }) : super._(
         id: id,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollmentCourse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedEnrollmentCourse copyWith({
    Object? id = _Undefined,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollmentCourse(
      id: id is int? ? id : this.id,
      course: course is _icve44wq.ProjectedCourseName?
          ? course
          : this.course?.copyWith(),
    );
  }
}

class ProjectedEnrollmentCourseRepository {
  const ProjectedEnrollmentCourseRepository._();

  /// Returns a list of [ProjectedEnrollment]s matching the given query parameters.
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
  Future<List<ProjectedEnrollmentCourse>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedEnrollment>(
          where: where?.call(ProjectedEnrollment.t),
          orderBy: orderBy?.call(ProjectedEnrollment.t),
          orderByList: orderByList?.call(ProjectedEnrollment.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) =>
              rows.map((e) => ProjectedEnrollmentCourse.fromJson(e)).toList(),
        );
  }

  /// Returns the first matching [ProjectedEnrollment] matching the given query parameters.
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
  Future<ProjectedEnrollmentCourse?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedEnrollmentTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedEnrollmentTable>? orderBy,
    _is.OrderByListBuilder<ProjectedEnrollmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedEnrollment>(
          where: where?.call(ProjectedEnrollment.t),
          orderBy: orderBy?.call(ProjectedEnrollment.t),
          orderByList: orderByList?.call(ProjectedEnrollment.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedEnrollmentCourse.fromJson(e));
  }

  /// Finds a single [ProjectedEnrollment] by its [id] or null if no such row exists.
  Future<ProjectedEnrollmentCourse?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedEnrollment>(
          id,
          transaction: transaction,
          include: ProjectedEnrollmentCourse.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then((e) => e == null ? null : ProjectedEnrollmentCourse.fromJson(e));
  }
}
