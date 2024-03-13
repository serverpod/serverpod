import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with many to many relation', () {
    tearDown(() async {
      await Member.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Blocking.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    test(
        'when counting models filtered on many relation count then result is as expected',
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

      var count =
          await Member.db.count(session, where: (t) => t.blocking.count() > 1);

      expect(count, 2);
    });

    test(
      'when counting models filtered on filtered many relation count then result is as expected',
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

        var count = await Member.db.count(
          session,
          where: (t) => t.blocking
              .count(
                (c) => c.blockedId.equals(member[0].id!),
              )
              .equals(1),
        );

        expect(count, 2);
      },
    );

    test(
      'when counting models filtered on many relation count in combination with other filter then result is as expected',
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
        ]);

        var count = await Member.db.count(
          session,
          where: (t) => (t.blocking.count() > 1) | t.name.equals('Member3'),
        );

        expect(count, 3);
      },
    );

    test(
      'when counting models filtered on multiple many relation count then result is as expected',
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

        var count = await Member.db.count(
          session,
          where: (t) => (t.blocking.count() > 1) & (t.blocking.count() < 3),
        );

        expect(count, 1);
      },
    );

    test(
      'when counting models filtered on multiple filtered many relation count then result is as expected',
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

        var count = await Member.db.count(
          session,
          where: (t) =>
              t.blocking.count((o) => o.blocked.name.ilike('%3')).equals(1) &
              t.blockedBy.count((o) => o.blockedBy.name.ilike('%1')).equals(1),
        );

        expect(count, 1);
      },
    );
  });
}
