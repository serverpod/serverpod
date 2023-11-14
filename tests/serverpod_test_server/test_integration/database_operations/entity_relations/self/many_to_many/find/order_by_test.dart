import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with many to many relation', () {
    tearDown(() async {
      await Member.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
      await Blocking.db
          .deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when fetching entities ordered on count of many relation then result is as expected',
      () async {
        var member = await Member.db.insert(session, [
          Member(name: 'Member1'),
          Member(name: 'Member2'),
          Member(name: 'Member3'),
          Member(name: 'Member4'),
        ]);

        await Blocking.db.insert(session, [
          // Member1
          Blocking(blockedById: member[0].id!, blockedId: member[1].id!),
          Blocking(blockedById: member[0].id!, blockedId: member[2].id!),
          Blocking(blockedById: member[0].id!, blockedId: member[3].id!),

          // Member2
          Blocking(blockedById: member[1].id!, blockedId: member[0].id!),
          Blocking(blockedById: member[1].id!, blockedId: member[2].id!),

          // Member3
          Blocking(blockedById: member[2].id!, blockedId: member[0].id!),
        ]);

        var fetchedMembers = await Member.db.find(
          session,
          orderBy: (t) => t.blocking.count(),
        );

        var memberNames = fetchedMembers.map((e) => e.name);

        expect(memberNames, ['Member4', 'Member3', 'Member2', 'Member1']);
      },
    );

    test(
        'when fetching entities ordered on filtered count of many relation then result is as expected',
        () async {
      var member = await Member.db.insert(session, [
        Member(name: 'Member1'),
        Member(name: 'Member2'),
        Member(name: 'Member3'),
        Member(name: 'Member4'),
      ]);

      await Blocking.db.insert(session, [
        // Member1
        Blocking(blockedById: member[0].id!, blockedId: member[1].id!),
        Blocking(blockedById: member[0].id!, blockedId: member[2].id!),
        Blocking(blockedById: member[0].id!, blockedId: member[3].id!),

        // Member2
        Blocking(blockedById: member[1].id!, blockedId: member[0].id!),
        Blocking(blockedById: member[1].id!, blockedId: member[2].id!),

        // Member3
        Blocking(blockedById: member[2].id!, blockedId: member[0].id!),
      ]);

      var fetchedMembers = await Member.db.find(
        session,
        orderByList: (t) => [
          db.Order(
            column: t.blocking.count(
              (c) => c.blockedId.equals(member[0].id!),
            ),
          ),
          db.Order(
            column: t.name,
          )
        ],
      );

      var memberNames = fetchedMembers.map((e) => e.name);

      expect(memberNames, ['Member1', 'Member4', 'Member2', 'Member3']);
    });
  });
}
