import 'dart:mirrors';

class Table {
}

class TableRow {
  setColumn(String columnName, dynamic value) {
    var instance = reflect(this);
//    var field = instance.getField(Symbol(columnName));

    instance.setField(Symbol(columnName), value);
  }
}
