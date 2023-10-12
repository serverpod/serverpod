import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class DatabaseListRelationMethods extends Endpoint {
  Future<City> insertCity(Session session, City city) async {
    return await City.db.insertRow(session, city);
  }

  Future<Organization> insertOrganization(
    Session session,
    Organization organization,
  ) async {
    return await Organization.db.insertRow(session, organization);
  }

  Future<Person> insertPerson(Session session, Person person) async {
    return await Person.db.insertRow(session, person);
  }

  Future<void> implicitAttachRowCitizen(
    Session session,
    City city,
    Person citizen,
  ) async {
    await City.db.attachRow.citizens(session, city, citizen);
  }

  Future<void> implicitAttachCitizens(
    Session session,
    City city,
    List<Person> citizens,
  ) async {
    await City.db.attach.citizens(session, city, citizens);
  }

  Future<void> implicitDetachRowCitizens(
    Session session,
    Person citizen,
  ) async {
    await City.db.detachRow.citizens(session, citizen);
  }

  Future<void> implicitDetachCitizens(
    Session session,
    List<Person> citizens,
  ) async {
    await City.db.detach.citizens(session, citizens);
  }

  Future<City?> cityFindById(Session session, int id) async {
    var city = await City.db.findById(session, id);

    // TODO: Replace with includes when we have support!
    var citizens = await Person.db.find(
      session,
      where: (t) => t.$_cityCitizensCityId.equals(id),
    );

    return city?.copyWith(citizens: citizens);
  }

  Future<void> explicitAttachRowPeople(
    Session session,
    Organization org,
    Person person,
  ) async {
    await Organization.db.attachRow.people(session, org, person);
  }

  Future<void> explicitAttachPeople(
    Session session,
    Organization org,
    List<Person> persons,
  ) async {
    await Organization.db.attach.people(session, org, persons);
  }

  Future<void> explicitDetachRowPeople(
    Session session,
    Person person,
  ) async {
    await Organization.db.detachRow.people(session, person);
  }

  Future<void> explicitDetachPeople(
    Session session,
    List<Person> persons,
  ) async {
    await Organization.db.detach.people(session, persons);
  }

  Future<Organization?> organizationFindById(Session session, int id) async {
    var org = await Organization.db.findById(session, id);

    // TODO: Replace with includes when we have support!
    var people = await Person.db.find(
      session,
      where: (t) => t.organizationId.equals(id),
    );

    return org?.copyWith(people: people);
  }

  Future<void> deleteAll(Session session) async {
    await Person.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await City.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Organization.db
        .deleteWhere(session, where: (t) => Constant.bool(true));
  }
}
