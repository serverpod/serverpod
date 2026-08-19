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
import '../../models_with_relations/generated_relation_field/generated_relation_office.dart'
    as _i2;
import '../../models_with_relations/generated_relation_field/generated_relation_employee.dart'
    as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class GeneratedRelationCompany
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  GeneratedRelationCompany._({
    this.id,
    required this.name,
    this.office,
    this.employees,
  });

  factory GeneratedRelationCompany({
    int? id,
    required String name,
    _i2.GeneratedRelationOffice? office,
    List<_i3.GeneratedRelationEmployee>? employees,
  }) = _GeneratedRelationCompanyImpl;

  factory GeneratedRelationCompany.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationCompany(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      office: jsonSerialization['office'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.GeneratedRelationOffice>(
              jsonSerialization['office'],
            ),
      employees: jsonSerialization['employees'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.GeneratedRelationEmployee>>(
              jsonSerialization['employees'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i2.GeneratedRelationOffice? office;

  List<_i3.GeneratedRelationEmployee>? employees;

  /// Returns a shallow copy of this [GeneratedRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GeneratedRelationCompany copyWith({
    int? id,
    String? name,
    _i2.GeneratedRelationOffice? office,
    List<_i3.GeneratedRelationEmployee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationCompany',
      if (id != null) 'id': id,
      'name': name,
      if (office != null) 'office': office?.toJson(),
      if (employees != null)
        'employees': employees?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedRelationCompany',
      if (id != null) 'id': id,
      'name': name,
      if (office != null) 'office': office?.toJsonForProtocol(),
      if (employees != null)
        'employees': employees?.toJson(
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

class _GeneratedRelationCompanyImpl extends GeneratedRelationCompany {
  _GeneratedRelationCompanyImpl({
    int? id,
    required String name,
    _i2.GeneratedRelationOffice? office,
    List<_i3.GeneratedRelationEmployee>? employees,
  }) : super._(
         id: id,
         name: name,
         office: office,
         employees: employees,
       );

  /// Returns a shallow copy of this [GeneratedRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GeneratedRelationCompany copyWith({
    Object? id = _Undefined,
    String? name,
    Object? office = _Undefined,
    Object? employees = _Undefined,
  }) {
    return GeneratedRelationCompany(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      office: office is _i2.GeneratedRelationOffice?
          ? office
          : this.office?.copyWith(),
      employees: employees is List<_i3.GeneratedRelationEmployee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
