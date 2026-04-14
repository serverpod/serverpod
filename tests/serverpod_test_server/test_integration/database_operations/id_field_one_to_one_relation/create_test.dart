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
    'Given models with a 1:1 relation on id field',
    () {
      test(
        'when inserting an entry in the related table with an id that is not in the parent table, '
        'then the insertion fails',
        () async {
          var task = Task(name: 'Task 1', time: DateTime.now());
          task = await Task.db.insertRow(session, task);

          final taskClaim = TaskClaim(id: task.id! + 1, server: 'Server 1');

          expect(
            () => TaskClaim.db.insertRow(session, taskClaim),
            throwsA(isA<DatabaseException>()),
          );
        },
      );
    },
  );
}
