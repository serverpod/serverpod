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
import '../../models_with_relations/generated_relation_field/generated_relation_company.dart'
    as _ipeijyfj;

abstract class GeneratedRelationEmployee
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  GeneratedRelationEmployee._({
    this.id,
    required this.name,
    required this.customCompanyId,
    this.company,
    this.customPreviousCompanyId,
    this.previousCompany,
  });

  factory GeneratedRelationEmployee({
    int? id,
    required String name,
    required int customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  }) = _GeneratedRelationEmployeeImpl;

  factory GeneratedRelationEmployee.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      customCompanyId: jsonSerialization['customCompanyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<_ipeijyfj.GeneratedRelationCompany>(
                  jsonSerialization['company'],
                ),
      customPreviousCompanyId:
          jsonSerialization['customPreviousCompanyId'] as int?,
      previousCompany: jsonSerialization['previousCompany'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<_ipeijyfj.GeneratedRelationCompany>(
                  jsonSerialization['previousCompany'],
                ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  /// The foreign key of the [company] relation.
  int customCompanyId;

  _ipeijyfj.GeneratedRelationCompany? company;

  /// The foreign key of the [previousCompany] relation.
  int? customPreviousCompanyId;

  _ipeijyfj.GeneratedRelationCompany? previousCompany;

  /// Returns a shallow copy of this [GeneratedRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GeneratedRelationEmployee copyWith({
    int? id,
    String? name,
    int? customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJson(),
      if (customPreviousCompanyId != null)
        'customPreviousCompanyId': customPreviousCompanyId,
      if (previousCompany != null) 'previousCompany': previousCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (customPreviousCompanyId != null)
        'customPreviousCompanyId': customPreviousCompanyId,
      if (previousCompany != null)
        'previousCompany': previousCompany?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedRelationEmployeeImpl extends GeneratedRelationEmployee {
  _GeneratedRelationEmployeeImpl({
    int? id,
    required String name,
    required int customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  }) : super._(
         id: id,
         name: name,
         customCompanyId: customCompanyId,
         company: company,
         customPreviousCompanyId: customPreviousCompanyId,
         previousCompany: previousCompany,
       );

  /// Returns a shallow copy of this [GeneratedRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  GeneratedRelationEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    int? customCompanyId,
    Object? company = _Undefined,
    Object? customPreviousCompanyId = _Undefined,
    Object? previousCompany = _Undefined,
  }) {
    return GeneratedRelationEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      customCompanyId: customCompanyId ?? this.customCompanyId,
      company: company is _ipeijyfj.GeneratedRelationCompany?
          ? company
          : this.company?.copyWith(),
      customPreviousCompanyId: customPreviousCompanyId is int?
          ? customPreviousCompanyId
          : this.customPreviousCompanyId,
      previousCompany: previousCompany is _ipeijyfj.GeneratedRelationCompany?
          ? previousCompany
          : this.previousCompany?.copyWith(),
    );
  }
}
