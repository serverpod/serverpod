import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group(
      'Given entities with one to many relation nested in a one to one relation',
      () {
    tearDown(() async {
      await Player.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Team.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Arena.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities filtered on filtered every of nested many relation then result is as expected.',
        () async {
      var players = await Player.db.insert(session, [
        Player(name: 'Alex'),
        Player(name: 'Viktor'),
        Player(name: 'Isak'),
        Player(name: 'Anna'),
      ]);

      var arenas = await Arena.db.insert(session, [
        Arena(name: 'Eagle Stadium'),
        Arena(name: 'Bulls Arena'),
        Arena(name: 'Shark Tank'),
        Arena(name: 'Turtle Arena'),
      ]);

      var teams = await Team.db.insert(session, [
        Team(name: 'Eagles', arenaId: arenas[0].id),
        Team(name: 'Bulls', arenaId: arenas[1].id),
        Team(name: 'Sharks', arenaId: arenas[2].id),
        Team(name: 'Turtles', arenaId: arenas[3].id),
      ]);

      // Attach Alex and Viktor to Eagles
      await Team.db.attach.players(session, teams[0], players.sublist(0, 2));
      // Attach Isak to Bulls
      await Team.db.attachRow.players(session, teams[1], players[2]);
      // Attach Anna to Sharks
      await Team.db.attachRow.players(session, teams[2], players[3]);

      var arenasFetched = await Arena.db.find(
        session,
        // Fetch arenas where all players in the team have a name starting with 'a'.
        where: (a) => a.team.players.every((p) => p.name.ilike('a%')),
      );

      var arenaNames = arenasFetched.map((e) => e.name);
      expect(arenaNames, ['Shark Tank']);
    });
  });
}
