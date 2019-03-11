/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/database.dart';
import 'protocol.dart';

class CompanyInfo extends TableRow {
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

class CompanyInfoTable extends Table {

  static const String tableName = 'company_info';
  static const id = Column('id', int);
  static const numEmployees = Column('numEmployees', int);
  static const employee = Column('employee', UserInfo);
  static const name = Column('name', String);
  static const address = Column('address', String);
}
