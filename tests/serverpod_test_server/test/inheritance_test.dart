import 'package:serverpod_test_server/src/generated/inheritance/child_class.dart';
import 'package:serverpod_test_server/src/generated/inheritance/parent_class.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class extends another class, then the child-class is a sub-type parent-class',
      () {
    var childClass = ChildClass(name: 'Example', age: 30);

    expect(childClass, isA<ParentClass>());
  });
}
