/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class CompanyInfo extends SerializableEntity {
  String get className => 'CompanyInfo';

  int id;
  String name;
  int numEmployees;
  String address;
  List<UserInfo> employee;
  double value;
  DateTime createdTime;
  bool hasOffice;

  CompanyInfo({
    this.id,
    this.name,
    this.numEmployees,
    this.address,
    this.employee,
    this.value,
    this.createdTime,
    this.hasOffice,
});

  CompanyInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    numEmployees = _data['numEmployees'];
    address = _data['address'];
    employee = _data['employee']?.map<UserInfo>((a) => UserInfo.fromSerialization(a))?.toList();
    value = _data['value'];
    createdTime = _data['createdTime'] != null ? DateTime.tryParse(_data['createdTime']) : null;
    hasOffice = _data['hasOffice'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'numEmployees': numEmployees,
      'address': address,
      'employee': employee?.map((UserInfo a) => a.serialize())?.toList(),
      'value': value,
      'createdTime': createdTime?.toUtc()?.toIso8601String(),
      'hasOffice': hasOffice,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'numEmployees': numEmployees,
      'address': address,
      'employee': employee?.map((UserInfo a) => a.serialize())?.toList(),
      'value': value,
      'createdTime': createdTime?.toUtc()?.toIso8601String(),
      'hasOffice': hasOffice,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'numEmployees': numEmployees,
      'address': address,
      'employee': employee?.map((UserInfo a) => a.serialize())?.toList(),
      'value': value,
      'createdTime': createdTime?.toUtc()?.toIso8601String(),
      'hasOffice': hasOffice,
    });
  }
}

