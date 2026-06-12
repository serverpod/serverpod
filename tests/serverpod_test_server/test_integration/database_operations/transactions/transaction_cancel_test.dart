import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await UniqueData.db.deleteWhere(session, where: (_) => Constant.bool(true));
  });

  group(
    'Given inserting an object inside a transaction that is cancelled but has a return value ',
    () {
      late Future<UniqueData> transactionFuture;

      setUp(() async {
        transactionFuture = session.db.transaction(
          (transaction) async {
            final insertedData = await UniqueData.db.insertRow(
              session,
              UniqueData(number: 111, email: 'test@serverpod.dev'),
              transaction: transaction,
            );

            var count = await UniqueData.db.count(
              session,
              where: (_) => Constant.bool(true),
              transaction: transaction,
            );

            expect(count, 1);

            await transaction.cancel();

            return insertedData;
          },
        );
      });

      test(
        'when running the transaction then should return the inserted data.',
        () async {
          var insertedData = await transactionFuture;

          expect(insertedData.number, 111);
        },
      );

      test(
        'when calling `count` after the transaction then should return 0.',
        () async {
          await transactionFuture;

          var count = await UniqueData.db.count(
            session,
            where: (_) => Constant.bool(true),
          );

          expect(count, 0);
        },
      );
    },
  );
}
