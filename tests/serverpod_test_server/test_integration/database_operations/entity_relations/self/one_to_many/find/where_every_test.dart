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
      'when fetching entities filtered by every many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.every((o) => o.name.ilike('kitt%')),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );

    test(
      'when fetching entities filtered on every many relation in combination with other filter then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) =>
              t.kittens.every((o) => o.name.ilike('kitt%')) |
              t.name.equals('Smulan'),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Zelda', 'Smulan']));
      },
    );

    test(
      'when fetching entities filtered on combined filtered every many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens
              .every((t) => t.name.ilike('kitt%') | t.name.equals('Smulan II')),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, ['Zelda', 'Smulan']);
      },
    );

    test(
      'when fetching entities filtered on multiple every many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) =>
              t.kittens.every((t) => t.name.ilike('kitt%')) |
              t.kittens.every((t) => t.name.ilike('smul%')),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Zelda', 'Smulan']));
      },
    );
  });

  group('Given entities with nested one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when fetching entities filtered on nested every many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        await Cat.db.insert(session, [
          Cat(name: 'Nested Kitten1', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten2', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten3', motherId: kittens.last.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.every(
              // All cats where all kittens has kittens with name starting with 'Nest'
              (o) => o.kittens.every((c) => c.name.ilike('nest%'))),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Smulan']);
      },
    );

    test(
      'when fetching entities filtered on nested every many relation in combination with separate filter then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        await Cat.db.insert(session, [
          Cat(name: 'Nested Kitten1', motherId: kittens.first.id),
          Cat(name: 'Nested Kitten2', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten3', motherId: kittens.last.id),
          Cat(name: 'Smulan III', motherId: kittens.last.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.every(
            (o) => o.kittens.every((o) => o.name.ilike('%kitten%')),
          ),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );
  });
}
