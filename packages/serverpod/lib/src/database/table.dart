import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

class Table {
}

abstract class TableRow extends SerializableEntity {
  String get tableName;

  setColumn(String columnName, dynamic value) {
    var instance = reflect(this);
    instance.setField(Symbol(columnName), value);
  }
}
