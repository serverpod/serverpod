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
        'when fetching entities including relation then result includes relation data.',
        () async {
      var post = await Post.db.insert(
        session,
        [
          Post(content: 'Hello world!'),
          Post(content: 'Hello again!'),
          Post(content: 'Hello a third time!'),
        ],
      );
      await Post.db.attachRow.next(session, post[0], post[1]);
      await Post.db.attachRow.next(session, post[1], post[2]);

      var postsFetched = await Post.db.find(
        session,
        include: Post.include(next: Post.include()),
        orderBy: (t) => t.id,
      );

      expect(postsFetched[0].next?.content, 'Hello again!');
      expect(postsFetched[1].next?.content, 'Hello a third time!');
      expect(postsFetched[2].next, isNull);
    });
  });

  group('Given entities with nested one to one relations', () {
    tearDown(() async {
      await Post.db.deleteWhere(session, where: (_) => db.Constant.bool(true));
    });

    test(
        'when fetching entities including nested relation then result includes nested relation data.',
        () async {
      var post = await Post.db.insert(
        session,
        [
          Post(content: 'Hello world!'),
          Post(content: 'Hello again!'),
          Post(content: 'Hello a third time!'),
        ],
      );
      await Post.db.attachRow.next(session, post[0], post[1]);
      await Post.db.attachRow.next(session, post[1], post[2]);

      var postsFetched = await Post.db.find(
        session,
        include: Post.include(next: Post.include(next: Post.include())),
        orderBy: (t) => t.id,
      );

      expect(postsFetched[0].next?.next?.content, 'Hello a third time!');
      expect(postsFetched[1].next?.next?.content, isNull);
    });
  });
}
