import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await TaskClaim.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await Task.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  group(
    'Given a 1:1 relation on id field with cascade delete, '
    'when deleting an entry in the parent table',
    () {
      test('then the related row is also deleted', () async {
        var task = Task(name: 'Task 1', time: DateTime.now());
        task = await Task.db.insertRow(session, task);

        final taskClaim = TaskClaim(id: task.id, server: 'Server 1');
        await TaskClaim.db.insertRow(session, taskClaim);

        await Task.db.deleteRow(session, task);

        final deletedTaskClaim = await TaskClaim.db.findById(session, task.id!);
        expect(deletedTaskClaim, isNull);
      });
    },
  );
}
