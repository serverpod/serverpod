import 'package:serverpod_test_client/serverpod_test_client.dart';

class ObjectWithObjectBuilder {
  SimpleData _data;

  List<SimpleData> _dataList;

  List<SimpleData?> _listWithNullableData;

  ObjectWithObjectBuilder()
      : _data = SimpleData(num: 0),
        _dataList = [],
        _listWithNullableData = [];

  ObjectWithObject build() {
    return ObjectWithObject(
      data: _data,
      dataList: _dataList,
      listWithNullableData: _listWithNullableData,
    );
  }

  ObjectWithObjectBuilder withData(SimpleData value) {
    _data = value;

    return this;
  }

  ObjectWithObjectBuilder withDataList(List<SimpleData> value) {
    _dataList = value;

    return this;
  }

  ObjectWithObjectBuilder withListWithNullableData(List<SimpleData?> value) {
    _listWithNullableData = value;

    return this;
  }
}
