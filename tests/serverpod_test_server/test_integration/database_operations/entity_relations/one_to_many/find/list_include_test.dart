import 'package:serverpod/serverpod.dart' as pod;

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';

import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  /**
   * The structure of the data used in this test is as follows:
   * 
   * City: {
   *   citizens: Person[],
   *   organizations: Organization[],
   * }
   * 
   * Organization: {
   *   city: City?,
   *   people: Person[],
   * }
   * 
   * Person: {
   *   organization: Organization?,
   * }
   */

  tearDown(() async {
    await Person.db.deleteWhere(session, where: (t) => pod.Constant.bool(true));
    await Organization.db.deleteWhere(
      session,
      where: (t) => pod.Constant.bool(true),
    );
    await City.db.deleteWhere(session, where: (t) => pod.Constant.bool(true));
  });

  test(
    'Given an model with a list relation with nothing attached when fetching model including list relation then returned model has empty list as list relation.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var city = await City.db.findById(
        session,
        stockholm.id!,
        include: City.include(
          citizens: Person.includeList(),
        ),
      );

      expect(city?.citizens, []);
    },
  );

  test(
    'Given an model with a implicit list relation with data attached when fetching model including list relation then returned model has the attached data in the list relation.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
      var gothenburg = await City.db.insertRow(
        session,
        City(name: 'Gothenburg'),
      );

      var citizen1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var citizen2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var citizen3 = await Person.db.insertRow(session, Person(name: 'Alice'));

      await City.db.attach.citizens(session, stockholm, [citizen1, citizen2]);
      await City.db.attach.citizens(session, gothenburg, [citizen3]);

      var city = await City.db.findById(
        session,
        stockholm.id!,
        include: City.include(
          citizens: Person.includeList(),
        ),
      );

      expect(city?.citizens, hasLength(2));

      var citizenIds = city?.citizens?.map((e) => e.id);
      expect(citizenIds, contains(citizen1.id));
      expect(citizenIds, contains(citizen2.id));
    },
  );

  test(
    'Given an model with a explicit list relation with data attached when fetching model including list relation then returned model has the attached data in the list relation.',
    () async {
      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
      var flutter = await Organization.db.insertRow(
        session,
        Organization(name: 'Flutter'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person2,
      ]);
      await Organization.db.attach.people(session, flutter, [person3]);

      var organization = await Organization.db.findById(
        session,
        serverpod.id!,
        include: Organization.include(
          people: Person.includeList(),
        ),
      );

      expect(organization?.people, hasLength(2));

      var peopleIds = organization?.people?.map((e) => e.id);
      expect(peopleIds, contains(person1.id));
      expect(peopleIds, contains(person2.id));
    },
  );

  test(
    'Given an model with a list relation with data attached when fetching filtered models including list relation then returned model has the attached data in the list relation.',
    () async {
      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
      var flutter = await Organization.db.insertRow(
        session,
        Organization(name: 'Flutter'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person2,
      ]);
      await Organization.db.attach.people(session, flutter, [person3]);

      var organizations = await Organization.db.find(
        session,
        where: (t) => t.name.equals('Serverpod'),
        include: Organization.include(
          people: Person.includeList(),
        ),
      );

      expect(organizations, hasLength(1));

      expect(organizations.first.people, hasLength(2));
      var peopleIds = organizations.first.people?.map((e) => e.id);
      expect(peopleIds, contains(person1.id));
      expect(peopleIds, contains(person2.id));
    },
  );

  test(
    'Given a list relation when querying for all models including the list relation then the list relation is populated in the returned models.',
    () async {
      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
      var flutter = await Organization.db.insertRow(
        session,
        Organization(name: 'Flutter'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person2,
      ]);
      await Organization.db.attach.people(session, flutter, [person3]);

      var organizations = await Organization.db.find(
        session,
        orderBy: (t) => t.id,
        include: Organization.include(
          people: Person.includeList(),
        ),
      );

      expect(organizations, hasLength(2));

      expect(organizations.first.people, hasLength(2));
      var peopleIdsFirst = organizations.first.people?.map((e) => e.id);
      expect(peopleIdsFirst, contains(person1.id));
      expect(peopleIdsFirst, contains(person2.id));

      expect(organizations.last.people, hasLength(1));
      expect(organizations.last.people?.map((e) => e.id), contains(person3.id));
    },
  );

  test(
    'Given adjacent many relation in the top level when including both relations then the lists are populated in the returned value.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
      var gothenburg = await City.db.insertRow(
        session,
        City(name: 'Gothenburg'),
      );

      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
      var flutter = await Organization.db.insertRow(
        session,
        Organization(name: 'Flutter'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

      await City.db.attach.citizens(session, stockholm, [person1, person2]);
      await City.db.attach.citizens(session, gothenburg, [person3, person4]);

      await City.db.attach.organizations(session, stockholm, [
        serverpod,
        flutter,
      ]);

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person2,
      ]);
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

      var citizenIds = city?.citizens?.map((e) => e.id);
      expect(citizenIds, contains(person1.id));
      expect(citizenIds, contains(person2.id));

      expect(city?.organizations, hasLength(2));

      var organizationIds = city?.organizations?.map((e) => e.id);
      expect(organizationIds, contains(serverpod.id));
      expect(organizationIds, contains(flutter.id));
    },
  );

  test(
    'Given a deeply nested list relation when including the nested list then the list is included in the response.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
      var gothenburg = await City.db.insertRow(
        session,
        City(name: 'Gothenburg'),
      );

      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );
      var flutter = await Organization.db.insertRow(
        session,
        Organization(name: 'Flutter'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

      await City.db.attach.citizens(session, stockholm, [person1, person2]);
      await City.db.attach.citizens(session, gothenburg, [person3, person4]);

      await City.db.attach.organizations(session, stockholm, [
        serverpod,
        flutter,
      ]);

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person2,
      ]);
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

      var citizenIds = organization?.city?.citizens?.map((e) => e.id);
      expect(citizenIds, contains(person1.id));
      expect(citizenIds, contains(person2.id));
    },
  );

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

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );

      await City.db.attach.citizens(session, stockholm, [person1, person2]);

      await Organization.db.attach.people(session, serverpod, [person1]);
      await Organization.db.attach.people(session, flutter, [person2]);

      var city = await City.db.findById(
        session,
        stockholm.id!,
        include: City.include(
          citizens: Person.includeList(
            orderBy: (t) => t.id,
            include: Person.include(
              organization: Organization.include(),
            ),
          ),
        ),
      );

      expect(city?.citizens, hasLength(2));

      expect(city?.citizens?.first.organization?.id, serverpod.id);
      expect(city?.citizens?.last.organization?.id, flutter.id);
    },
  );

  test(
    'Given a list relation with a nested object relation where the object relation is set to null in the database when including the list and object then the list is returned but the object is still null.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );

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
    },
  );

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

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

      await City.db.attach.citizens(session, stockholm, [person1, person2]);

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person3,
      ]);
      await Organization.db.attach.people(session, flutter, [person2, person4]);

      var city = await City.db.findById(
        session,
        stockholm.id!,
        include: City.include(
          citizens: Person.includeList(
            orderBy: (t) => t.id,
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

      var peopleIdsFirst = city?.citizens?.first.organization?.people?.map(
        (e) => e.id,
      );
      expect(peopleIdsFirst, contains(person1.id));
      expect(peopleIdsFirst, contains(person3.id));

      expect(
        city?.citizens?.last.organization?.people,
        hasLength(2),
        reason: 'Expected two people in the last organization.',
      );

      var peopleIdsLast = city?.citizens?.last.organization?.people?.map(
        (e) => e.id,
      );
      expect(peopleIdsLast, contains(person2.id));
      expect(peopleIdsLast, contains(person4.id));
    },
  );

  test(
    'Given a list relation when querying with a where clause in the included list then the result only includes the rows satisfying the where clause.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var serverpod = await Organization.db.insertRow(
        session,
        Organization(name: 'Serverpod'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));

      await City.db.attach.citizens(session, stockholm, [
        person1,
        person2,
        person3,
        person4,
      ]);

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person3,
      ]);

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

      var citizenIds = city?.citizens?.map((e) => e.id);
      expect(citizenIds, contains(person1.id));
      expect(citizenIds, contains(person3.id));
    },
  );

  test(
    'Given a list relation when querying with a orderBy clause in the included list then the result is ordered by the orderBy clause.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
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
            orderBy: (t) => t.name,
            limit: 10,
          ),
        ),
      );

      expect(city?.citizens, hasLength(4));
      expect(
        city?.citizens?.map((e) => e.name),
        [person3.name, person4.name, person2.name, person1.name],
      );
    },
  );

  test(
    'Given a list relation when querying with a orderBy in descending order clause in the included list then the result is ordered by the orderBy clause.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
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
            orderBy: (t) => t.name,
            orderDescending: true,
          ),
        ),
      );

      expect(city?.citizens, hasLength(4));
      expect(
        city?.citizens?.map((e) => e.name),
        [person1.name, person2.name, person4.name, person3.name],
      );
    },
  );

  test(
    'Given a list relation when querying with multiple orderBy clauses in the included list then the result is ordered by all the orderedBy clauses.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
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
            orderByList: (t) => [
              pod.Order(
                column: t.name,
              ),
              pod.Order(
                column: t.id,
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
    },
  );

  test(
    'Given a list relation with many rows in the database when including the list with a limit then no more rows are included than the limit provided.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
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
    },
  );

  test(
    'Given a list relation with many rows in the database when including the list with a limit and offset then no more rows are included than the limit provided.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
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
            orderBy: (t) => t.id,
            limit: 2,
            offset: 1,
          ),
        ),
      );

      expect(city?.citizens, hasLength(2));

      var citizenIds = city?.citizens?.map((e) => e.id);
      expect(citizenIds, contains(person2.id));
      expect(citizenIds, contains(person3.id));
    },
  );

  test(
    'Given a list relation with many rows in the database when including the list with a limit and offset in a find query then no more rows are included than the limit provided.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));

      var gothenburg = await City.db.insertRow(
        session,
        City(name: 'Gothenburg'),
      );

      var person1 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'John Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person10 = await Person.db.insertRow(
        session,
        Person(name: 'Extra 1'),
      );
      var person11 = await Person.db.insertRow(
        session,
        Person(name: 'Extra 2'),
      );
      var person12 = await Person.db.insertRow(
        session,
        Person(name: 'Extra 3'),
      );
      var person13 = await Person.db.insertRow(
        session,
        Person(name: 'Extra 4'),
      );

      var person5 = await Person.db.insertRow(
        session,
        Person(name: 'John Smith'),
      );
      var person6 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Smith'),
      );
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
        orderBy: (t) => t.id,
        include: City.include(
          citizens: Person.includeList(
            limit: 2,
            offset: 1,
            orderBy: (t) => t.id,
          ),
        ),
      );

      expect(
        cities,
        hasLength(2),
        reason: 'Expected two cities in the result.',
      );

      expect(
        cities.first.citizens,
        hasLength(2),
        reason: 'Expected two citizens in the last city.',
      );

      var citizenIdsFirst = cities.first.citizens?.map((e) => e.id);
      expect(citizenIdsFirst, contains(person2.id));
      expect(citizenIdsFirst, contains(person3.id));

      expect(
        cities.last.citizens,
        hasLength(2),
        reason: 'Expected two citizens in the first city.',
      );

      var citizenIdsLast = cities.last.citizens?.map((e) => e.id);
      expect(citizenIdsLast, contains(person6.id));
      expect(citizenIdsLast, contains(person7.id));
    },
  );

  test(
    'Given a list relation in a list relation when filtering the nested list on a count and limiting the result then only the selected rows are included and the size is the same as the limit.',
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

      var person1 = await Person.db.insertRow(session, Person(name: 'Angel'));
      var person2 = await Person.db.insertRow(
        session,
        Person(name: 'Jane Doe'),
      );
      var person3 = await Person.db.insertRow(session, Person(name: 'Alice'));
      var person4 = await Person.db.insertRow(session, Person(name: 'Bob'));
      var person5 = await Person.db.insertRow(session, Person(name: 'Aaron'));

      await City.db.attach.citizens(
        session,
        stockholm,
        [person2, person3, person4],
      );

      await Organization.db.attach.people(session, serverpod, [
        person1,
        person3,
      ]);
      await Organization.db.attach.people(session, flutter, [person2, person5]);

      var city = await City.db.findById(
        session,
        stockholm.id!,
        include: City.include(
          citizens: Person.includeList(
            orderBy: (t) => t.organization.people.count(
              (p) => p.name.ilike('A%'),
            ),
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
    },
  );

  test(
    'Given a list relation with many rows when including the list with orderBy and a constraining limit then the result contains the correctly ordered first N rows.',
    () async {
      var stockholm = await City.db.insertRow(session, City(name: 'Stockholm'));
      var gothenburg = await City.db.insertRow(
        session,
        City(name: 'Gothenburg'),
      );

      // Create persons with names that sort alphabetically: Alice, Bob, Charlie, Diana
      var alice = await Person.db.insertRow(session, Person(name: 'Alice'));
      var bob = await Person.db.insertRow(session, Person(name: 'Bob'));
      var charlie = await Person.db.insertRow(session, Person(name: 'Charlie'));
      var diana = await Person.db.insertRow(session, Person(name: 'Diana'));

      // Create persons for second city: Eve, Frank, Grace
      var eve = await Person.db.insertRow(session, Person(name: 'Eve'));
      var frank = await Person.db.insertRow(session, Person(name: 'Frank'));
      var grace = await Person.db.insertRow(session, Person(name: 'Grace'));

      await City.db.attach.citizens(session, stockholm, [
        diana, // Intentionally attach in non-alphabetical order
        alice,
        charlie,
        bob,
      ]);

      await City.db.attach.citizens(session, gothenburg, [
        grace,
        eve,
        frank,
      ]);

      // Query with orderBy name ascending and limit 2
      // Should return first 2 alphabetically: Alice, Bob for Stockholm
      // and Eve, Frank for Gothenburg
      var cities = await City.db.find(
        session,
        orderBy: (t) => t.name,
        include: City.include(
          citizens: Person.includeList(
            orderBy: (t) => t.name,
            limit: 2,
          ),
        ),
      );

      expect(cities, hasLength(2));

      // Gothenburg comes first alphabetically
      var gothenburgResult = cities.first;
      expect(gothenburgResult.name, 'Gothenburg');
      expect(gothenburgResult.citizens, hasLength(2));
      expect(
        gothenburgResult.citizens?.map((e) => e.name).toList(),
        ['Eve', 'Frank'],
        reason: 'Expected first 2 citizens alphabetically: Eve, Frank',
      );

      // Stockholm comes second
      var stockholmResult = cities.last;
      expect(stockholmResult.name, 'Stockholm');
      expect(stockholmResult.citizens, hasLength(2));
      expect(
        stockholmResult.citizens?.map((e) => e.name).toList(),
        ['Alice', 'Bob'],
        reason: 'Expected first 2 citizens alphabetically: Alice, Bob',
      );
    },
  );

  test(
    'Given a list relation with many rows when including the list with orderBy descending and a constraining limit then the result contains the correctly ordered first N rows.',
    () async {
      var city = await City.db.insertRow(session, City(name: 'Stockholm'));

      // Create persons with names that sort alphabetically: Alice, Bob, Charlie, Diana
      var alice = await Person.db.insertRow(session, Person(name: 'Alice'));
      var bob = await Person.db.insertRow(session, Person(name: 'Bob'));
      var charlie = await Person.db.insertRow(session, Person(name: 'Charlie'));
      var diana = await Person.db.insertRow(session, Person(name: 'Diana'));

      await City.db.attach.citizens(session, city, [
        bob, // Intentionally attach in non-alphabetical order
        diana,
        alice,
        charlie,
      ]);

      // Query with orderBy name descending and limit 2
      // Should return first 2 reverse-alphabetically: Diana, Charlie
      var result = await City.db.findById(
        session,
        city.id!,
        include: City.include(
          citizens: Person.includeList(
            orderBy: (t) => t.name,
            orderDescending: true,
            limit: 2,
          ),
        ),
      );

      expect(result?.citizens, hasLength(2));
      expect(
        result?.citizens?.map((e) => e.name).toList(),
        ['Diana', 'Charlie'],
        reason:
            'Expected first 2 citizens reverse-alphabetically: Diana, Charlie',
      );
    },
  );

  test(
    'Given a deeply nested includeList with orderBy and limit when querying with include then the innermost list is correctly ordered and limited.',
    () async {
      // Mirrors the original issue structure: Node -> Sensor -> Data
      // Using: City -> Organization (includeList) -> include -> Person (includeList with orderBy + limit)
      var city = await City.db.insertRow(session, City(name: 'Stockholm'));

      var orgAlpha = await Organization.db.insertRow(
        session,
        Organization(name: 'Alpha'),
      );
      var orgBeta = await Organization.db.insertRow(
        session,
        Organization(name: 'Beta'),
      );

      await City.db.attach.organizations(session, city, [orgAlpha, orgBeta]);

      // Create people and attach in non-alphabetical order
      var alice = await Person.db.insertRow(session, Person(name: 'Alice'));
      var bob = await Person.db.insertRow(session, Person(name: 'Bob'));
      var charlie = await Person.db.insertRow(session, Person(name: 'Charlie'));
      var diana = await Person.db.insertRow(session, Person(name: 'Diana'));

      var eve = await Person.db.insertRow(session, Person(name: 'Eve'));
      var frank = await Person.db.insertRow(session, Person(name: 'Frank'));
      var grace = await Person.db.insertRow(session, Person(name: 'Grace'));

      await Organization.db.attach.people(session, orgAlpha, [
        diana, // Intentionally non-alphabetical
        alice,
        charlie,
        bob,
      ]);

      await Organization.db.attach.people(session, orgBeta, [
        grace,
        eve,
        frank,
      ]);

      // Query pattern matching the original issue:
      // find -> includeList -> include -> includeList(orderBy, limit)
      var result = await City.db.findById(
        session,
        city.id!,
        include: City.include(
          organizations: Organization.includeList(
            orderBy: (t) => t.name,
            include: Organization.include(
              people: Person.includeList(
                orderBy: (t) => t.name,
                limit: 2,
              ),
            ),
          ),
        ),
      );

      expect(result?.organizations, hasLength(2));

      // Alpha comes first alphabetically
      var alphaResult = result?.organizations?.first;
      expect(alphaResult?.name, 'Alpha');
      expect(alphaResult?.people, hasLength(2));
      expect(
        alphaResult?.people?.map((e) => e.name).toList(),
        ['Alice', 'Bob'],
        reason: 'Expected first 2 people alphabetically: Alice, Bob',
      );

      // Beta comes second
      var betaResult = result?.organizations?.last;
      expect(betaResult?.name, 'Beta');
      expect(betaResult?.people, hasLength(2));
      expect(
        betaResult?.people?.map((e) => e.name).toList(),
        ['Eve', 'Frank'],
        reason: 'Expected first 2 people alphabetically: Eve, Frank',
      );
    },
  );

  test(
    'Given a list relation with orderBy and limit when sorting is disabled in PostgreSQL then the ORM query still returns correctly ordered rows.',
    () async {
      var city = await City.db.insertRow(session, City(name: 'TestCity'));

      var org1 = await Organization.db.insertRow(
        session,
        Organization(name: 'Org1'),
      );
      var org2 = await Organization.db.insertRow(
        session,
        Organization(name: 'Org2'),
      );

      await City.db.attach.organizations(session, city, [org1, org2]);

      // Insert many persons per organization in reverse alphabetical order.
      // This creates heap storage where the physical order is opposite to
      // the desired sort order.
      var names1 = List.generate(
        50,
        (i) => 'Person_${(99 - i).toString().padLeft(2, '0')}',
      );
      var names2 = List.generate(
        50,
        (i) => 'Member_${(99 - i).toString().padLeft(2, '0')}',
      );

      var persons1 = <Person>[];
      for (var name in names1) {
        persons1.add(
          await Person.db.insertRow(session, Person(name: name)),
        );
      }
      var persons2 = <Person>[];
      for (var name in names2) {
        persons2.add(
          await Person.db.insertRow(session, Person(name: name)),
        );
      }

      await Organization.db.attach.people(session, org1, persons1);
      await Organization.db.attach.people(session, org2, persons2);

      // Disable sorting to force PostgreSQL to use hash-based operations
      // for the window function's PARTITION BY. This simulates conditions
      // where the CTE's materialized order is not preserved, which is the
      // root cause of issue #4110.
      await session.db.transaction((transaction) async {
        await session.db.unsafeExecute(
          'SET LOCAL enable_sort = off;',
          transaction: transaction,
        );

        // Query pattern matching the original issue:
        // find -> includeList -> include -> includeList(orderBy, limit)
        var result = await City.db.findById(
          session,
          city.id!,
          include: City.include(
            organizations: Organization.includeList(
              orderBy: (t) => t.name,
              include: Organization.include(
                people: Person.includeList(
                  orderBy: (t) => t.name,
                  limit: 3,
                ),
              ),
            ),
          ),
          transaction: transaction,
        );

        expect(result?.organizations, hasLength(2));

        var org1Result = result?.organizations?.firstWhere(
          (o) => o.name == 'Org1',
        );
        expect(org1Result?.people, hasLength(3));
        expect(
          org1Result?.people?.map((e) => e.name).toList(),
          ['Person_50', 'Person_51', 'Person_52'],
          reason:
              'Expected first 3 people alphabetically: Person_50, Person_51, Person_52',
        );

        var org2Result = result?.organizations?.firstWhere(
          (o) => o.name == 'Org2',
        );
        expect(org2Result?.people, hasLength(3));
        expect(
          org2Result?.people?.map((e) => e.name).toList(),
          ['Member_50', 'Member_51', 'Member_52'],
          reason:
              'Expected first 3 people alphabetically: Member_50, Member_51, Member_52',
        );
      });
    },
  );
}
