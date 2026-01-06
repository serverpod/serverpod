/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Employee implements _i1.SerializableModel {
  Employee._({
    this.id,
    required this.name,
    required this.departmentId,
  });

  factory Employee({
    int? id,
    required String name,
    required int departmentId,
  }) = _EmployeeImpl;

  factory Employee.fromJson(Map<String, dynamic> jsonSerialization) {
    return Employee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      departmentId: jsonSerialization['departmentId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int departmentId;

  /// Returns a shallow copy of this [Employee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Employee copyWith({
    int? id,
    String? name,
    int? departmentId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Employee',
      if (id != null) 'id': id,
      'name': name,
      'departmentId': departmentId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmployeeImpl extends Employee {
  _EmployeeImpl({
    int? id,
    required String name,
    required int departmentId,
  }) : super._(
         id: id,
         name: name,
         departmentId: departmentId,
       );

  /// Returns a shallow copy of this [Employee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Employee copyWith({
    Object? id = _Undefined,
    String? name,
    int? departmentId,
  }) {
    return Employee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      departmentId: departmentId ?? this.departmentId,
    );
  }
}
