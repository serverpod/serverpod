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
import '../../changed_id_type/one_to_one/address.dart' as _ih0efjtk;
import '../../changed_id_type/one_to_one/company.dart' as _i441ok8u;

abstract class CitizenInt
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CitizenInt._({
    this.id,
    required this.name,
    this.address,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  });

  factory CitizenInt({
    int? id,
    required String name,
    _ih0efjtk.AddressUuid? address,
    required _isc.UuidValue companyId,
    _i441ok8u.CompanyUuid? company,
    _isc.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  }) = _CitizenIntImpl;

  factory CitizenInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ih0efjtk.AddressUuid>(
              jsonSerialization['address'],
            ),
      companyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['companyId'],
      ),
      company: jsonSerialization['company'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i441ok8u.CompanyUuid>(
              jsonSerialization['company'],
            ),
      oldCompanyId: jsonSerialization['oldCompanyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['oldCompanyId'],
            ),
      oldCompany: jsonSerialization['oldCompany'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_i441ok8u.CompanyUuid>(
              jsonSerialization['oldCompany'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _ih0efjtk.AddressUuid? address;

  _isc.UuidValue companyId;

  _i441ok8u.CompanyUuid? company;

  _isc.UuidValue? oldCompanyId;

  _i441ok8u.CompanyUuid? oldCompany;

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CitizenInt copyWith({
    int? id,
    String? name,
    _ih0efjtk.AddressUuid? address,
    _isc.UuidValue? companyId,
    _i441ok8u.CompanyUuid? company,
    _isc.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenInt',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJson(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenInt',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJsonForProtocol(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenIntImpl extends CitizenInt {
  _CitizenIntImpl({
    int? id,
    required String name,
    _ih0efjtk.AddressUuid? address,
    required _isc.UuidValue companyId,
    _i441ok8u.CompanyUuid? company,
    _isc.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  }) : super._(
         id: id,
         name: name,
         address: address,
         companyId: companyId,
         company: company,
         oldCompanyId: oldCompanyId,
         oldCompany: oldCompany,
       );

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CitizenInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
    _isc.UuidValue? companyId,
    Object? company = _Undefined,
    Object? oldCompanyId = _Undefined,
    Object? oldCompany = _Undefined,
  }) {
    return CitizenInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _ih0efjtk.AddressUuid?
          ? address
          : this.address?.copyWith(),
      companyId: companyId ?? this.companyId,
      company: company is _i441ok8u.CompanyUuid?
          ? company
          : this.company?.copyWith(),
      oldCompanyId: oldCompanyId is _isc.UuidValue?
          ? oldCompanyId
          : this.oldCompanyId,
      oldCompany: oldCompany is _i441ok8u.CompanyUuid?
          ? oldCompany
          : this.oldCompany?.copyWith(),
    );
  }
}
