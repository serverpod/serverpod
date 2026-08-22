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
import '../../changed_id_type/many_to_many/course.dart' as _irfj8gqh;
import '../../changed_id_type/many_to_many/student.dart' as _iu6t4rw4;

abstract class EnrollmentInt
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EnrollmentInt._({
    this.id,
    required this.studentId,
    this.student,
    required this.courseId,
    this.course,
  });

  factory EnrollmentInt({
    int? id,
    required _isc.UuidValue studentId,
    _iu6t4rw4.StudentUuid? student,
    required _isc.UuidValue courseId,
    _irfj8gqh.CourseUuid? course,
  }) = _EnrollmentIntImpl;

  factory EnrollmentInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnrollmentInt(
      id: jsonSerialization['id'] as int?,
      studentId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['studentId'],
      ),
      student: jsonSerialization['student'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iu6t4rw4.StudentUuid>(
              jsonSerialization['student'],
            ),
      courseId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['courseId'],
      ),
      course: jsonSerialization['course'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_irfj8gqh.CourseUuid>(
              jsonSerialization['course'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue studentId;

  _iu6t4rw4.StudentUuid? student;

  _isc.UuidValue courseId;

  _irfj8gqh.CourseUuid? course;

  /// Returns a shallow copy of this [EnrollmentInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EnrollmentInt copyWith({
    int? id,
    _isc.UuidValue? studentId,
    _iu6t4rw4.StudentUuid? student,
    _isc.UuidValue? courseId,
    _irfj8gqh.CourseUuid? course,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnrollmentInt',
      if (id != null) 'id': id,
      'studentId': studentId.toJson(),
      if (student != null) 'student': student?.toJson(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnrollmentInt',
      if (id != null) 'id': id,
      'studentId': studentId.toJson(),
      if (student != null) 'student': student?.toJsonForProtocol(),
      'courseId': courseId.toJson(),
      if (course != null) 'course': course?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnrollmentIntImpl extends EnrollmentInt {
  _EnrollmentIntImpl({
    int? id,
    required _isc.UuidValue studentId,
    _iu6t4rw4.StudentUuid? student,
    required _isc.UuidValue courseId,
    _irfj8gqh.CourseUuid? course,
  }) : super._(
         id: id,
         studentId: studentId,
         student: student,
         courseId: courseId,
         course: course,
       );

  /// Returns a shallow copy of this [EnrollmentInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EnrollmentInt copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? studentId,
    Object? student = _Undefined,
    _isc.UuidValue? courseId,
    Object? course = _Undefined,
  }) {
    return EnrollmentInt(
      id: id is int? ? id : this.id,
      studentId: studentId ?? this.studentId,
      student: student is _iu6t4rw4.StudentUuid?
          ? student
          : this.student?.copyWith(),
      courseId: courseId ?? this.courseId,
      course: course is _irfj8gqh.CourseUuid?
          ? course
          : this.course?.copyWith(),
    );
  }
}
