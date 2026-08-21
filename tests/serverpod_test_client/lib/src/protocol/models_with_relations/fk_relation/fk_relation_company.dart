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
import '../../models_with_relations/fk_relation/fk_relation_office.dart' as _i2;
import '../../models_with_relations/fk_relation/fk_relation_employee.dart'
    as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class FkRelationCompany
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FkRelationCompany._({
    this.id,
    required this.name,
    this.office,
    this.employees,
  });

  factory FkRelationCompany({
    int? id,
    required String name,
    _i2.FkRelationOffice? office,
    List<_i3.FkRelationEmployee>? employees,
  }) = _FkRelationCompanyImpl;

  factory FkRelationCompany.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationCompany(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      office: jsonSerialization['office'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.FkRelationOffice>(
              jsonSerialization['office'],
            ),
      employees: jsonSerialization['employees'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.FkRelationEmployee>>(
              jsonSerialization['employees'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _i2.FkRelationOffice? office;

  List<_i3.FkRelationEmployee>? employees;

  /// Returns a shallow copy of this [FkRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FkRelationCompany copyWith({
    int? id,
    String? name,
    _i2.FkRelationOffice? office,
    List<_i3.FkRelationEmployee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationCompany',
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
      '__className__': 'FkRelationCompany',
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

class _FkRelationCompanyImpl extends FkRelationCompany {
  _FkRelationCompanyImpl({
    int? id,
    required String name,
    _i2.FkRelationOffice? office,
    List<_i3.FkRelationEmployee>? employees,
  }) : super._(
         id: id,
         name: name,
         office: office,
         employees: employees,
       );

  /// Returns a shallow copy of this [FkRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FkRelationCompany copyWith({
    Object? id = _Undefined,
    String? name,
    Object? office = _Undefined,
    Object? employees = _Undefined,
  }) {
    return FkRelationCompany(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      office: office is _i2.FkRelationOffice?
          ? office
          : this.office?.copyWith(),
      employees: employees is List<_i3.FkRelationEmployee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
