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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'projected_course.dart' as _iotqocf1;
import 'projected_student.dart' as _iprfievr;

abstract class ProjectedEnrollment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedEnrollment._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory ProjectedEnrollment({
    int? id,
    required int studentId,
    _iprfievr.ProjectedStudent? student,
    required int courseId,
    _iotqocf1.ProjectedCourse? course,
  }) = _ProjectedEnrollmentImpl;

  factory ProjectedEnrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedEnrollment(
      id: jsonSerialization['id'] as int?,
      studentId: jsonSerialization['studentId'] as int,
      student: jsonSerialization['student'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iprfievr.ProjectedStudent>(
              jsonSerialization['student'],
            ),
      courseId: jsonSerialization['courseId'] as int,
      course: jsonSerialization['course'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iotqocf1.ProjectedCourse>(
              jsonSerialization['course'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int studentId;

  _iprfievr.ProjectedStudent? student;

  int courseId;

  _iotqocf1.ProjectedCourse? course;

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedEnrollment copyWith({
    int? id,
    int? studentId,
    _iprfievr.ProjectedStudent? student,
    int? courseId,
    _iotqocf1.ProjectedCourse? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedEnrollment',
      if (id != null) 'id': id,
      'studentId': studentId,
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId,
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedEnrollmentImpl extends ProjectedEnrollment {
  _ProjectedEnrollmentImpl({
    int? id,
    required int studentId,
    _iprfievr.ProjectedStudent? student,
    required int courseId,
    _iotqocf1.ProjectedCourse? course,
  }) : super._(
         id: id,
         studentId: studentId,
         student: student,
         courseId: courseId,
         course: course,
       );

  /// Returns a shallow copy of this [ProjectedEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedEnrollment copyWith({
    Object? id = _Undefined,
    int? studentId,
    Object? student = _Undefined,
    int? courseId,
    Object? course = _Undefined,
  }) {
    return ProjectedEnrollment(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _iprfievr.ProjectedStudent?
          ? student
          : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _iotqocf1.ProjectedCourse?
          ? course
          : this.course?.copyWith(),
    );
  }
}
