import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with one to many relation nested in a one to one relation', () {
    test(
      'when deleting models filtered on none of nested many relation then result is as expected.',
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

        var deletedArenas = await Arena.db.deleteWhere(
          session,
          // Delete all arenas with teams that have no players.
          where: (a) => a.team.players.none(),
        );

        expect(deletedArenas, hasLength(1));
        expect(
          deletedArenas.firstOrNull?.id,
          arenas[2].id, // Shark Tank
        );
      },
    );

    test(
      'when deleting models filtered on filtered none of nested many relation then result is as expected.',
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

        var deletedArenas = await Arena.db.deleteWhere(
          session,
          // Delete all arenas with teams that have no players with a name starting with a.
          where: (a) => a.team.players.none((p) => p.name.ilike('a%')),
        );

        expect(deletedArenas, hasLength(2));
        var deletedArenaIds = deletedArenas.map((c) => c.id).toList();
        expect(
          deletedArenaIds,
          containsAll([
            arenas[1].id, // Bulls Arena
            arenas[2].id, // Shark Tank
          ]),
        );
      },
    );
  });
}
