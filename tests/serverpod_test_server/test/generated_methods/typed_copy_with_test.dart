import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given absent nullable fields, '
    'when copying without arguments, '
    'then no undefined sentinel becomes a serialized value.',
    () {
      final original = Types();

      final copy = original.copyWith();

      expect(copy.toJson(), original.toJson());
    },
  );

  group('Given a populated nullable model field,', () {
    late ObjectWithObject original;

    setUp(() {
      original = ObjectWithObject(
        data: SimpleData(num: 1),
        nullableData: SimpleData(num: 2),
        dataList: [],
        listWithNullableData: [],
      );
    });

    test(
      'when copying without an argument and mutating the source, '
      'then the copied model retains its own value.',
      () {
        final copy = original.copyWith();
        original.nullableData!.num = 3;

        expect(copy.nullableData!.num, 2);
        expect(copy.nullableData, isNot(same(original.nullableData)));
      },
    );

    test(
      'when copying with explicit null, '
      'then only the copied field is cleared.',
      () {
        final copy = original.copyWith(nullableData: null);

        expect(copy.nullableData, isNull);
        expect(original.nullableData!.num, 2);
      },
    );

    test(
      'when copying with a replacement model, '
      'then only the copy receives the replacement value.',
      () {
        final copy = original.copyWith(nullableData: SimpleData(num: 4));

        expect(copy.nullableData!.num, 4);
        expect(original.nullableData!.num, 2);
      },
    );

    test(
      'when a dynamic caller supplies the wrong model type, '
      'then copyWith rejects the argument.',
      () {
        final dynamic dynamicOriginal = original;

        expect(
          () => dynamicOriginal.copyWith(nullableData: Types()),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('Given populated nullable dates, UUIDs, durations and URIs,', () {
    late Types original;

    setUp(() {
      original = Types(
        aDateTime: DateTime.utc(2026, 1, 1),
        aUuid: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
        aDuration: const Duration(seconds: 1),
        aUri: Uri.parse('https://serverpod.dev'),
      );
    });

    test(
      'when copying without arguments, '
      'then all original values survive serialization.',
      () {
        final copy = original.copyWith();

        expect(copy.toJson(), original.toJson());
      },
    );

    test(
      'when copying with explicit nulls, '
      'then all specified fields are cleared.',
      () {
        final copy = original.copyWith(
          aDateTime: null,
          aUuid: null,
          aDuration: null,
          aUri: null,
        );

        expect(copy.aDateTime, isNull);
        expect(copy.aUuid, isNull);
        expect(copy.aDuration, isNull);
        expect(copy.aUri, isNull);
      },
    );

    test(
      'when copying with epoch, nil, zero and empty values, '
      'then legitimate values replace the originals.',
      () {
        final date = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final uuid = UuidValue.fromString(
          '00000000-0000-0000-0000-000000000000',
        );
        final uri = Uri();

        final copy = original.copyWith(
          aDateTime: date,
          aUuid: uuid,
          aDuration: Duration.zero,
          aUri: uri,
        );

        expect(copy.aDateTime, date);
        expect(copy.aUuid, uuid);
        expect(copy.aDuration, Duration.zero);
        expect(copy.aUri, uri);
      },
    );

    test(
      'when a dynamic caller supplies an invalid date, '
      'then copyWith rejects the argument.',
      () {
        final dynamic dynamicOriginal = original;

        expect(
          () => dynamicOriginal.copyWith(aDateTime: 'invalid'),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('Given populated nullable vector and geography fields,', () {
    late Types original;

    setUp(() {
      const point = GeographyPoint(longitude: 1, latitude: 2);
      const otherPoint = GeographyPoint(longitude: 3, latitude: 4);

      original = Types(
        aVector: const Vector([1, 2, 3]),
        aHalfVector: const HalfVector([1, 2, 3]),
        aSparseVector: SparseVector([1, 0, 3]),
        aBit: Bit([true, false, true]),
        aGeographyPoint: point,
        aGeographyLineString: const GeographyLineString(
          points: [point, otherPoint],
        ),
        aGeographyPolygon: const GeographyPolygon(
          exteriorRing: [
            point,
            otherPoint,
            GeographyPoint(longitude: 5, latitude: 2),
            point,
          ],
        ),
        aGeographyGeometryCollection: const GeographyGeometryCollection(
          geometries: [point],
        ),
      );
    });

    test(
      'when copying without arguments, '
      'then all values survive serialization and vectors are cloned.',
      () {
        final copy = original.copyWith();

        expect(copy.toJson(), original.toJson());
        expect(copy.aVector, isNot(same(original.aVector)));
        expect(copy.aHalfVector, isNot(same(original.aHalfVector)));
        expect(copy.aSparseVector, isNot(same(original.aSparseVector)));
        expect(copy.aBit, isNot(same(original.aBit)));
      },
    );

    test(
      'when copying with explicit nulls, '
      'then all specified fields are cleared.',
      () {
        final copy = original.copyWith(
          aVector: null,
          aHalfVector: null,
          aSparseVector: null,
          aBit: null,
          aGeographyPoint: null,
          aGeographyLineString: null,
          aGeographyPolygon: null,
          aGeographyGeometryCollection: null,
        );

        expect(copy.toJson(), Types().toJson());
      },
    );

    test(
      'when copying with zero and empty values, '
      'then legitimate values replace the originals.',
      () {
        final replacement = Types(
          aVector: const Vector([0, 0, 0]),
          aHalfVector: const HalfVector([0, 0, 0]),
          aSparseVector: SparseVector([0, 0, 0]),
          aBit: Bit([false, false, false]),
          aGeographyPoint: const GeographyPoint(longitude: 0, latitude: 0),
          aGeographyLineString: const GeographyLineString(points: []),
          aGeographyPolygon: const GeographyPolygon(exteriorRing: []),
          aGeographyGeometryCollection: const GeographyGeometryCollection(
            geometries: [],
          ),
        );

        final copy = original.copyWith(
          aVector: replacement.aVector,
          aHalfVector: replacement.aHalfVector,
          aSparseVector: replacement.aSparseVector,
          aBit: replacement.aBit,
          aGeographyPoint: replacement.aGeographyPoint,
          aGeographyLineString: replacement.aGeographyLineString,
          aGeographyPolygon: replacement.aGeographyPolygon,
          aGeographyGeometryCollection:
              replacement.aGeographyGeometryCollection,
        );

        expect(copy.toJson(), replacement.toJson());
      },
    );

    test(
      'when a dynamic caller supplies invalid field types, '
      'then copyWith rejects each argument.',
      () {
        final dynamic dynamicOriginal = original;

        expect(
          () => dynamicOriginal.copyWith(aVector: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aHalfVector: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aSparseVector: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aBit: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aGeographyPoint: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aGeographyLineString: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () => dynamicOriginal.copyWith(aGeographyPolygon: 'invalid'),
          throwsA(isA<TypeError>()),
        );
        expect(
          () =>
              dynamicOriginal.copyWith(aGeographyGeometryCollection: 'invalid'),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('Given populated nullable lists, maps and sets,', () {
    late Types original;

    setUp(() {
      original = Types(aList: [1], aMap: {1: 2}, aSet: {3});
    });

    test(
      'when copying without arguments and mutating the source, '
      'then each collection is independently preserved.',
      () {
        final copy = original.copyWith();
        original.aList!.clear();
        original.aMap!.clear();
        original.aSet!.clear();

        expect(copy.aList, [1]);
        expect(copy.aMap, {1: 2});
        expect(copy.aSet, {3});
      },
    );

    test(
      'when copying with explicit nulls, '
      'then all specified collections are cleared.',
      () {
        final copy = original.copyWith(aList: null, aMap: null, aSet: null);

        expect(copy.aList, isNull);
        expect(copy.aMap, isNull);
        expect(copy.aSet, isNull);
      },
    );

    test(
      'when copying with empty collections, '
      'then the replacements are retained as real values.',
      () {
        final copy = original.copyWith(aList: [], aMap: {}, aSet: {});

        expect(copy.aList, isEmpty);
        expect(copy.aMap, isEmpty);
        expect(copy.aSet, isEmpty);
      },
    );

    test(
      'when a dynamic caller supplies the wrong element type, '
      'then copyWith rejects the collection.',
      () {
        final dynamic dynamicOriginal = original;

        expect(
          () => dynamicOriginal.copyWith(aList: <String>['invalid']),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  test(
    'Given nullable collections containing nested models, '
    'when copying without arguments and mutating source models, '
    'then every nested model is deeply copied.',
    () {
      final lists = TypesList(
        aList: [
          [Types(anInt: 1)],
        ],
      );
      final maps = TypesMap(
        aListValue: {
          'key': [Types(anInt: 2)],
        },
      );
      final sets = TypesSet(anObject: {Types(anInt: 3)});

      final listCopy = lists.copyWith();
      final mapCopy = maps.copyWith();
      final setCopy = sets.copyWith();
      lists.aList!.single.single.anInt = 4;
      maps.aListValue!['key']!.single.anInt = 5;
      sets.anObject!.single.anInt = 6;

      expect(listCopy.aList!.single.single.anInt, 1);
      expect(mapCopy.aListValue!['key']!.single.anInt, 2);
      expect(setCopy.anObject!.single.anInt, 3);
    },
  );

  group('Given a nullable relation to a model from an imported module,', () {
    late ObjectUser original;

    setUp(() {
      original = ObjectUser(
        userInfoId: 1,
        userInfo: auth.UserInfo(
          id: 1,
          userIdentifier: 'user',
          created: DateTime.utc(2026),
          scopeNames: ['read'],
          blocked: false,
        ),
      );
    });

    test(
      'when copying without an argument and mutating the source relation, '
      'then its nested collection is deeply copied.',
      () {
        final copy = original.copyWith();
        original.userInfo!.scopeNames.clear();

        expect(copy.userInfo!.scopeNames, ['read']);
        expect(copy.userInfoId, 1);
      },
    );

    test(
      'when copying with explicit null, '
      'then the relation is cleared while its foreign key is preserved.',
      () {
        final copy = original.copyWith(userInfo: null);

        expect(copy.userInfo, isNull);
        expect(copy.userInfoId, 1);
      },
    );

    test(
      'when a dynamic caller supplies a different model, '
      'then copyWith rejects the relation argument.',
      () {
        final dynamic dynamicOriginal = original;

        expect(
          () => dynamicOriginal.copyWith(userInfo: SimpleData(num: 1)),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
