/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class CompanyInfo extends SerializableEntity {
  String get className => 'CompanyInfo';

  int id;
  int numEmployees;
  double value;
  String name;
  DateTime createdTime;
  List<UserInfo> employee;
  bool hasOffice;
  String address;

  CompanyInfo({
    this.id,
    this.numEmployees,
    this.value,
    this.name,
    this.createdTime,
    this.employee,
    this.hasOffice,
    this.address,
});

  CompanyInfo.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    numEmployees = data['numEmployees'];
    value = data['value'];
    name = data['name'];
    createdTime = data['createdTime'] != null ? DateTime.tryParse(data['createdTime']) : null;
    employee = data['employee'].map<UserInfo>((a) => UserInfo.fromSerialization(a)).toList();
    hasOffice = data['hasOffice'];
    address = data['address'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numEmployees': numEmployees,
      'value': value,
      'name': name,
      'createdTime': createdTime?.toUtc()?.toIso8601String(),
      'employee': employee.map((UserInfo a) => a.serialize()).toList(),
      'hasOffice': hasOffice,
      'address': address,
    });
  }
}

