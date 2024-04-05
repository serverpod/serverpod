import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  test('Given json data when encoded to string then output is stringified json',
      () {
    var jsonData = {'a': 1, 'b': 2};

    var stringifiedJson = SerializationManager.encode(jsonData);
    expect(stringifiedJson, '{"a":1,"b":2}');
  });

  test(
      'Given json data when encoded to formatted string then output is formatted stringified json',
      () {
    var jsonData = {'a': 1, 'b': 2};

    var stringifiedJson = SerializationManager.encode(
      jsonData,
      formatted: true,
    );
    expect(stringifiedJson, '''
{
  "a": 1,
  "b": 2
}''');
  });
}
