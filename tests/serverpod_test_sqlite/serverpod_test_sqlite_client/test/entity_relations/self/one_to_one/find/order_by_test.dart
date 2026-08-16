import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with one to one relation', () {
    test(
      'when fetching models ordered by relation attributes then result is as expected.',
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

  group('Given models with nested one to one relations', () {
    test(
      'when fetching models ordered by nested relation attributes then result is as expected.',
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
            t.next.next.content.asc(),
            t.content.asc(),
          ],
        );

        expect(postsFetched[0].content, '2 Hello world!'); // next.next is 1
        expect(postsFetched[1].content, '1 Hello again!'); // next.next is null
        expect(
          postsFetched[2].content,
          '3 Hello a third time!',
        ); // next.next is null
      },
    );
  });
}
