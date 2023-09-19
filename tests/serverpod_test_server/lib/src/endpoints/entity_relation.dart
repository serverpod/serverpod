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
      include: Citizen.include(
        company: Company.include(town: Town.include()),
        oldCompany: Company.include(town: Town.include()),
      ),
    );
  }

  /// Includes the address
  Future<List<Citizen>> citizenFindAllWithNamedRelationNoneOriginSide(
    Session session,
  ) async {
    return await Citizen.find(
      session,
      orderBy: Citizen.t.id,
      include: Citizen.include(
        address: Address.include(),
      ),
    );
  }

  /// Includes company and oldCompany
  Future<List<Citizen>> citizenFindAllWithShallowIncludes(
    Session session,
  ) async {
    return await Citizen.find(
      session,
      orderBy: Citizen.t.id,
      include: Citizen.include(
        company: Company.include(),
        oldCompany: Company.include(),
      ),
    );
  }

  Future<Citizen?> citizenFindByIdWithIncludes(Session session, int id) async {
    return await Citizen.findById(session, id,
        include: Citizen.include(company: Company.include()));
  }

  Future<List<Address>> addressFindAll(Session session) async {
    return await Address.find(
      session,
      orderBy: Address.t.id,
      include: Address.include(
        inhabitant: Citizen.include(),
      ),
    );
  }

  Future<Address?> addressFindById(Session session, int id) async {
    return await Address.findById(session, id);
  }

  Future<List<Post>> findAllPostsIncludingNextAndPrevious(
    Session session,
  ) async {
    return await Post.find(
      session,
      include: Post.include(
        previous: Post.include(),
        next: Post.include(),
      ),
    );
  }

  Future<void> citizenAttachCompany(
    Session session,
    Citizen citizen,
    Company company,
  ) async {
    await Citizen.db.attach.company(session, citizen, company);
  }

  Future<void> citizenAttachAddress(
    Session session,
    Citizen citizen,
    Address address,
  ) async {
    await Citizen.db.attach.address(session, citizen, address);
  }

  Future<void> citizenDetachAddress(
    Session session,
    Citizen citizen,
  ) async {
    await Citizen.db.detach.address(session, citizen);
  }

  Future<void> addressAttachCitizen(
    Session session,
    Address address,
    Citizen citizen,
  ) async {
    await Address.db.attach.inhabitant(session, address, citizen);
  }

  Future<void> addressDetachCitizen(
    Session session,
    Address address,
  ) async {
    await Address.db.detach.inhabitant(session, address);
  }

  Future<List<Company>> companyFindAll(Session session) async {
    return await Company.find(session, orderBy: Company.t.id);
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

  Future<int?> addressInsert(Session session, Address address) async {
    await Address.insert(session, address);
    return address.id;
  }

  Future<int?> postInsert(Session session, Post post) async {
    await Post.insert(session, post);
    return post.id;
  }

  Future<int> deleteAll(Session session) async {
    var townDeletions =
        await Town.delete(session, where: (_) => Constant.bool(true));
    var companyDeletions =
        await Company.delete(session, where: (_) => Constant.bool(true));
    var citizenDeletions =
        await Citizen.delete(session, where: (_) => Constant.bool(true));
    var addressDeletions =
        await Address.delete(session, where: (_) => Constant.bool(true));
    var postDeletions =
        await Post.delete(session, where: (_) => Constant.bool(true));

    return townDeletions +
        companyDeletions +
        citizenDeletions +
        addressDeletions +
        postDeletions;
  }
}
