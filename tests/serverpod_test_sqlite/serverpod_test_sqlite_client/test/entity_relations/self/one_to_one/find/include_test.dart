import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with one to one relation', () {
    test(
      'when fetching models including relation then result includes relation data.',
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
      },
    );
  });

  group('Given models with nested one to one relations', () {
    test(
      'when fetching models including nested relation then result includes nested relation data.',
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
      },
    );
  });
}
