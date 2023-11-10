import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with one to one relation', () {
    tearDown(() async {
      await Post.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
      'when fetching entities ordered by relation attributes then result is as expected.',
      () async {
        var post = await Post.db.insert(
          session,
          [
            Post(content: '2 Hello world!'),
            Post(content: '3 Hello a third time!'),
            Post(content: '1 Hello again!'),
          ],
        );
        await Post.db.attachRow.next(session, post[0], post[1]);
        await Post.db.attachRow.next(session, post[1], post[2]);

        var postsFetched = await Post.db.find(
          session,
          orderBy: (t) => t.next.content,
        );

        expect(postsFetched[0].content, '3 Hello a third time!'); // next is 1
        expect(postsFetched[1].content, '2 Hello world!'); // next is 3
        expect(postsFetched[2].content, '1 Hello again!'); // next is null
      },
    );
  });

  group('Given entities with nested one to one relations', () {
    tearDown(() async {
      await Post.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities ordered by nested relation attributes then result is as expected.',
        () async {
      var post = await Post.db.insert(
        session,
        [
          Post(content: '2 Hello world!'),
          Post(content: '3 Hello a third time!'),
          Post(content: '1 Hello again!'),
        ],
      );
      await Post.db.attachRow.next(session, post[0], post[1]);
      await Post.db.attachRow.next(session, post[1], post[2]);

      var postsFetched = await Post.db.find(
        session,
        orderByList: (t) => [
          db.Order(column: t.next.next.content),
          db.Order(column: t.content),
        ],
      );

      expect(postsFetched[0].content, '2 Hello world!'); // next.next is 1
      expect(postsFetched[1].content, '1 Hello again!'); // next.next is null
      expect(postsFetched[2].content,
          '3 Hello a third time!'); // next.next is null
    });
  });
}
