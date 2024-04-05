import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  tearDown(() async => await client.databaseListRelationMethods.deleteAll());
  test(
      'Given an implicit list relation of a city and person when attaching the person to the city then the city list contains the person',
      () async {
    var city = await client.databaseListRelationMethods.insertCity(
      City(name: 'Stockholm'),
    );

    var citizen = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    await client.databaseListRelationMethods.implicitAttachRowCitizen(
      city,
      citizen,
    );

    var updatedCity = await client.databaseListRelationMethods.cityFindById(
      city.id!,
    );

    expect(updatedCity?.citizens.toString(), contains(citizen.toString()));
  });

  test(
      'Given an implicit list relation of a city and two persons when attaching the persons to the city then both persons are in the city list',
      () async {
    var city = await client.databaseListRelationMethods.insertCity(
      City(name: 'Stockholm'),
    );

    var citizen1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var citizen2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.implicitAttachCitizens(
      city,
      [citizen1, citizen2],
    );

    var updatedCity = await client.databaseListRelationMethods.cityFindById(
      city.id!,
    );

    expect(updatedCity?.citizens.toString(), contains(citizen1.toString()));
    expect(updatedCity?.citizens.toString(), contains(citizen2.toString()));
  });

  test(
      'Given an implicit list relation of a city with two persons when detaching one of the persons from the city then it is no longer contained in the city citizens list.',
      () async {
    var city = await client.databaseListRelationMethods.insertCity(
      City(name: 'Stockholm'),
    );

    var citizen1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var citizen2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.implicitAttachCitizens(
      city,
      [citizen1, citizen2],
    );

    await client.databaseListRelationMethods
        .implicitDetachRowCitizens(citizen1);

    var updatedCity = await client.databaseListRelationMethods.cityFindById(
      city.id!,
    );

    expect(
      updatedCity?.citizens.toString(),
      isNot(contains(citizen1.toString())),
    );
  });

  test(
      'Given an implicit list relation of a city with two persons when detaching both of the persons from the city then they are no longer contained in the city citizens list.',
      () async {
    var city = await client.databaseListRelationMethods.insertCity(
      City(name: 'Stockholm'),
    );

    var citizen1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var citizen2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.implicitAttachCitizens(
      city,
      [citizen1, citizen2],
    );

    await client.databaseListRelationMethods.implicitDetachCitizens(
      [citizen1, citizen2],
    );

    var updatedCity = await client.databaseListRelationMethods.cityFindById(
      city.id!,
    );

    expect(
      updatedCity?.citizens.toString(),
      isNot(contains(citizen1.toString())),
    );
    expect(
      updatedCity?.citizens.toString(),
      isNot(contains(citizen2.toString())),
    );
  });

  test(
      'Given an explicit list relation of an organization and person when attaching the person to the organization then the people list contains the person',
      () async {
    var org = await client.databaseListRelationMethods.insertOrganization(
      Organization(name: 'The organization'),
    );

    var people = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    await client.databaseListRelationMethods.explicitAttachRowPeople(
      org,
      people,
    );

    var updatedOrg =
        await client.databaseListRelationMethods.organizationFindById(
      org.id!,
    );

    expect(
      updatedOrg?.people.toString(),
      contains(people.copyWith(organizationId: org.id).toString()),
    );
  });

  test(
      'Given an explicit list relation of an organization and two persons when attaching the persons to the organization then both persons are in the people list',
      () async {
    var org = await client.databaseListRelationMethods.insertOrganization(
      Organization(name: 'The organization'),
    );

    var person1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var person2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.explicitAttachPeople(
      org,
      [person1, person2],
    );

    var updatedOrg =
        await client.databaseListRelationMethods.organizationFindById(
      org.id!,
    );

    expect(
      updatedOrg?.people.toString(),
      contains(person1.copyWith(organizationId: org.id).toString()),
    );
    expect(
      updatedOrg?.people.toString(),
      contains(person2.copyWith(organizationId: org.id).toString()),
    );
  });

  test(
      'Given an explicit list relation of a organization with two persons when detaching one of the persons from the organization then it is no longer contained in the people list.',
      () async {
    var org = await client.databaseListRelationMethods.insertOrganization(
      Organization(name: 'The organization'),
    );

    var person1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var person2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.explicitAttachPeople(
      org,
      [person1, person2],
    );

    await client.databaseListRelationMethods.explicitDetachRowPeople(
      person1,
    );

    var updatedOrg =
        await client.databaseListRelationMethods.organizationFindById(
      org.id!,
    );

    expect(
      updatedOrg?.people.toString(),
      isNot(contains(person1.copyWith(organizationId: org.id).toString())),
    );
  });

  test(
      'Given an explicit list relation of a organization with two persons when detaching both of the persons from the organization then they are no longer contained in the people list.',
      () async {
    var org = await client.databaseListRelationMethods.insertOrganization(
      Organization(name: 'The organization'),
    );

    var person1 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'John Doe'),
    );

    var person2 = await client.databaseListRelationMethods.insertPerson(
      Person(name: 'Jane Doe'),
    );

    await client.databaseListRelationMethods.explicitAttachPeople(
      org,
      [person1, person2],
    );

    await client.databaseListRelationMethods.explicitDetachPeople(
      [person1, person2],
    );

    var updatedOrg =
        await client.databaseListRelationMethods.organizationFindById(
      org.id!,
    );

    expect(
      updatedOrg?.people.toString(),
      isNot(contains(person1.copyWith(organizationId: org.id).toString())),
    );
    expect(
      updatedOrg?.people.toString(),
      isNot(contains(person2.copyWith(organizationId: org.id).toString())),
    );
  });
}
