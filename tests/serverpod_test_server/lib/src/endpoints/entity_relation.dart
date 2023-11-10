import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class RelationEndpoint extends Endpoint {
  Future<List<Citizen>> citizenFindWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    return await Citizen.db.find(
      session,
      where: (t) => t.company.name.equals(companyName),
    );
  }

  Future<List<Citizen>> citizenFindWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    return await Citizen.db.find(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );
  }

  Future<List<Citizen>> citizenFindOrderedByCompanyName(
    Session session,
  ) async {
    return await Citizen.db.find(session, orderBy: (t) => t.company.name);
  }

  Future<List<Citizen>> citizenFindOrderedByCompanyTownName(
    Session session,
  ) async {
    return await Citizen.db.find(session, orderBy: (t) => t.company.town.name);
  }

  Future<int> citizenDeleteWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    var deleted = await Citizen.db.deleteWhere(
      session,
      where: (t) => t.company.name.equals(companyName),
    );

    return deleted.length;
  }

  Future<int> citizenDeleteWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    var deleted = await Citizen.db.deleteWhere(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );

    return deleted.length;
  }

  Future<int> citizenCountWhereCompanyNameIs(Session session,
      {required String companyName}) async {
    return await Citizen.db.count(
      session,
      where: (t) => t.company.name.equals(companyName),
    );
  }

  Future<int> citizenCountWhereCompanyTownNameIs(Session session,
      {required String townName}) async {
    return await Citizen.db.count(
      session,
      where: (t) => t.company.town.name.equals(townName),
    );
  }

  Future<List<Citizen>> citizenFindAll(Session session) async {
    return await Citizen.db.find(session, orderBy: (t) => t.id);
  }

  /// Includes company and oldCompany and their respective towns
  Future<List<Citizen>> citizenFindAllWithDeepIncludes(Session session) async {
    return await Citizen.db.find(
      session,
      orderBy: (t) => t.id,
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
    return await Citizen.db.find(
      session,
      orderBy: (t) => t.id,
      include: Citizen.include(
        address: Address.include(),
      ),
    );
  }

  /// Includes company and oldCompany
  Future<List<Citizen>> citizenFindAllWithShallowIncludes(
    Session session,
  ) async {
    return await Citizen.db.find(
      session,
      orderBy: (t) => t.id,
      include: Citizen.include(
        company: Company.include(),
        oldCompany: Company.include(),
      ),
    );
  }

  Future<Citizen?> citizenFindByIdWithIncludes(Session session, int id) async {
    return await Citizen.db.findById(session, id,
        include: Citizen.include(company: Company.include()));
  }

  Future<List<Address>> addressFindAll(Session session) async {
    return await Address.db.find(
      session,
      orderBy: (t) => t.id,
      include: Address.include(
        inhabitant: Citizen.include(),
      ),
    );
  }

  Future<Address?> addressFindById(Session session, int id) async {
    return await Address.db.findById(session, id);
  }

  Future<List<Post>> findAllPostsIncludingNextAndPrevious(
    Session session,
  ) async {
    return await Post.db.find(
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
    await Citizen.db.attachRow.company(session, citizen, company);
  }

  Future<void> citizenAttachAddress(
    Session session,
    Citizen citizen,
    Address address,
  ) async {
    await Citizen.db.attachRow.address(session, citizen, address);
  }

  Future<void> citizenDetachAddress(
    Session session,
    Citizen citizen,
  ) async {
    await Citizen.db.detachRow.address(session, citizen);
  }

  Future<void> addressAttachCitizen(
    Session session,
    Address address,
    Citizen citizen,
  ) async {
    await Address.db.attachRow.inhabitant(session, address, citizen);
  }

  Future<void> addressDetachCitizen(
    Session session,
    Address address,
  ) async {
    await Address.db.detachRow.inhabitant(session, address);
  }

  Future<List<Company>> companyFindAll(Session session) async {
    return await Company.db.find(session, orderBy: (t) => t.id);
  }

  Future<int?> citizenInsert(Session session, Citizen citizen) async {
    var insertedCitizen = await Citizen.db.insertRow(session, citizen);
    return insertedCitizen.id;
  }

  Future<int?> companyInsert(Session session, Company company) async {
    var insertedCompany = await Company.db.insertRow(session, company);
    return insertedCompany.id;
  }

  Future<int?> townInsert(Session session, Town town) async {
    var insertedTown = await Town.db.insertRow(session, town);
    return insertedTown.id;
  }

  Future<int?> addressInsert(Session session, Address address) async {
    var insertedAddress = await Address.db.insertRow(session, address);
    return insertedAddress.id;
  }

  Future<int?> postInsert(Session session, Post post) async {
    var insertedPost = await Post.db.insertRow(session, post);
    return insertedPost.id;
  }

  Future<int> deleteAll(Session session) async {
    var addressDeletions = await Address.db
        .deleteWhere(session, where: (_) => Constant.bool(true));
    var citizenDeletions = await Citizen.db
        .deleteWhere(session, where: (_) => Constant.bool(true));
    var companyDeletions = await Company.db
        .deleteWhere(session, where: (_) => Constant.bool(true));
    var townDeletions =
        await Town.db.deleteWhere(session, where: (_) => Constant.bool(true));

    var postDeletions =
        await Post.db.deleteWhere(session, where: (_) => Constant.bool(true));

    return townDeletions.length +
        companyDeletions.length +
        citizenDeletions.length +
        addressDeletions.length +
        postDeletions.length;
  }
}
