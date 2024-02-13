import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TransactionsDatabaseEndpoint extends Endpoint {
  Future<void> removeRow(Session session, int num) async {
    await session.dbNext.transaction((transaction) async {
      await session.dbNext.deleteWhere<SimpleData>(
        where: SimpleData.t.num.equals(num),
        transaction: transaction,
      );
    });
  }

  Future<bool> updateInsertDelete(
      Session session, int numUpdate, int numInsert, int numDelete) async {
    var data = await session.dbNext.findFirstRow<SimpleData>(
      where: SimpleData.t.num.equals(numUpdate),
    );

    return await session.dbNext.transaction((transaction) async {
      data!.num = 1000;
      await session.dbNext.updateRow(data, transaction: transaction);

      var newData = SimpleData(
        num: numInsert,
      );
      await session.dbNext.insertRow(newData, transaction: transaction);

      await session.dbNext.deleteWhere<SimpleData>(
        where: SimpleData.t.num.equals(numDelete),
        transaction: transaction,
      );

      return true;
    });
  }
}
