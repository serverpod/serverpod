import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TransactionsDatabaseEndpoint extends Endpoint {
  Future<void> removeRow(Session session, int num) async {
    await session.db.transaction((transaction) async {
      await SimpleData.db.deleteWhere(
        session,
        where: (t) => t.num.equals(num),
        transaction: transaction,
      );
    });
  }

  Future<bool> updateInsertDelete(
    Session session,
    int numUpdate,
    int numInsert,
    int numDelete,
  ) async {
    var data = await SimpleData.db.findFirstRow(
      session,
      where: (t) => t.num.equals(numUpdate),
    );

    return await session.db.transaction((transaction) async {
      data!.num = 1000;
      await SimpleData.db.updateRow(session, data, transaction: transaction);

      var newData = SimpleData(
        num: numInsert,
      );
      await SimpleData.db.insertRow(session, newData, transaction: transaction);

      await SimpleData.db.deleteWhere(
        session,
        where: (t) => t.num.equals(numDelete),
        transaction: transaction,
      );

      return true;
    });
  }
}
