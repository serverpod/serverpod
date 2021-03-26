import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class TableRow extends SerializableEntity {
  int? id;
  String get tableName;

  Map<String, dynamic> serializeForDatabase();

  setColumn(String columnName, dynamic value) {
    var instance = reflect(this);
    instance.setField(Symbol(columnName), value);
  }
}
