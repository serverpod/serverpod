/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../changed_id_type/many_to_many/enrollment.dart' as _i2;

abstract class CourseUuid implements _i1.SerializableModel {
  CourseUuid._({
    _i1.UuidValue? id,
    required this.name,
    this.enrollments,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory CourseUuid({
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) = _CourseUuidImpl;

  factory CourseUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return CourseUuid(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      enrollments: (jsonSerialization['enrollments'] as List?)
          ?.map((e) => _i2.EnrollmentInt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String name;

  List<_i2.EnrollmentInt>? enrollments;

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CourseUuid copyWith({
    _i1.UuidValue? id,
    String? name,
    List<_i2.EnrollmentInt>? enrollments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (enrollments != null)
        'enrollments': enrollments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CourseUuidImpl extends CourseUuid {
  _CourseUuidImpl({
    _i1.UuidValue? id,
    required String name,
    List<_i2.EnrollmentInt>? enrollments,
  }) : super._(
          id: id,
          name: name,
          enrollments: enrollments,
        );

  /// Returns a shallow copy of this [CourseUuid]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CourseUuid copyWith({
    Object? id = _Undefined,
    String? name,
    Object? enrollments = _Undefined,
  }) {
    return CourseUuid(
      id: id is _i1.UuidValue? ? id : this.id,
      name: name ?? this.name,
      enrollments: enrollments is List<_i2.EnrollmentInt>?
          ? enrollments
          : this.enrollments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
