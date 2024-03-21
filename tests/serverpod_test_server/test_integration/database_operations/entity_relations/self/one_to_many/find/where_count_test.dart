import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when fetching models filtered on many relation count then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Kitten4', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.count() > 1,
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );

    test(
      'when fetching models filtered on filtered many relation count then result is as expected',
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
          where: (t) => t.kittens.count((t) => t.name.ilike('kitt%')) > 1,
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );

    test(
      'when fetching models filtered on many relation count in combination with other filter then result is as expected.',
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
          where: (t) => (t.kittens.count() > 2) | t.name.equals('Smulan'),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames, containsAll(['Zelda', 'Smulan']));
      },
    );

    test(
      'when fetching models filtered on multiple many relation count then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
          Cat(name: 'Kitten4', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => (t.kittens.count() > 1) & (t.kittens.count() < 3),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Smulan']);
      },
    );

    test(
      'when fetching models filtered on multiple filtered many relation count then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Zelda II', motherId: zelda.id),
          Cat(name: 'Zelda III', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) =>
              (t.kittens.count((t) => t.name.ilike('kitt%')) > 1) &
              (t.kittens.count((t) => t.name.ilike('Zelda%')) > 1),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );

    test(
      'when fetching models filtered and ordered on many relation count then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Zelda II', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: smulan.id),
          Cat(name: 'Kitten4', motherId: smulan.id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => (t.kittens.count((t) => t.name.ilike('kitt%')) > 1),
          orderBy: (t) => t.kittens.count((t) => t.name.ilike('zelda%')),
          orderDescending: true,
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, hasLength(2));
        expect(catNames.first, 'Zelda');
        expect(catNames.last, 'Smulan');
      },
    );
  });

  group('Given models with nested one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when filtering on nested many relation count then result is as expected',
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
          // Smulan nested kittens
          Cat(name: 'Nested Kitten1', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten2', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten3', motherId: kittens.last.id),

          // Zelda nested kittens
          Cat(name: 'Nested Kitten4', motherId: kittens.first.id),
          Cat(name: 'Nested Kitten5', motherId: kittens.first.id),
          Cat(name: 'Nested Kitten6', motherId: kittens.first.id),
          Cat(name: 'Nested Kitten7', motherId: kittens[1].id),
          Cat(name: 'Nested Kitten8', motherId: kittens[1].id),
          Cat(name: 'Nested Kitten9', motherId: kittens[1].id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.count((o) => o.kittens.count() > 2) > 1,
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );

    test(
      'when fetching models filtered on filtered nested many relation count then result is as expected',
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
          // Smulan nested kittens
          Cat(name: 'Nested Kitten1', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten2', motherId: kittens.last.id),
          Cat(name: 'Nested Kitten3', motherId: kittens.last.id),

          // Zelda nested kittens
          Cat(name: 'Zelda II', motherId: kittens.first.id),
          Cat(name: 'Zelda VI', motherId: kittens.first.id),
          Cat(name: 'Nested Kitten6', motherId: kittens.first.id),
          Cat(name: 'Zelda III', motherId: kittens[1].id),
          Cat(name: 'Zelda IV', motherId: kittens[1].id),
          Cat(name: 'Nested Kitten9', motherId: kittens[1].id),
        ]);

        var fetchedCats = await Cat.db.find(
          session,
          where: (t) => t.kittens.count(
              // All cats with more than 1 kitten with more than 1 kittens named Zelda
              (o) => o.kittens.count((c) => c.name.ilike('zelda%')) > 1) > 1,
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Zelda']);
      },
    );
  });
}
