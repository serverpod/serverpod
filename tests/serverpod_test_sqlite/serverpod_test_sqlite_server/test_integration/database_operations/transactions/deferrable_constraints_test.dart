import 'package:serverpod/database.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await DeferrableRelationInitiallyImmediate.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await DeferrableRelationInitiallyDeferred.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await DeferrableRelationParent.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  test(
    'Given an initially immediate deferrable relation, '
    'when a child is inserted before its parent without deferring constraints, '
    'then the transaction fails.',
    () async {
      await expectLater(
        session.db.transaction((transaction) async {
          await DeferrableRelationInitiallyImmediate.db.insertRow(
            session,
            DeferrableRelationInitiallyImmediate(parentId: 42001),
            transaction: transaction,
          );
          await DeferrableRelationParent.db.insertRow(
            session,
            DeferrableRelationParent(id: 42001, name: 'parent'),
            transaction: transaction,
          );
        }),
        throwsA(isA<DatabaseQueryException>()),
      );
    },
  );

  test(
    'Given an initially immediate deferrable relation, '
    'when a child is inserted before its parent with deferred constraint checking, '
    'then the transaction commits.',
    () async {
      await session.db.transaction(
        settings: const TransactionSettings(deferConstraints: true),
        (transaction) async {
          await DeferrableRelationInitiallyImmediate.db.insertRow(
            session,
            DeferrableRelationInitiallyImmediate(parentId: 42002),
            transaction: transaction,
          );
          await DeferrableRelationParent.db.insertRow(
            session,
            DeferrableRelationParent(id: 42002, name: 'parent'),
            transaction: transaction,
          );
        },
      );

      var children = await DeferrableRelationInitiallyImmediate.db.find(
        session,
      );
      expect(children, hasLength(1));
    },
  );

  test(
    'Given an initially deferred relation, '
    'when a child is inserted before its parent using the default transaction settings, '
    'then the transaction commits.',
    () async {
      await session.db.transaction((transaction) async {
        await DeferrableRelationInitiallyDeferred.db.insertRow(
          session,
          DeferrableRelationInitiallyDeferred(parentId: 42003),
          transaction: transaction,
        );
        await DeferrableRelationParent.db.insertRow(
          session,
          DeferrableRelationParent(id: 42003, name: 'parent'),
          transaction: transaction,
        );
      });

      var children = await DeferrableRelationInitiallyDeferred.db.find(
        session,
      );
      expect(children, hasLength(1));
    },
  );
}
