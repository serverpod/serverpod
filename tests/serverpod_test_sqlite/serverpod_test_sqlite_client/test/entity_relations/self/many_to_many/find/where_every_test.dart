import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with many to many relation', () {
    test(
      'when fetching models filtered by every many relation then result is as expected',
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
          where: (t) => t.blocking.every(
            (c) => c.blockedId.equals(member[0].id!),
          ),
        );

        var memberNames = fetchedMembers.map((e) => e.name);

        expect(memberNames, ['Member3']);
      },
    );

    test(
      'when fetching models filtered by every many relation in combination with other filter then result is as expected',
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

        var fetchedMembers = await Member.db.find(
          session,
          where: (t) =>
              t.blocking.every((o) => o.blockedBy.name.equals('Member1')) |
              t.name.equals('Member3'),
        );

        var memberNames = fetchedMembers.map((e) => e.name);

        expect(memberNames, hasLength(2));
        expect(memberNames, containsAll(['Member1', 'Member3']));
      },
    );

    test(
      'when fetching models filtered by multiple every many relation then result is as expected',
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
          where: (t) =>
              t.blocking.every((o) => o.blockedBy.name.equals('Member1')) |
              t.blocking.every((o) => o.blockedBy.name.equals('Member2')),
        );

        var memberNames = fetchedMembers.map((e) => e.name);

        expect(memberNames, hasLength(2));
        expect(memberNames, ['Member1', 'Member2']);
      },
    );
  });
}
