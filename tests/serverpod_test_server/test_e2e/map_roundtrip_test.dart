import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given a Map with DateTime key', () {
    test(
      'when sent to the server then it is returned correctly.',
      () async {
        var dateTime1 = DateTime.utc(2024, 1, 15, 10, 30);
        var dateTime2 = DateTime.utc(2024, 6, 20, 14, 45);
        var map = {dateTime1: true, dateTime2: false};

        var result = await client.mapParameters.returnDateTimeBoolMap(map);

        expect(result, equals(map));
        expect(result[dateTime1], isTrue);
        expect(result[dateTime2], isFalse);
      },
    );

    test(
      'when an empty map is sent to the server then empty map is returned.',
      () async {
        var map = <DateTime, bool>{};

        var result = await client.mapParameters.returnDateTimeBoolMap(map);

        expect(result, isEmpty);
      },
    );

    test(
      'when a nullable map with value is sent to the server then it is returned correctly.',
      () async {
        var dateTime = DateTime.utc(2024, 3, 10, 8, 0);
        var map = {dateTime: true};

        var result = await client.mapParameters.returnDateTimeBoolMapNullable(
          map,
        );

        expect(result, equals(map));
      },
    );

    test(
      'when a null map is sent to the server then null is returned.',
      () async {
        var result = await client.mapParameters.returnDateTimeBoolMapNullable(
          null,
        );

        expect(result, isNull);
      },
    );
  });

  group('Given a Map with int key', () {
    test(
      'when sent to the server then it is returned correctly.',
      () async {
        var map = {1: 'one', 2: 'two', 3: 'three'};

        var result = await client.mapParameters.returnIntStringMap(map);

        expect(result, equals(map));
        expect(result[1], equals('one'));
        expect(result[2], equals('two'));
        expect(result[3], equals('three'));
      },
    );

    test(
      'when an empty map is sent to the server then empty map is returned.',
      () async {
        var map = <int, String>{};

        var result = await client.mapParameters.returnIntStringMap(map);

        expect(result, isEmpty);
      },
    );

    test(
      'when a nullable map with value is sent to the server then it is returned correctly.',
      () async {
        var map = {42: 'answer'};

        var result = await client.mapParameters.returnIntStringMapNullable(map);

        expect(result, equals(map));
      },
    );

    test(
      'when a null map is sent to the server then null is returned.',
      () async {
        var result = await client.mapParameters.returnIntStringMapNullable(
          null,
        );

        expect(result, isNull);
      },
    );
  });

  group('Given a Map with int key and int value (existing endpoint)', () {
    test(
      'when sent to the server then it is returned correctly.',
      () async {
        var map = {1: 100, 2: 200, 3: 300};

        var result = await client.mapParameters.returnIntIntMap(map);

        expect(result, equals(map));
      },
    );
  });
}
