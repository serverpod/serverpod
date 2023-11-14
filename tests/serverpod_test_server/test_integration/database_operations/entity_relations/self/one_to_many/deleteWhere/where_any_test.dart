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
      'when deleting entities filtered by any many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: zelda.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.any(),
        );

        expect(deletedCatIds, [zelda.id]);
      },
    );

    test(
      'when deleting entities filtered by filtered any many relation then result is as expected',
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
          where: (t) => t.kittens.any((t) => t.name.ilike('smul%')),
        );

        expect(deletedCatIds, [smulan.id]);
      },
    );

    test(
        'when deleting entities filtered on any many relation in combination with other filter then result is as expected.',
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
        where: (t) => t.kittens.any() | t.name.equals('Zelda'),
      );

      expect(deletedCatIds, hasLength(2));
      expect(deletedCatIds, containsAll([zelda.id, smulan.id]));
    });

    test(
      'when deleting entities filtered on OR filtered any many relation then result is as expected.',
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
          where: (t) => t.kittens.any(
            (t) => t.name.ilike('kitt%') | t.name.equals('Smulan II'),
          ),
        );

        expect(deletedCatIds, hasLength(2));
        expect(deletedCatIds, [zelda.id, smulan.id]);
      },
    );

    test(
      'when deleting entities filtered on multiple filtered any many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Zelda II', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) =>
              t.kittens.any((t) => t.name.ilike('kitt%')) &
              t.kittens.any((t) => t.name.equals('Zelda II')),
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
      'when deleting entities filtered on nested any many relation then result is as expected',
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

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.any((o) => o.kittens.any()),
        );

        expect(deletedCatIds, [smulan.id]);
      },
    );

    test(
      'when deleting entities filtered on filtered nested any many relation then result is as expected',
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
          Cat(name: 'Nested Kitten4', motherId: kittens.first.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.any(
            (o) => o.kittens.any((o) => o.name.equals('Nested Kitten1')),
          ),
        );

        expect(deletedCatIds, [smulan.id]);
      },
    );
  });
}
