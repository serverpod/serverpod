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
      'when deleting models filtered by none many relation then result is as expected',
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

        var deletedIds = await Member.db.deleteWhere(
          session,
          where: (t) => t.blocking.none(),
        );

        expect(deletedIds, containsAll([member[3].id!]));
      },
    );

    test(
      'when deleting models filtered by filtered none many relation then result is as expected',
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

        var deletedIds = await Member.db.deleteWhere(
          session,
          where: (t) => t.blocking.none(
            (c) => c.blockedId.equals(member[0].id!),
          ),
        );

        expect(deletedIds, hasLength(2));
        expect(deletedIds, [member[0].id!, member[3].id!]);
      },
    );

    test(
      'when deleting models filtered by none many relation in combination with other filter then result is as expected',
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

        var deletedIds = await Member.db.deleteWhere(
          session,
          where: (t) => t.blocking.none() | t.name.equals('Member3'),
        );

        expect(deletedIds, hasLength(2));
        expect(deletedIds, containsAll([member[2].id!, member[3].id!]));
      },
    );

    test(
      'when deleting models filtered by multiple filtered none many relation then result is as expected',
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

        var deletedIds = await Member.db.deleteWhere(
          session,
          where: (t) =>
              t.blocking.none((o) => o.blocked.name.ilike('%3')) |
              t.blockedBy.none((o) => o.blockedBy.name.ilike('%1')),
        );

        expect(deletedIds, hasLength(3));
        expect(deletedIds, [member[0].id!, member[2].id!, member[3].id!]);
      },
    );
  });
}
