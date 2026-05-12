import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with one to many relation nested in a one to one relation', () {
    test(
      'when counting models filtered on any nested many relation then result is as expected.',
      () async {
        var players = await Player.db.insert(session, [
          Player(name: 'Alex'),
          Player(name: 'Viktor'),
          Player(name: 'Isak'),
        ]);

        var arenas = await Arena.db.insert(session, [
          Arena(name: 'Eagle Stadium'),
          Arena(name: 'Bulls Arena'),
          Arena(name: 'Shark Tank'),
        ]);

        var teams = await Team.db.insert(session, [
          Team(name: 'Eagles', arenaId: arenas[0].id),
          Team(name: 'Bulls', arenaId: arenas[1].id),
          Team(name: 'Sharks', arenaId: arenas[2].id),
        ]);

        // Attach Alex and Viktor to Eagles
        await Team.db.attach.players(session, teams[0], players.sublist(0, 2));
        // Attach Isak to Bulls
        await Team.db.attachRow.players(session, teams[1], players[2]);

        var numberOfArenas = await Arena.db.count(
          session,
          // Count all arenas with teams that have any player.
          where: (a) => a.team.players.any(),
        );

        expect(numberOfArenas, 2);
      },
    );

    test(
      'when fetching models filtered on filtered any nested many relation then result is as expected.',
      () async {
        var players = await Player.db.insert(session, [
          Player(name: 'Alex'),
          Player(name: 'Viktor'),
          Player(name: 'Isak'),
        ]);

        var arenas = await Arena.db.insert(session, [
          Arena(name: 'Eagle Stadium'),
          Arena(name: 'Bulls Arena'),
          Arena(name: 'Shark Tank'),
        ]);

        var teams = await Team.db.insert(session, [
          Team(name: 'Eagles', arenaId: arenas[0].id),
          Team(name: 'Bulls', arenaId: arenas[1].id),
          Team(name: 'Sharks', arenaId: arenas[2].id),
        ]);

        // Attach Alex and Viktor to Eagles
        await Team.db.attach.players(session, teams[0], players.sublist(0, 2));
        // Attach Isak to Bulls
        await Team.db.attachRow.players(session, teams[1], players[2]);

        var numberOfArenas = await Arena.db.count(
          session,
          // Count all arenas with teams that have any player with a name starting with a.
          where: (a) => a.team.players.any((p) => p.name.ilike('a%')),
        );

        expect(numberOfArenas, 1);
      },
    );
  });
}
