import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test('Given a serverOnly model with a List field of another serverOnly model '
      'when deserializing the container model from json'
      'then deserialization should succeed.', () {
    var json = {
      'results': [
        {'name': 'Article 1', 'price': 10.0},
        {'name': 'Article 2', 'price': 20.0},
      ],
    };

    var articleList = Protocol().deserialize<ArticleList>(json);

    expect(articleList, isA<ArticleList>());
    expect(articleList.results.length, 2);
    expect(articleList.results[0].name, 'Article 1');
    expect(articleList.results[0].price, 10.0);
  });

  test('Given a list of serverOnly models '
      'when deserializing the list directly from json '
      'then deserialization should succeed.', () {
    var json = [
      {'name': 'Article 1', 'price': 10.0},
      {'name': 'Article 2', 'price': 20.0},
    ];

    var articles = Protocol().deserialize<List<Article>>(json);

    expect(articles, isA<List<Article>>());
    expect(articles.length, 2);
    expect(articles[0].name, 'Article 1');
    expect(articles[0].price, 10.0);
  });

  test('Given a serverOnly model with a List field of another serverOnly model '
      'when encoding the container model to json '
      'then serialization should succeed.', () {
    var articleList = ArticleList(
      results: [
        Article(name: 'Article 1', price: 10.0),
        Article(name: 'Article 2', price: 20.0),
      ],
    );

    var json = articleList.toJson();
    var results = json['results'];

    expect(results, isA<List>());
    results as List;
    expect(results.length, 2);
    expect(results[0]['name'], 'Article 1');
    expect(results[0]['price'], 10.0);
  });
}
