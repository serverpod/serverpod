import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class ManyToManyEndpoint extends Endpoint {
  Future<List<Posts>> findAllNonBlockedPosts(
    Session session, {
    required Author reader,
  }) async {
    return await Posts.find(
      session,
      where: (t) => t.author.blockedBy((b) => b.blockeeId.notEquals(reader.id)),
    );
  }

  Future<int> countAllNonBlockedPosts(
    Session session, {
    required Author reader,
  }) async {
    return await Posts.count(
      session,
      where: (t) => t.author.blockedBy((b) => b.blockeeId.notEquals(reader.id)),
    );
  }

  Future<int?> postInsert(Session session, Posts post) async {
    await Posts.insert(session, post);
    return post.id;
  }

  Future<int?> authorInsert(Session session, Author author) async {
    await Author.insert(session, author);
    return author.id;
  }

  Future<int?> blockedInsert(Session session, Blocked blocked) async {
    await Blocked.insert(session, blocked);
    return blocked.id;
  }

  Future<int> deleteAll(Session session) async {
    var postDeletions =
        await Posts.delete(session, where: (_) => Constant.bool(true));
    var authorDeletions =
        await Author.delete(session, where: (_) => Constant.bool(true));
    var blockedDeletions =
        await Blocked.delete(session, where: (_) => Constant.bool(true));

    return postDeletions + authorDeletions + blockedDeletions;
  }
}
