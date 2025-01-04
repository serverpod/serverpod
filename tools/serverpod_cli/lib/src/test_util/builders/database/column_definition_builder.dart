import 'package:serverpod_service_client/serverpod_service_client.dart';

class ColumnDefinitionBuilder {
  String _name;
  ColumnType _columnType;
  bool _isNullable;
  String? _columnDefault;
  String? _dartType;

  ColumnDefinitionBuilder()
      : _name = 'name',
        _columnType = ColumnType.text,
        _isNullable = false,
        _columnDefault = null,
        _dartType = 'String';

  ColumnDefinition build() {
    return ColumnDefinition(
      name: _name,
      columnType: _columnType,
      isNullable: _isNullable,
      columnDefault: _columnDefault,
      dartType: _dartType,
    );
  }

  ColumnDefinitionBuilder withIdColumn({String type = 'int'}) {
    _name = 'id';
    _isNullable = false;
    if (type == 'int') {
      _columnType = ColumnType.integer;
      _columnDefault = "nextval('test_id_seq'::regclass)";
      _dartType = 'int';
    } else if ((type == 'uuid') || (type == 'UuidValue')) {
      _columnType = ColumnType.uuid;
      _columnDefault = 'gen_random_uuid()';
      _dartType = 'UuidValue';
    }
    return this;
  }

  ColumnDefinitionBuilder withNameColumn() {
    _name = 'name';
    _columnType = ColumnType.text;
    _isNullable = false;
    _columnDefault = null;
    _dartType = 'String';
    return this;
  }

  ColumnDefinitionBuilder withName(String name) {
    _name = name;
    return this;
  }

  ColumnDefinitionBuilder withColumnType(ColumnType columnType) {
    _columnType = columnType;
    return this;
  }

  ColumnDefinitionBuilder withIsNullable(bool isNullable) {
    _isNullable = isNullable;
    return this;
  }

  ColumnDefinitionBuilder withColumnDefault(String? columnDefault) {
    _columnDefault = columnDefault;
    return this;
  }

  ColumnDefinitionBuilder withDartType(String? dartType) {
    _dartType = dartType;
    return this;
  }
}
