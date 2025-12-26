import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnGeographyLineString', () {
    var columnName = 'location';
    var table = Table<int?>(tableName: 'lines');
    var column = ColumnGeographyLineString(columnName, table);

    test(
      'when toString is called then column name within double quotes is returned.',
      () {
        expect(column.toString(), '"lines"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then GeographyLineString is returned.', () {
      expect(column.type, GeographyLineString);
    });

    test('when srid is accessed then default 4326 is returned.', () {
      expect(column.srid, 4326);
    });

    test(
      'when ColumnGeographyLineString is created with custom srid then srid is set.',
      () {
        var customSridColumn = ColumnGeographyLineString(
          columnName,
          table,
          srid: 3857,
        );
        expect(customSridColumn.srid, 3857);
      },
    );

    group('when calling crosses with LineString', () {
      test('then ST_Crosses expression is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var expression = column.crosses(line);

        expect(
          expression.toString(),
          contains('ST_Crosses'),
        );
      });
    });

    group('when calling crossesPolygon with Polygon', () {
      test('then ST_Crosses expression is returned.', () {
        var expression = column.crossesPolygon(
          GeographyPolygon([
            [
              const GeographyPoint(-122.4, 37.8),
              const GeographyPoint(-122.3, 37.8),
              const GeographyPoint(-122.3, 37.9),
              const GeographyPoint(-122.4, 37.9),
              const GeographyPoint(-122.4, 37.8),
            ],
          ]),
        );

        expect(
          expression.toString(),
          contains('ST_Crosses'),
        );
      });
    });

    group('when calling intersects with LineString', () {
      test('then ST_Intersects expression is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var expression = column.intersects(line);

        expect(
          expression.toString(),
          contains('ST_Intersects'),
        );
      });
    });

    group('when calling intersectsPolygon with Polygon', () {
      test('then ST_Intersects expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var expression = column.intersectsPolygon(polygon);

        expect(
          expression.toString(),
          contains('ST_Intersects'),
        );
      });
    });

    group('when calling intersectsMultiPolygon with MultiPolygon', () {
      test('then ST_Intersects expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var multiPolygon = GeographyMultiPolygon([polygon]);
        var expression = column.intersectsMultiPolygon(multiPolygon);

        expect(
          expression.toString(),
          contains('ST_Intersects'),
        );
      });
    });

    group('when calling within with Polygon', () {
      test('then ST_Within expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var expression = column.within(polygon);

        expect(
          expression.toString(),
          contains('ST_Within'),
        );
      });
    });

    group('when calling distanceTo with another Point', () {
      test('then ST_Distance ColumnDouble is returned.', () {
        var otherPoint = const GeographyPoint(-122.3, 37.9);
        var distanceColumn = column.distanceTo(otherPoint);

        expect(distanceColumn, isA<ColumnDouble>());
        expect(
          distanceColumn.toString(),
          contains('ST_Distance'),
        );
      });
    });

    group('when calling distanceToLineString with LineString', () {
      test('then ST_Distance ColumnDouble is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var distanceColumn = column.distanceToLineString(line);

        expect(distanceColumn, isA<ColumnDouble>());
        expect(
          distanceColumn.toString(),
          contains('ST_Distance'),
        );
      });
    });

    group('when calling isWithinBounds with bounding box coordinates', () {
      test('then bounding box expression is returned.', () {
        var expression = column.isWithinBounds(-122.4, 37.8, -122.3, 37.9);

        expect(
          expression.toString(),
          contains('ST_MakeEnvelope'),
        );
        expect(
          expression.toString(),
          contains('&&'),
        );
      });

      test('then bounding box expression contains correct SRID.', () {
        var expression = column.isWithinBounds(-122.4, 37.8, -122.3, 37.9);

        expect(
          expression.toString(),
          contains('4326'),
        );
      });

      test('then bounding box expression contains all coordinates.', () {
        var expression = column.isWithinBounds(-122.4, 37.8, -122.3, 37.9);
        var expressionStr = expression.toString();

        expect(expressionStr, contains('-122.4'));
        expect(expressionStr, contains('37.8'));
        expect(expressionStr, contains('-122.3'));
        expect(expressionStr, contains('37.9'));
      });
    });

    group('when calling isEmpty', () {
      test('then ST_IsEmpty expression is returned.', () {
        var expression = column.isEmpty();

        expect(
          expression.toString(),
          contains('ST_IsEmpty'),
        );
      });
    });

    group('when calling isClosed', () {
      test('then ST_IsClosed expression is returned.', () {
        var expression = column.isClosed();
        expect(
          expression.toString(),
          contains('ST_IsClosed'),
        );
      });
    });

    group('when calling isRing', () {
      test('then ST_IsRing expression is returned.', () {
        var expression = column.isRing();
        expect(
          expression.toString(),
          contains('ST_IsRing'),
        );
      });
    });

    group('when calling isSimple', () {
      test('then ST_IsSimple expression is returned.', () {
        var expression = column.isSimple();
        expect(
          expression.toString(),
          contains('ST_IsSimple'),
        );
      });
    });

    group('when calling length', () {
      test('then ST_Length ColumnDouble is returned.', () {
        var expression = column.length();
        expect(
          expression.toString(),
          contains('ST_Length'),
        );
      });
    });
  });
}
