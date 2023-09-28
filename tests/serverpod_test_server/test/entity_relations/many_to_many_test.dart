import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import '../config.dart';

Future<void> _createTestDatabase(Client client, Author alex) async {
  // Authors

  var author2 = Author(name: 'Isak');
  var author3 = Author(name: 'Viktor');

  alex.id = await client.manyToMany.authorInsert(alex);
  author2.id = await client.manyToMany.authorInsert(author2);
  author3.id = await client.manyToMany.authorInsert(author3);

  // Posts

  var post1 = Posts(text: 'Post 1', authorId: alex.id!);
  var post2 = Posts(text: 'Post 2', authorId: alex.id!);
  var post3 = Posts(text: 'Post 3', authorId: alex.id!);

  var post4 = Posts(text: 'Post 4', authorId: author2.id!);
  var post5 = Posts(text: 'Post 5', authorId: author2.id!);
  var post6 = Posts(text: 'Post 6', authorId: author2.id!);

  var post7 = Posts(text: 'Post 7', authorId: author3.id!);
  var post8 = Posts(text: 'Post 8', authorId: author3.id!);
  var post9 = Posts(text: 'Post 9', authorId: author3.id!);

  post1.id = await client.manyToMany.postInsert(post1);
  post2.id = await client.manyToMany.postInsert(post2);
  post3.id = await client.manyToMany.postInsert(post3);

  post4.id = await client.manyToMany.postInsert(post4);
  post5.id = await client.manyToMany.postInsert(post5);
  post6.id = await client.manyToMany.postInsert(post6);

  post7.id = await client.manyToMany.postInsert(post7);
  post8.id = await client.manyToMany.postInsert(post8);
  post9.id = await client.manyToMany.postInsert(post9);

  // Blocked
  // Alex blocks Isak
  var blocked = Blocked(blockeeId: alex.id!, blockerId: author2.id!);
  await client.manyToMany.blockedInsert(blocked);
}

void main() async {
  var alex = Author(name: 'Alex');
  var client = Client(serverUrl);

  group(
      'Given entities with many relations when filtering on number of many relations',
      () {
    late var allUnblockedPostsForAlex;
    setUpAll(() async {
      await _createTestDatabase(client, alex);
      allUnblockedPostsForAlex =
          await client.manyToMany.findAllNonBlockedPosts(reader: alex);
    });

    tearDownAll(() async => await client.manyToMany.deleteAll());

    test('all posts that are not authored someone blocked by Alex', () {
      var postTexts = allUnblockedPostsForAlex.map((e) => e.text);
      expect(
          postTexts,
          containsAll(
              ['Post 1', 'Post 2', 'Post 3', 'Post 7', 'Post 8', 'Post 9']));
    });
  });

  group(
      'Given entities with many relations when filtering and counting number of many relations',
      () {
    late var numberOfUnblockedPostsForAlex;
    setUpAll(() async {
      await _createTestDatabase(client, alex);
      numberOfUnblockedPostsForAlex =
          await client.manyToMany.countAllNonBlockedPosts(reader: alex);
    });

    tearDownAll(() async => await client.manyToMany.deleteAll());

    test('all posts that are not authored someone blocked by Alex', () {
      expect(numberOfUnblockedPostsForAlex, 6);
    });
  });
}
