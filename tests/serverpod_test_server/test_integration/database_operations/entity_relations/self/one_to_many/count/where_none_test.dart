import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation ', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when counting models filtered on none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Kitten2', motherId: zelda.id),
          Cat(name: 'Kitten3', motherId: smulan.id),
        ]);

        var catCount = await Cat.db.count(
          session,
          where: (t) => t.kittens.none(),
        );

        expect(catCount, 3);
      },
    );

    test(
      'when counting models filtered on filtered none many relation then result is as expected',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Smulan III', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var catCount = await Cat.db.count(
          session,
          where: (t) => t.kittens.none((t) => t.name.ilike('smul%')),
        );

        expect(catCount, 2);
      },
    );

    test(
      'when counting models filtered on multiple none many relation then result is as expected.',
      () async {
        var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
        var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

        await Cat.db.insert(session, [
          Cat(name: 'Kitten1', motherId: zelda.id),
          Cat(name: 'Smulan II', motherId: smulan.id),
        ]);

        var catCount = await Cat.db.count(
          session,
          where: (t) =>
              t.kittens.none((o) => o.name.ilike('kitt%')) &
              t.kittens.none((o) => o.name.ilike('smul%')),
        );

        expect(catCount, 2);
      },
    );
  });

  group('Given models with nested one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when counting models filtered on nested none many relation then result is as expected',
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

        var catCount = await Cat.db.count(
          session,
          where: (t) => t.kittens.none((o) => o.kittens.none()),
        );

        expect(catCount, 3);
      },
    );

    test(
      'when counting models filtered on filtered nested none many relation then result is as expected',
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

        var catCount = await Cat.db.count(
          session,
          where: (t) => t.kittens.none(
            (o) => o.kittens.none((o) => o.name.ilike('kitt%')),
          ),
        );

        expect(catCount, 3);
      },
    );
  });
}
