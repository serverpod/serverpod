import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';

class InsertSimpleDataCall extends FutureCall {
  Future<void> persistIncrementedSimpleData(
    Session session,
    SimpleData data,
  ) async {
    await SimpleData.db.insertRow(
      session,
      data.copyWith(num: data.num + 1),
    );
  }
}
