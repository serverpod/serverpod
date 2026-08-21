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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'projected_enrollment.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ProjectedStudent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProjectedStudent._({
    this.id,
    required this.name,
    this.enrollments,
  });

  factory ProjectedStudent({
    int? id,
    required String name,
    List<_i2.ProjectedEnrollment>? enrollments,
  }) = _ProjectedStudentImpl;

  factory ProjectedStudent.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedStudent(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      enrollments: jsonSerialization['enrollments'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.ProjectedEnrollment>>(
              jsonSerialization['enrollments'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.ProjectedEnrollment>? enrollments;

  /// Returns a shallow copy of this [ProjectedStudent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedStudent copyWith({
    int? id,
    String? name,
    List<_i2.ProjectedEnrollment>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedStudent',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedStudent',
      if (id != null) 'id': id,
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedStudentImpl extends ProjectedStudent {
  _ProjectedStudentImpl({
    int? id,
    required String name,
    List<_i2.ProjectedEnrollment>? enrollments,
  }) : super._(
         id: id,
         name: name,
         enrollments: enrollments,
       );

  /// Returns a shallow copy of this [ProjectedStudent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedStudent copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return ProjectedStudent(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.ProjectedEnrollment>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
