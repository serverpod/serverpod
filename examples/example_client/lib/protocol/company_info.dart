/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class CompanyInfo extends SerializableEntity {
  static const String db = 'company_info';
  String get className => 'CompanyInfo';
  String get tableName => 'company_info';

  int id;
  int numEmployees;
  UserInfo employee;
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
    employee = UserInfo.fromSerialization(data['employee']);
    name = data['name'];
    address = data['address'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numEmployees': numEmployees,
      'employee': employee.serialize(),
      'name': name,
      'address': address,
    });
  }
}

