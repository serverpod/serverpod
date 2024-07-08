import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  group('Given a', () {
    test(
        'non-null integer when encoding then output is the type name and value as a JSON string',
        () {
      int number = 1;
      var typeName = protocol.encodeWithType(number);
      expect(typeName, '{"className":"int","data":1}');
    });

    test(
        'non-null nullable integer when encoding then output is the type name and value as a JSON string',
        () {
      int? number = 1;
      var typeName = protocol.encodeWithType(number);
      expect(typeName, '{"className":"int","data":1}');
    });

    test(
        'null nullable integer when encoding then output is \'null\' for both the type name and data as a JSON string',
        () {
      int? number = null;
      var typeName = protocol.encodeWithType(number);
      expect(typeName, '{"className":"null","data":null}');
    });

    test(
        'non-null SimpleData object when encoding then output is the type name and value as a JSON string',
        () {
      SimpleData simpleData = SimpleData.fromJson({'num': 1});
      var typeName = protocol.encodeWithType(simpleData);
      expect(typeName, '{"className":"SimpleData","data":{"num":1}}');
    });

    test(
        'non-null nullable SimpleData object when encoding then output is the type name and value as a JSON string',
        () {
      SimpleData? simpleData = SimpleData.fromJson({'num': 1});
      var typeName = protocol.encodeWithType(simpleData);
      expect(typeName, '{"className":"SimpleData","data":{"num":1}}');
    });

    test(
        'nullable SimpleData object with a null value when encoding then output is \'null\' for both the type name and data as a JSON string',
        () {
      SimpleData? simpleData = null;
      var typeName = protocol.encodeWithType(simpleData);
      expect(typeName, '{"className":"null","data":null}');
    });
  });
}
