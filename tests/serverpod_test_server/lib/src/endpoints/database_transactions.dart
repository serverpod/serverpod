import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TransactionsDatabaseEndpoint extends Endpoint {
  Future<void> removeRow(Session session, int num) async {
    Transaction txn = Transaction();

    await session.db.delete<SimpleData>(
      where: SimpleData.t.num.equals(num),
      transaction: txn,
    );

    await session.db.executeTransation(txn);
  }

  Future<bool> updateInsertDelete(
      Session session, int numUpdate, int numInsert, int numDelete) async {
    Transaction txn = Transaction();

    var data = await session.db.findSingleRow<SimpleData>(
      where: SimpleData.t.num.equals(numUpdate),
    );

    data!.num = 1000;
    await session.db.update(data, transaction: txn);

    var newData = SimpleData(
      num: numInsert,
    );
    await session.db.insert(newData, transaction: txn);

    await session.db.delete<SimpleData>(
      where: SimpleData.t.num.equals(numDelete),
      transaction: txn,
    );

    return await session.db.executeTransation(txn);
  }
}
