import 'package:serverpod/serverpod.dart' as pod;

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';

import 'package:test/test.dart';

void main() async {
  var testServer = IntegrationTestServer();
  var session = await testServer.session();

  tearDown(() async {
    await Person.db.deleteWhere(session, where: (t) => pod.Constant.bool(true));
    await Organization.db
        .deleteWhere(session, where: (t) => pod.Constant.bool(true));
    await City.db.deleteWhere(session, where: (t) => pod.Constant.bool(true));
  });

  test(
      'Given a list relation of a city that can hold citizens where the database only contains the city when including the citizens list then an empty list is included in the result.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var city = await session.dbNext.findById<City>(
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(city?.citizens, []);
  });

  test(
      'Given cities and citizens when finding a single city by id and including the citizens then only the citizens attached to the city is included in the result.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
    var gothenburg = await City.db.insertRow(session, City(name: 'Gothenburg'));

    var citizen1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var citizen2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var citizen3 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await City.db.attach.citizens(session, stockholm, [citizen1, citizen2]);
    await City.db.attach.citizens(session, gothenburg, [citizen3]);

    var city = await session.dbNext.findById<City>(
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(),
      ),
    );

    expect(city?.citizens, hasLength(2));
    expect(city?.citizens?.map((e) => e.id), contains(citizen1.id));
    expect(city?.citizens?.map((e) => e.id), contains(citizen2.id));
  });

  test(
      'Given organizations and people when finding a single organization by id and including the people then only the people attached to the organization is included in the result.',
      () async {
    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await Organization.db.attach.people(session, serverpod, [person1, person2]);
    await Organization.db.attach.people(session, flutter, [person3]);

    var organization = await session.dbNext.findById<Organization>(
      serverpod.id!,
      include: Organization.include(
        people: Person.includeList(),
      ),
    );

    expect(organization?.people, hasLength(2));
    expect(organization?.people?.map((e) => e.id), contains(person1.id));
    expect(organization?.people?.map((e) => e.id), contains(person2.id));
  });

  test(
      'Given organizations and people when finding all organizations with the people list included then each organization has their respective people in their lists.',
      () async {
    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await Organization.db.attach.people(session, serverpod, [person1, person2]);
    await Organization.db.attach.people(session, flutter, [person3]);

    var organizations = await Organization.db.find(
      session,
      orderBy: Organization.t.id,
      include: Organization.include(
        people: Person.includeList(),
      ),
    );

    expect(organizations, hasLength(2));
    expect(organizations.first.people, hasLength(2));
    expect(organizations.first.people?.map((e) => e.id), contains(person1.id));
    expect(organizations.first.people?.map((e) => e.id), contains(person2.id));

    expect(organizations.last.people, hasLength(1));
    expect(organizations.last.people?.map((e) => e.id), contains(person3.id));
  });

  test(
      'Given adjacent many relation in the top level when including both relations then the lists are populated in the returned value.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
    var gothenburg = await City.db.insertRow(session, City(name: 'Gothenburg'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [person1, person2]);
    await City.db.attach.citizens(session, gothenburg, [person3, person4]);

    await City.db.attach
        .organizations(session, stockholm, [serverpod, flutter]);

    await Organization.db.attach.people(session, serverpod, [person1, person2]);
    await Organization.db.attach.people(session, flutter, [person3, person4]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(),
        organizations: Organization.includeList(),
      ),
    );

    expect(city?.citizens, hasLength(2));
    expect(city?.citizens?.map((e) => e.id), contains(person1.id));
    expect(city?.citizens?.map((e) => e.id), contains(person2.id));

    expect(city?.organizations, hasLength(2));
    expect(city?.organizations?.map((e) => e.id), contains(serverpod.id));
    expect(city?.organizations?.map((e) => e.id), contains(flutter.id));
  });

  test(
      'Given a deeply nested list relation when including the nested list then the list is included in the response.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
    var gothenburg = await City.db.insertRow(session, City(name: 'Gothenburg'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [person1, person2]);
    await City.db.attach.citizens(session, gothenburg, [person3, person4]);

    await City.db.attach
        .organizations(session, stockholm, [serverpod, flutter]);

    await Organization.db.attach.people(session, serverpod, [person1, person2]);
    await Organization.db.attach.people(session, flutter, [person3, person4]);

    var organization = await Organization.db.findById(
      session,
      serverpod.id!,
      include: Organization.include(
        city: City.include(
          citizens: Person.includeList(),
        ),
      ),
    );

    expect(organization?.city?.citizens, hasLength(2));
    expect(
      organization?.city?.citizens?.map((e) => e.id),
      contains(person1.id),
    );
    expect(
      organization?.city?.citizens?.map((e) => e.id),
      contains(person2.id),
    );
  });

  test(
      'Given a list relation with a nested object relation when including the list and object then the deeply nested data is returned.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));

    await City.db.attach.citizens(session, stockholm, [person1, person2]);

    await Organization.db.attach.people(session, serverpod, [person1]);
    await Organization.db.attach.people(session, flutter, [person2]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy: Person.t.id,
          include: Person.include(
            organization: Organization.include(),
          ),
        ),
      ),
    );

    expect(city?.citizens, hasLength(2));

    expect(city?.citizens?.first.organization?.id, serverpod.id);
    expect(city?.citizens?.last.organization?.id, flutter.id);
  });

  test(
      'Given a list relation with a nested object relation where the object relation is set to null in the database when including the list and object then the list is returned but the object is still null.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));

    await City.db.attach.citizens(session, stockholm, [person1]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          include: Person.include(
            organization: Organization.include(
              people: Person.includeList(),
            ),
          ),
        ),
      ),
    );

    expect(city?.citizens?.first.organization, isNull);
    expect(city?.citizens?.first.organizationId, isNull);
  });

  test(
      'Given a list relation with a deeply nested list relation when including the list and nested list then the deeply nested data is returned.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [person1, person2]);

    await Organization.db.attach.people(session, serverpod, [person1, person3]);
    await Organization.db.attach.people(session, flutter, [person2, person4]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy: Person.t.id,
          include: Person.include(
            organization: Organization.include(
              people: Person.includeList(),
            ),
          ),
        ),
      ),
    );

    expect(
      city?.citizens,
      hasLength(2),
      reason: 'Expected two citizens in the city.',
    );

    expect(
      city?.citizens?.first.organization?.people,
      hasLength(2),
      reason: 'Expected two people in the first organization.',
    );
    expect(
      city?.citizens?.first.organization?.people?.map((e) => e.id),
      contains(person1.id),
    );
    expect(
      city?.citizens?.first.organization?.people?.map((e) => e.id),
      contains(person3.id),
    );

    expect(
      city?.citizens?.last.organization?.people,
      hasLength(2),
      reason: 'Expected two people in the last organization.',
    );
    expect(
      city?.citizens?.last.organization?.people?.map((e) => e.id),
      contains(person2.id),
    );
    expect(
      city?.citizens?.last.organization?.people?.map((e) => e.id),
      contains(person4.id),
    );
  });

  test(
      'Given a list relation when quering with a where clause in the included list then the result only includes the rows satisfying the where clause.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    await Organization.db.attach.people(session, serverpod, [person1, person3]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          where: (t) => t.organizationId.equals(serverpod.id!),
        ),
      ),
    );

    expect(city?.citizens, hasLength(2));
    expect(city?.citizens?.map((e) => e.id), contains(person1.id));
    expect(city?.citizens?.map((e) => e.id), contains(person3.id));
  });

  test(
      'Given a list relation when quering with a orderBy clause in the included list then the result is ordered by the orderBy clause.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy: Person.t.name,
          limit: 10,
        ),
      ),
    );

    expect(city?.citizens, hasLength(4));
    expect(
      city?.citizens?.map((e) => e.name),
      [person3.name, person4.name, person2.name, person1.name],
    );
  });

  test(
      'Given a list relation when quering with a orderBy in descending order clause in the included list then the result is ordered by the orderBy clause.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy: Person.t.name,
          orderDescending: true,
        ),
      ),
    );

    expect(city?.citizens, hasLength(4));
    expect(
      city?.citizens?.map((e) => e.name),
      [person1.name, person2.name, person4.name, person3.name],
    );
  });

  test(
      'Given a list relation when quering with multiple orderBy clauses in the included list then the the result is ordered by all the orderedBy clauses.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderByList: [
            pod.Order(
              column: Person.t.name,
            ),
            pod.Order(
              column: Person.t.id,
              orderDescending: true,
            ),
          ],
        ),
      ),
    );

    expect(city?.citizens, hasLength(4));
    expect(
      city?.citizens?.map((e) => e.id),
      [person4.id, person3.id, person1.id, person2.id],
    );
  });

  test(
      'Given a list relation with many rows in the database when including the list with a limit then no more rows are included than the limit provided.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          limit: 2,
        ),
      ),
    );

    expect(city?.citizens, hasLength(2));
  });

  test(
      'Given a list relation with many rows in the database when including the list with a limit and offset then no more rows are included than the limit provided.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var person1 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Alice'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
    ]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy: Person.t.id,
          limit: 2,
          offset: 1,
        ),
      ),
    );

    expect(city?.citizens, hasLength(2));
    expect(city?.citizens?.map((e) => e.id), contains(person2.id));
    expect(city?.citizens?.map((e) => e.id), contains(person3.id));
  });

  test(
      'Given a list relation with many rows in the database when including the list with a limit and offset in a find query then no more rows are included than the limit provided.',
      () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var gothenburg = await City.db.insertRow(session, City(name: 'Gothenburg'));

    var person1 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person2 = await Person.db.insertRow(session, Person(name: 'John Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person10 = await Person.db.insertRow(session, Person(name: 'Extra 1'));
    var person11 = await Person.db.insertRow(session, Person(name: 'Extra 2'));
    var person12 = await Person.db.insertRow(session, Person(name: 'Extra 3'));
    var person13 = await Person.db.insertRow(session, Person(name: 'Extra 4'));

    var person5 =
        await Person.db.insertRow(session, Person(name: 'John Smith'));
    var person6 =
        await Person.db.insertRow(session, Person(name: 'Jane Smith'));
    var person7 = await Person.db.insertRow(session, Person(name: 'Bob'));

    await City.db.attach.citizens(session, stockholm, [
      person1,
      person2,
      person3,
      person4,
      person10,
      person11,
      person12,
      person13,
    ]);

    await City.db.attach.citizens(session, gothenburg, [
      person5,
      person6,
      person7,
    ]);

    var cities = await City.db.find(
      session,
      orderBy: City.t.id,
      include: City.include(
        citizens: Person.includeList(limit: 2, offset: 1, orderBy: Person.t.id),
      ),
    );

    expect(cities, hasLength(2), reason: 'Expected two cities in the result.');

    expect(
      cities.first.citizens,
      hasLength(2),
      reason: 'Expected two citizens in the last city.',
    );

    // TODO this test fails randomly

    expect(cities.first.citizens?.map((e) => e.id), contains(person2.id));
    expect(cities.first.citizens?.map((e) => e.id), contains(person3.id));

    expect(
      cities.last.citizens,
      hasLength(2),
      reason: 'Expected two citizens in the first city.',
    );

    expect(cities.last.citizens?.map((e) => e.id), contains(person6.id));
    expect(cities.last.citizens?.map((e) => e.id), contains(person7.id));
  });

  test('Given ...', () async {
    var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

    var serverpod = await Organization.db.insertRow(
      session,
      Organization(name: 'Serverpod'),
    );
    var flutter = await Organization.db.insertRow(
      session,
      Organization(name: 'Flutter'),
    );

    var person1 = await Person.db.insertRow(session, Person(name: 'Angel'));
    var person2 = await Person.db.insertRow(session, Person(name: 'Jane Doe'));
    var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
    var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));
    var person5 = await Person.db.insertRow(session, Person(name: 'Aaron'));

    await City.db.attach
        .citizens(session, stockholm, [person2, person3, person4]);

    await Organization.db.attach.people(session, serverpod, [person1, person3]);
    await Organization.db.attach.people(session, flutter, [person2, person5]);

    var city = await City.db.findById(
      session,
      stockholm.id!,
      include: City.include(
        citizens: Person.includeList(
          orderBy:
              Person.t.organization.people.count((p) => p.name.ilike('A%')),
          orderDescending: true,
          limit: 2,
          include: Person.include(
            organization: Organization.include(
              people: Person.includeList(),
            ),
          ),
        ),
      ),
    );

    print(city?.citizens?.map((e) => e.name));

    expect(city?.citizens, hasLength(2));
    expect(city?.citizens?.map((e) => e.id), [person3.id, person2.id]);
  });
}
