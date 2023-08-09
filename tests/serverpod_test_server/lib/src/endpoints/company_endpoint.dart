import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class CompanyEndpoint extends Endpoint {
  Future<int> insert(Session session, Company company) async {
    await Company.insert(session, company);
    return company.id!;
  }

  Future<int> deleteAll(Session session) async {
    return await Company.delete(session, where: (_) => Constant(true));
  }
}
