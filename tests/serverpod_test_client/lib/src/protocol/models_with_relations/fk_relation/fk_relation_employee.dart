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
import '../../models_with_relations/fk_relation/fk_relation_company.dart'
    as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class FkRelationEmployee
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FkRelationEmployee._({
    this.id,
    required this.name,
    required this.companyId,
    this.company,
    this.previousCompanyId,
    this.previousCompany,
  });

  factory FkRelationEmployee({
    int? id,
    required String name,
    required int companyId,
    _i2.FkRelationCompany? company,
    int? previousCompanyId,
    _i2.FkRelationCompany? previousCompany,
  }) = _FkRelationEmployeeImpl;

  factory FkRelationEmployee.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.FkRelationCompany>(
              jsonSerialization['company'],
            ),
      previousCompanyId: jsonSerialization['previousCompanyId'] as int?,
      previousCompany: jsonSerialization['previousCompany'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.FkRelationCompany>(
              jsonSerialization['previousCompany'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int companyId;

  _i2.FkRelationCompany? company;

  int? previousCompanyId;

  _i2.FkRelationCompany? previousCompany;

  /// Returns a shallow copy of this [FkRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FkRelationEmployee copyWith({
    int? id,
    String? name,
    int? companyId,
    _i2.FkRelationCompany? company,
    int? previousCompanyId,
    _i2.FkRelationCompany? previousCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
      if (previousCompanyId != null) 'previousCompanyId': previousCompanyId,
      if (previousCompany != null) 'previousCompany': previousCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FkRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (previousCompanyId != null) 'previousCompanyId': previousCompanyId,
      if (previousCompany != null)
        'previousCompany': previousCompany?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationEmployeeImpl extends FkRelationEmployee {
  _FkRelationEmployeeImpl({
    int? id,
    required String name,
    required int companyId,
    _i2.FkRelationCompany? company,
    int? previousCompanyId,
    _i2.FkRelationCompany? previousCompany,
  }) : super._(
         id: id,
         name: name,
         companyId: companyId,
         company: company,
         previousCompanyId: previousCompanyId,
         previousCompany: previousCompany,
       );

  /// Returns a shallow copy of this [FkRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FkRelationEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    int? companyId,
    Object? company = _Undefined,
    Object? previousCompanyId = _Undefined,
    Object? previousCompany = _Undefined,
  }) {
    return FkRelationEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      company: company is _i2.FkRelationCompany?
          ? company
          : this.company?.copyWith(),
      previousCompanyId: previousCompanyId is int?
          ? previousCompanyId
          : this.previousCompanyId,
      previousCompany: previousCompany is _i2.FkRelationCompany?
          ? previousCompany
          : this.previousCompany?.copyWith(),
    );
  }
}
