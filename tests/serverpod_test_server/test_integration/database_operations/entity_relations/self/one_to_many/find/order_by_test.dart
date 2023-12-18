import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod/database.dart' as db;
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with one to many relation', () {
    tearDown(() async {
      await Cat.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching models ordered on count of many relation then result is as expected.',
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
        // Order by number of kittens in descending order
        orderByList: (t) => [
          db.Order(column: t.kittens.count(), orderDescending: true),
          db.Order(column: t.name),
        ],
        orderDescending: true,
      );

      var catNames = fetchedCats.map((e) => e.name);
      expect(
        catNames,
        ['Zelda', 'Smulan', 'Kitten1', 'Kitten2', 'Kitten3', 'Kitten4'],
      );
    });

    test(
        'when fetching models ordered on count of filtered many relation then result is as expected.',
        () async {
      var zelda = await Cat.db.insertRow(session, Cat(name: 'Zelda'));
      var smulan = await Cat.db.insertRow(session, Cat(name: 'Smulan'));

      await Cat.db.insert(session, [
        Cat(name: 'Kitten1', motherId: zelda.id),
        Cat(name: 'Smulan II', motherId: smulan.id),
      ]);

      var fetchedCats = await Cat.db.find(
        session,
        // Order by number of kittens named Smul... in descending order
        orderBy: (t) => t.kittens.count((k) => k.name.ilike('smul%')),
        orderDescending: true,
      );

      var catNames = fetchedCats.map((e) => e.name);
      expect(catNames, ['Smulan', 'Zelda', 'Kitten1', 'Smulan II']);
    });
  });
}
