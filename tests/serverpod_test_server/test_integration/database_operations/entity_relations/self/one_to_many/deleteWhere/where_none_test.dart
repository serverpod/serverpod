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
      'when deleting models filtered by none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none(),
        );

        expect(deletedCatIds, hasLength(3));
        expect(deletedCatIds, containsAll(kittens.map((e) => e.id)));
      },
    );

    test(
      'when deleting models filtered by filtered none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Smulan III', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none((t) => t.name.ilike('smul%')),
        );

        expect(deletedCatIds, hasLength(2));
        expect(deletedCatIds, containsAll(kittens.map((e) => e.id)));
      },
    );

    test(
      'when deleting models filtered on none many relation in combination with other filter then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none() | t.name.equals('Zelda'),
        );

        expect(deletedCatIds, hasLength(3));
        expect(
          deletedCatIds,
          containsAll([zelda.id, kittens.first.id!, kittens.last.id!]),
        );
      },
    );

    test(
      'when deleting models filtered on OR filtered none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none(
            (o) => o.name.ilike('kitt%') | o.name.ilike('smul%'),
          ),
        );

        expect(deletedCatIds, hasLength(2));
        expect(deletedCatIds, containsAll(kittens.map((e) => e.id)));
      },
    );

    test(
      'when deleting models filtered on multiple filtered none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) =>
              t.kittens.none((o) => o.name.ilike('kitt%')) &
              t.kittens.none((o) => o.name.ilike('smul%')),
        );

        expect(deletedCatIds, hasLength(2));
        expect(deletedCatIds, containsAll(kittens.map((e) => e.id)));
      },
    );
  });

  group('Given models with nested one to many relation', () {
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

        var kitten2 = await Cat.db.insertRow(
          session,
          Cat(name: 'Kitten2', motherId: kittens.first.id),
        );

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none((o) => o.kittens.none()),
        );

        expect(deletedCatIds, hasLength(3));
        expect(
          deletedCatIds,
          containsAll([zelda.id!, kittens.last.id!, kitten2.id!]),
        );
      },
    );

    test(
      'when deleting models filtered on filtered nested none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        var kittens = await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var kitten2 = await Cat.db.insertRow(
          session,
          Cat(name: 'Kitten2', motherId: kittens.first.id),
        );

        var deletedCatIds = await Cat.db.deleteWhere(
          session,
          where: (t) => t.kittens.none(
            (o) => o.kittens.none((o) => o.name.ilike('kitt%')),
          ),
        );

        expect(deletedCatIds, hasLength(3));
        expect(
          deletedCatIds,
          containsAll([zelda.id!, kittens.last.id!, kitten2.id!]),
        );
      },
    );
  });
}
