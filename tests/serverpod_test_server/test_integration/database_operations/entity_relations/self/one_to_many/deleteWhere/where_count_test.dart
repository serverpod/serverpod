import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  group('Given entities with one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when deleting entities filtered on count of many relation then only matching entities are deleted',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Kitten4', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.count() > 1,
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );

    test(
      'when deleting entities filtered on filtered many relation count then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.count((t) => t.name.ilike('kitt%')) > 1,
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );

    test(
      'when deleting entities filtered on many relation count in combination with other filter then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => (t.kittens.count() > 2) | t.name.equals('Smulan'),
        );

        expect(deletedCatIds, hasLength(2));
        expect(deletedCatIds, containsAll([zelda.id, smulan.id]));
      },
    );

    test(
      'when deleting entities filtered on multiple many relation count then result is as expected.',
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

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => (t.kittens.count() > 1) & (t.kittens.count() < 3),
        );

        expect(deletedCatIds, [smulan.id]);
      },
    );

    test(
      'when deleting entities filtered on multiple filtered many relation count then result is as expected.',
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

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) =>
              (t.kittens.count((t) => t.name.ilike('kitt%')) > 1) &
              (t.kittens.count((t) => t.name.ilike('Zelda%')) > 1),
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );
  });

  group('Given entities with nested one to many relation', () {
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

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.count((o) => o.kittens.count() > 2) > 1,
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );

    test(
      'when deleting entities filtered on filtered nested many relation count then result is as expected',
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

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.count(
              // All cats with more than 1 kitten with more than 1 kittens named Zelda
              (o) => o.kittens.count((c) => c.name.ilike('zelda%')) > 1) > 1,
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );
  });
}
