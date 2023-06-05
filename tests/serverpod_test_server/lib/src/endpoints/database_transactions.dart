import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TransactionsDatabaseEndpoint extends Endpoint {
  Future<void> removeRow(Session session, int num) async {
    await session.db.transaction((transaction) async {
      await session.db.delete<SimpleData>(
        where: SimpleData.t.num.equals(num),
        transaction: transaction,
      );
    });
  }

  Future<bool> updateInsertDelete(
      Session session, int numUpdate, int numInsert, int numDelete) async {
    var data = await session.db.findSingleRow<SimpleData>(
      where: SimpleData.t.num.equals(numUpdate),
    );

    return await session.db.transaction((transaction) async {
      data = data!.copyWith(num: 1000);
      await session.db.update(data!, transaction: transaction);

      var newData = SimpleData(num: numInsert);

      await session.db.insert(newData, transaction: transaction);

      await session.db.delete<SimpleData>(
        where: SimpleData.t.num.equals(numDelete),
        transaction: transaction,
      );

      return true;
    });
  }
}
