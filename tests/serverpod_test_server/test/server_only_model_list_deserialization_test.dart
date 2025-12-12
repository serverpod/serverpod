import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given a serverOnly model with a List field of another serverOnly model',
      () {
    test(
        'when deserializing ArticleList on server then deserialization should succeed.',
        () {
      var json = {
        'results': [
          {'name': 'Article 1', 'price': 10.0},
          {'name': 'Article 2', 'price': 20.0},
        ]
      };

      // This should NOT throw DeserializationTypeNotFoundException
      var articleList = Protocol().deserialize<ArticleList>(json);

      expect(articleList, isA<ArticleList>());
      expect(articleList.results.length, 2);
      expect(articleList.results[0].name, 'Article 1');
      expect(articleList.results[0].price, 10.0);
    });

    test('when deserializing List<Article> directly then deserialization should succeed.',
        () {
      var json = [
        {'name': 'Article 1', 'price': 10.0},
        {'name': 'Article 2', 'price': 20.0},
      ];

      // This should NOT throw DeserializationTypeNotFoundException
      var articles = Protocol().deserialize<List<Article>>(json);

      expect(articles, isA<List<Article>>());
      expect(articles.length, 2);
      expect(articles[0].name, 'Article 1');
      expect(articles[0].price, 10.0);
    });

    test('when encoding ArticleList on server then serialization should succeed.',
        () {
      var articleList = ArticleList(
        results: [
          Article(name: 'Article 1', price: 10.0),
          Article(name: 'Article 2', price: 20.0),
        ],
      );

      var json = articleList.toJson();

      expect(json['results'], isA<List>());
      expect(json['results'].length, 2);
      expect(json['results'][0]['name'], 'Article 1');
      expect(json['results'][0]['price'], 10.0);
    });
  });
}
