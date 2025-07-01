import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

class FutureCallEntryDashboard extends Endpoint {
  Future<List<FutureCallEntry>>? fetchallJobs(Session session) async {
    return await session.dbNext.find();
  }
}
