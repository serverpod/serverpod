/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class Citizen extends _i1.SerializableEntity {
  Citizen({
    this.id,
    required this.name,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  });

  factory Citizen.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Citizen(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      companyId:
          serializationManager.deserialize<int>(jsonSerialization['companyId']),
      company: serializationManager
          .deserialize<_i2.Company?>(jsonSerialization['company']),
      oldCompanyId: serializationManager
          .deserialize<int?>(jsonSerialization['oldCompanyId']),
      oldCompany: serializationManager
          .deserialize<_i2.Company?>(jsonSerialization['oldCompany']),
    );
  }

  int? id;

  String name;

  int companyId;

  _i2.Company? company;

  int? oldCompanyId;

  _i2.Company? oldCompany;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'company': company,
      'oldCompanyId': oldCompanyId,
      'oldCompany': oldCompany,
    };
  }
}
