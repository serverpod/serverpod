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
import '../../../explicit_column_name/relations/one_to_many/employee.dart'
    as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class Department implements _i1.SerializableModel {
  Department._({
    this.id,
    required this.name,
    this.employees,
  });

  factory Department({
    int? id,
    required String name,
    List<_i2.Employee>? employees,
  }) = _DepartmentImpl;

  factory Department.fromJson(Map<String, dynamic> jsonSerialization) {
    return Department(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      employees: jsonSerialization['employees'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Employee>>(
              jsonSerialization['employees'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.Employee>? employees;

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Department copyWith({
    int? id,
    String? name,
    List<_i2.Employee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Department',
      if (id != null) 'id': id,
      'name': name,
      if (employees != null)
        'employees': employees?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepartmentImpl extends Department {
  _DepartmentImpl({
    int? id,
    required String name,
    List<_i2.Employee>? employees,
  }) : super._(
         id: id,
         name: name,
         employees: employees,
       );

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Department copyWith({
    Object? id = _Undefined,
    String? name,
    Object? employees = _Undefined,
  }) {
    return Department(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      employees: employees is List<_i2.Employee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
