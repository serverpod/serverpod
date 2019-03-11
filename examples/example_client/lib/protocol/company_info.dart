/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class CompanyInfo extends SerializableEntity {
  String get className => 'CompanyInfo';

  int id;
  int numEmployees;
  List<UserInfo> employee;
  String name;
  String address;

  CompanyInfo({
    this.id,
    this.numEmployees,
    this.employee,
    this.name,
    this.address,
});

  CompanyInfo.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    numEmployees = data['numEmployees'];
    employee = data['employee'].map<UserInfo>((a) => UserInfo.fromSerialization(a)).toList();
    name = data['name'];
    address = data['address'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numEmployees': numEmployees,
      'employee': employee.map((UserInfo a) => a.serialize()).toList(),
      'name': name,
      'address': address,
    });
  }
}

