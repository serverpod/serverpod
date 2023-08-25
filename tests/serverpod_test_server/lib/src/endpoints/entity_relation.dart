import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class RelationEndpoint extends Endpoint {
  Future<List<Citizen>> citizenFindWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    return await Citizen.find(
      session,
      where: (t) => t.company.name.equals(companyName),
    );
  }

  Future<List<Citizen>> citizenFindWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    return await Citizen.find(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );
  }

  Future<List<Citizen>> citizenFindOrderedByCompanyName(
    Session session,
  ) async {
    return await Citizen.find(session, orderBy: Citizen.t.company.name);
  }

  Future<List<Citizen>> citizenFindOrderedByCompanyTownName(
    Session session,
  ) async {
    return await Citizen.find(session, orderBy: Citizen.t.company.town.name);
  }

  Future<int> citizenDeleteWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    return await Citizen.delete(
      session,
      where: (t) => t.company.name.equals(companyName),
    );
  }

  Future<int> citizenDeleteWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    return await Citizen.delete(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );
  }

  Future<int> citizenCountWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    return await Citizen.count(
      session,
      where: (t) => t.company.name.equals(companyName),
    );
  }

  Future<int> citizenCountWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    return await Citizen.count(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );
  }

  Future<List<Citizen>> citizenFindAll(Session session) async {
    return await Citizen.find(session, orderBy: Citizen.t.id);
  }

  /// Includes company and oldCompany and their respective towns
  Future<List<Citizen>> citizenFindAllWithDeepIncludes(Session session) async {
    return await Citizen.find(
      session,
      orderBy: Citizen.t.id,
      include: CitizenInclude(
        company: CompanyInclude(town: TownInclude()),
        oldCompany: CompanyInclude(town: TownInclude()),
      ),
    );
  }

  Future<int?> citizenInsert(Session session, Citizen citizen) async {
    await Citizen.insert(session, citizen);
    return citizen.id;
  }

  Future<int?> companyInsert(Session session, Company company) async {
    await Company.insert(session, company);
    return company.id;
  }

  Future<int?> townInsert(Session session, Town town) async {
    await Town.insert(session, town);
    return town.id;
  }

  Future<int> deleteAll(Session session) async {
    var townDeletions =
        await Town.delete(session, where: (_) => Constant(true));
    var companyDeletions =
        await Company.delete(session, where: (_) => Constant(true));
    var citizenDeletions =
        await Citizen.delete(session, where: (_) => Constant(true));

    return townDeletions + companyDeletions + citizenDeletions;
  }
}
