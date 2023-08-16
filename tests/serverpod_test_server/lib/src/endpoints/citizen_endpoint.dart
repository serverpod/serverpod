import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CitizenEndpoint extends Endpoint {
  Future<List<Citizen>> getAllShallow(Session session) async {
    return await Citizen.find(session, orderBy: Citizen.t.id);
  }

  Future<List<Citizen>> getAllWithDeepIncludes(Session session) async {
    return await Citizen.find(
      session,
      orderBy: Citizen.t.id,
      include: CitizenInclude(
        company: CompanyInclude(town: TownInclude()),
        oldCompany: CompanyInclude(town: TownInclude()),
      ),
    );
  }

  Future<List<Citizen>> findWithIncludesWhereNameIs(
    Session session,
    String name,
  ) async {
    return await Citizen.find(
      session,
      orderBy: Citizen.t.id,
      where: (c) => c.name.equals(name),
      include: CitizenInclude(
        company: CompanyInclude(town: TownInclude()),
        oldCompany: CompanyInclude(town: TownInclude()),
      ),
    );
  }

  Future<int> insert(Session session, Citizen citizen) async {
    await Citizen.insert(session, citizen);
    return citizen.id!;
  }

  Future<int> deleteAll(Session session) async {
    return await Citizen.delete(session, where: (_) => Constant(true));
  }
}
