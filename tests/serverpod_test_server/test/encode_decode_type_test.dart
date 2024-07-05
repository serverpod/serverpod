import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();

  test(
      'Given an object when getting the type name then output is the type name as a string',
      () {
    int number = 1;
    var typeName = protocol.getClassNameForObject(number);
    expect(typeName, 'int');
  });

  test(
    'Given a nullable object when getting the type name then output is the type name as a string',
    () {
      int? number = 1;
      var typeName = protocol.getClassNameForObject(number);
      expect(typeName, 'int');
    },
  );
}
