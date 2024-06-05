import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    await Person.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await City.db.deleteWhere(session, where: (t) => Constant.bool(true));
    await Organization.db
        .deleteWhere(session, where: (t) => Constant.bool(true));
  });
  test(
      'Given an implicit list relation of a city and person when attaching the person to the city then the city list contains the person',
      () async {
    var city = await City.db.insertRow(session, City(name: 'Stockholm'));

    var citizen = await Person.db.insertRow(session, Person(name: 'John Doe'));

    await City.db.attachRow.citizens(session, city, citizen);

    var updatedCity = await City.db.findById(
      session,
      city.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(jsonEncode(citizen.toJson())),
    );
  });

  test(
      'Given an implicit list relation of a city and two persons when attaching the persons to the city then both persons are in the city list',
      () async {
    var city = await City.db.insertRow(
      session,
      City(name: 'Stockholm'),
    );

    var citizen1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var citizen2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );

    await City.db.attach.citizens(session, city, [citizen1, citizen2]);

    var updatedCity = await City.db.findById(
      session,
      city.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(jsonEncode(citizen1.toJson())),
    );

    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(jsonEncode(citizen2.toJson())),
    );
  });

  test(
      'Given an implicit list relation of a city with two persons when detaching one of the persons from the city then it is no longer contained in the city citizens list.',
      () async {
    var city = await City.db.insertRow(
      session,
      City(name: 'Stockholm'),
    );

    var citizen1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var citizen2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );

    await City.db.attach.citizens(session, city, [citizen1, citizen2]);

    await City.db.detachRow.citizens(session, citizen1);

    var updatedCity = await City.db.findById(
      session,
      city.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(contains(jsonEncode(citizen1.toJson()))),
    );
  });

  test(
      'Given an implicit list relation of a city with two persons when detaching both of the persons from the city then they are no longer contained in the city citizens list.',
      () async {
    var city = await City.db.insertRow(
      session,
      City(name: 'Stockholm'),
    );

    var citizen1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var citizen2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );

    await City.db.attach.citizens(session, city, [citizen1, citizen2]);
    await City.db.detach.citizens(session, [citizen1, citizen2]);

    var updatedCity = await City.db.findById(
      session,
      city.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(contains(jsonEncode(citizen1.toJson()))),
    );
    expect(
      updatedCity?.citizens?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(contains(jsonEncode(citizen2.toJson()))),
    );
  });

  test(
      'Given an explicit list relation of an organization and person when attaching the person to the organization then the people list contains the person',
      () async {
    var org = await Organization.db.insertRow(
      session,
      Organization(name: 'The organization'),
    );

    var people = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    await Organization.db.attachRow.people(session, org, people);

    var updatedOrg = await Organization.db.findById(
      session,
      org.id!,
      include: Organization.include(people: Person.includeList()),
    );

    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(
        jsonEncode(people.copyWith(organizationId: org.id).toJson()),
      ),
    );
  });

  test(
      'Given an explicit list relation of an organization and two persons when attaching the persons to the organization then both persons are in the people list',
      () async {
    var org = await Organization.db.insertRow(
      session,
      Organization(name: 'The organization'),
    );

    var person1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var person2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );
    await Organization.db.attach.people(session, org, [person1, person2]);

    var updatedOrg = await Organization.db.findById(
      session,
      org.id!,
      include: Organization.include(people: Person.includeList()),
    );

    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(
        jsonEncode(person1.copyWith(organizationId: org.id).toJson()),
      ),
    );
    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      contains(
        jsonEncode(person2.copyWith(organizationId: org.id).toJson()),
      ),
    );
  });

  test(
      'Given an explicit list relation of a organization with two persons when detaching one of the persons from the organization then it is no longer contained in the people list.',
      () async {
    var org = await Organization.db.insertRow(
      session,
      Organization(name: 'The organization'),
    );

    var person1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var person2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );

    await Organization.db.attach.people(session, org, [person1, person2]);

    await Organization.db.detachRow.people(session, person1);

    var updatedOrg = await Organization.db.findById(
      session,
      org.id!,
      include: Organization.include(people: Person.includeList()),
    );

    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(
        contains(jsonEncode(person1.copyWith(organizationId: org.id).toJson())),
      ),
    );
  });

  test(
      'Given an explicit list relation of a organization with two persons when detaching both of the persons from the organization then they are no longer contained in the people list.',
      () async {
    var org = await Organization.db.insertRow(
      session,
      Organization(name: 'The organization'),
    );

    var person1 = await Person.db.insertRow(
      session,
      Person(name: 'John Doe'),
    );

    var person2 = await Person.db.insertRow(
      session,
      Person(name: 'Jane Doe'),
    );
    await Organization.db.attach.people(session, org, [person1, person2]);

    await Organization.db.detach.people(session, [person1, person2]);

    var updatedOrg = await Organization.db.findById(
      session,
      org.id!,
      include: Organization.include(people: Person.includeList()),
    );

    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(
        contains(jsonEncode(person1.copyWith(organizationId: org.id).toJson())),
      ),
    );
    expect(
      updatedOrg?.people?.toJson(
        valueToJson: (el) => jsonEncode(el.toJson()),
      ),
      isNot(
        contains(jsonEncode(person2.copyWith(organizationId: org.id).toJson())),
      ),
    );
  });
}
