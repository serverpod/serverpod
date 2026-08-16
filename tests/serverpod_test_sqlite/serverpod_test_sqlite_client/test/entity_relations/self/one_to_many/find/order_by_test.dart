import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with one to many relation', () {
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
            t.kittens.count().desc(),
            t.name.asc(),
          ],
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(
          catNames,
          ['Zelda', 'Smulan', 'Kitten1', 'Kitten2', 'Kitten3', 'Kitten4'],
        );
      },
    );

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
          orderBy: (t) => t.kittens.count((k) => k.name.ilike('smul%')).desc(),
        );

        var catNames = fetchedCats.map((e) => e.name);
        expect(catNames, ['Smulan', 'Zelda', 'Kitten1', 'Smulan II']);
      },
    );
  });
}
