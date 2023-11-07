import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when fetching entities filtered by none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none(),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(3));
        expect(catNames, containsAll(['Kitten1', 'Kitten2', 'Kitten3']));
      },
    );

    test(
      'when fetching entities filtered by filtered none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Smulan III', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none((t) => t.name.ilike('smul%')),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Smulan III', 'Smulan II']));
      },
    );

    test(
      'when fetching entities filtered on none many relation in combination with other filter then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none() | t.name.equals('Zelda'),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(3));
        expect(catNames, containsAll(['Zelda', 'Kitten1', 'Kitten2']));
      },
    );

    test(
      'when fetching entities filtered on OR filtered none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none(
            (o) => o.name.ilike('kitt%') | o.name.ilike('smul%'),
          ),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Kitten1', 'Smulan II']));
      },
    );

    test(
      'when fetching entities filtered on multiple filtered none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) =>
              t.kittens.none((o) => o.name.ilike('kitt%')) &
              t.kittens.none((o) => o.name.ilike('smul%')),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Kitten1', 'Smulan II']));
      },
    );
  });

  group('Given entities with nested one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when filtering on nested none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        await Cat.db.insert(session, [
          Cat(name: 'Kitten2', motherId: kittens.first.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none((o) => o.kittens.none()),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(3));
        expect(catNames, containsAll(['Smulan II', 'Kitten2']));
      },
    );

    test(
      'when fetching entities filtered on filtered nested none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        await Cat.db.insert(session, [
          Cat(name: 'Kitten2', motherId: kittens.first.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.none(
            (o) => o.kittens.none((o) => o.name.ilike('kitt%')),
          ),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(3));
        expect(catNames, containsAll(['Smulan II', 'Kitten2']));
      },
    );
  });
}
