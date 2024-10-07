import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<void> _deleteAll(Session session) async {
  await ParentClass.db
      .deleteWhere(session, where: (element) => Constant.bool(true));
}

void main() async {
  var session = await IntegrationTestServer().session();

  tearDownAll(() async => await _deleteAll(session));

  test(
      'Given a class extends another class, then the child-class is a sub-type parent-class',
      () {
    var childClass = ChildClass(
      grandParentField: 'grandParentField',
      parentField: 'parentField',
      childField: 2,
    );

    expect(childClass, isA<ParentClass>());
  });

  test(
      'Given a ChildClass is instantiated and inserted into the ParentClass table, then the ChildClass should be retrievable from the ParentClass table',
      () async {
    var childClass = ChildClass(
      grandParentField: 'grandParentField',
      parentField: 'parentField',
      childField: 2,
    );

    var childInParentDb = await ParentClass.db.insertRow(session, childClass);
    var parentDbFirstRow = await ParentClass.db.findFirstRow(session);

    expect(childInParentDb.id, parentDbFirstRow!.id);
    expect(childInParentDb.grandParentField, parentDbFirstRow.grandParentField);
    expect(childInParentDb.parentField, parentDbFirstRow.parentField);
  });
}
