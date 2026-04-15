import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';

class TestToolsEndpoint extends Endpoint {
  Future<void> createSimpleData(Session session, int data) async {
    await SimpleData.db.insertRow(
      session,
      SimpleData(
        num: data,
      ),
    );
  }

  Future<List<SimpleData>> getAllSimpleData(Session session) async {
    return SimpleData.db.find(session);
  }

  Future<void> createSimpleDatasInsideTransactions(
    Session session,
    int data,
  ) async {
    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });

    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });
  }

  Future<void> createSimpleDataAndThrowInsideTransaction(
    Session session,
    int data,
  ) async {
    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });

    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );

      throw Exception(
        'Some error occurred and transaction should not be committed.',
      );
    });
  }

  Future<void> createSimpleDatasInParallelTransactionCalls(
    Session session,
  ) async {
    Future<void> createSimpleDataInTransaction(int num) async {
      await session.db.transaction((transaction) async {
        await SimpleData.db.insertRow(
          session,
          SimpleData(
            num: num,
          ),
          transaction: transaction,
        );
      });
    }

    await Future.wait([
      createSimpleDataInTransaction(1),
      createSimpleDataInTransaction(2),
      createSimpleDataInTransaction(3),
      createSimpleDataInTransaction(4),
    ]);
  }
}
