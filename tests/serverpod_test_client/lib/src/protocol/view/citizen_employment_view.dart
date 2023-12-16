/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class CitizenEmploymentView extends _i1.SerializableEntity {
  CitizenEmploymentView._({
    required this.citizenId,
    required this.name,
    required this.homeAddress,
    required this.currentCompany,
    required this.companyLocation,
  });

  factory CitizenEmploymentView({
    required int citizenId,
    required String name,
    required String homeAddress,
    required String currentCompany,
    required String companyLocation,
  }) = _CitizenEmploymentViewImpl;

  factory CitizenEmploymentView.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CitizenEmploymentView(
      citizenId:
          serializationManager.deserialize<int>(jsonSerialization['citizenId']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      homeAddress: serializationManager
          .deserialize<String>(jsonSerialization['homeAddress']),
      currentCompany: serializationManager
          .deserialize<String>(jsonSerialization['currentCompany']),
      companyLocation: serializationManager
          .deserialize<String>(jsonSerialization['companyLocation']),
    );
  }

  int citizenId;

  String name;

  String homeAddress;

  String currentCompany;

  String companyLocation;

  CitizenEmploymentView copyWith({
    int? citizenId,
    String? name,
    String? homeAddress,
    String? currentCompany,
    String? companyLocation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'citizenId': citizenId,
      'name': name,
      'homeAddress': homeAddress,
      'currentCompany': currentCompany,
      'companyLocation': companyLocation,
    };
  }
}

class _CitizenEmploymentViewImpl extends CitizenEmploymentView {
  _CitizenEmploymentViewImpl({
    required int citizenId,
    required String name,
    required String homeAddress,
    required String currentCompany,
    required String companyLocation,
  }) : super._(
          citizenId: citizenId,
          name: name,
          homeAddress: homeAddress,
          currentCompany: currentCompany,
          companyLocation: companyLocation,
        );

  @override
  CitizenEmploymentView copyWith({
    int? citizenId,
    String? name,
    String? homeAddress,
    String? currentCompany,
    String? companyLocation,
  }) {
    return CitizenEmploymentView(
      citizenId: citizenId ?? this.citizenId,
      name: name ?? this.name,
      homeAddress: homeAddress ?? this.homeAddress,
      currentCompany: currentCompany ?? this.currentCompany,
      companyLocation: companyLocation ?? this.companyLocation,
    );
  }
}
