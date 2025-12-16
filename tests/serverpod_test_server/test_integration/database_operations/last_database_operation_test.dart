import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() async {
  withServerpod('Given a running server', enableSessionLogging: false, (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    final serverpod = session.serverpod;

    test('when server starts '
        'then lastDatabaseOperationTime is set due to startup routines', () {
      expect(serverpod.lastDatabaseOperationTime, isNotNull);
    });

    test('when no database operations are performed '
        'then lastDatabaseOperationTime is not updated', () async {
      final beforeOperation = serverpod.lastDatabaseOperationTime!;

      await Future.delayed(const Duration(seconds: 2));
      expect(serverpod.lastDatabaseOperationTime, equals(beforeOperation));
    });

    test('when performing any database operation '
        'then lastDatabaseOperationTime is updated', () async {
      final beforeOperation = serverpod.lastDatabaseOperationTime!;

      await SimpleData.db.insertRow(session, SimpleData(num: 1));

      final afterOperation = serverpod.lastDatabaseOperationTime!;
      expect(afterOperation.isAfter(beforeOperation), isTrue);
    });

    test('when performing a database operation that fails '
        'then lastDatabaseOperationTime is still updated', () async {
      final row = await SimpleData.db.insertRow(session, SimpleData(num: 1));
      final beforeOperation = serverpod.lastDatabaseOperationTime!;

      await expectLater(
        SimpleData.db.insertRow(session, row),
        throwsA(isA<DatabaseException>()),
      );

      final afterOperation = serverpod.lastDatabaseOperationTime!;
      expect(afterOperation.isAfter(beforeOperation), isTrue);
    });

    test('when performing multiple database operations '
        'then lastDatabaseOperationTime is updated after each one', () async {
      final beforeOperation = serverpod.lastDatabaseOperationTime!;

      await SimpleData.db.insertRow(session, SimpleData(num: 2));
      final firstOperationTime = serverpod.lastDatabaseOperationTime;
      expect(firstOperationTime!.isAfter(beforeOperation), isTrue);

      final row = (await SimpleData.db.findFirstRow(session))!;
      final secondOperationTime = serverpod.lastDatabaseOperationTime;
      expect(secondOperationTime!.isAfter(firstOperationTime), isTrue);

      await SimpleData.db.updateRow(session, row..num = 3);
      final thirdOperationTime = serverpod.lastDatabaseOperationTime;
      expect(thirdOperationTime!.isAfter(secondOperationTime), isTrue);

      await SimpleData.db.deleteRow(session, row);
      final fourthOperationTime = serverpod.lastDatabaseOperationTime;
      expect(fourthOperationTime!.isAfter(thirdOperationTime), isTrue);

      await SimpleData.db.count(session);
      final fifthOperationTime = serverpod.lastDatabaseOperationTime;
      expect(fifthOperationTime!.isAfter(fourthOperationTime), isTrue);
    });
  });
}
