import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ColumnGeographyMultiPolygon', () {
    var columnName = 'location';
    var table = Table<int?>(tableName: 'shapes');
    var column = ColumnGeographyMultiPolygon(columnName, table);

    test(
      'when toString is called then column name within double quotes is returned.',
      () {
        expect(column.toString(), '"shapes"."$columnName"');
      },
    );

    test('when columnName getter is called then column name is returned.', () {
      expect(column.columnName, columnName);
    });

    test('when type is called then GeographyMultiPolygon is returned.', () {
      expect(column.type, GeographyMultiPolygon);
    });

    test('when srid is accessed then default 4326 is returned.', () {
      expect(column.srid, 4326);
    });

    test(
      'when ColumnGeographyMultiPolygon is created with custom srid then srid is set.',
      () {
        var customSridColumn = ColumnGeographyMultiPolygon(
          columnName,
          table,
          srid: 3857,
        );
        expect(customSridColumn.srid, 3857);
      },
    );

    group('when calling intersectsLineString with LineString', () {
      test('then ST_Intersects expression is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var expression = column.intersectsLineString(line);

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

    group('when calling intersects with MultiPolygon', () {
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
        var expression = column.intersects(multiPolygon);

        expect(
          expression.toString(),
          contains('ST_Intersects'),
        );
      });
    });

    group('when calling overlapsPolygon with Polygon', () {
      test('then ST_Overlaps expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var expression = column.overlapsPolygon(polygon);

        expect(expression, isA<Expression>());
        expect(
          expression.toString(),
          contains('ST_Overlaps'),
        );
      });
    });

    group('when calling overlaps with MultiPolygon', () {
      test('then ST_Overlaps expression is returned.', () {
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
        var expression = column.overlaps(multiPolygon);

        expect(expression, isA<Expression>());
        expect(
          expression.toString(),
          contains('ST_Overlaps'),
        );
      });
    });

    group('when calling touchesPolygon with Polygon', () {
      test('then ST_Touches expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var expression = column.touchesPolygon(polygon);

        expect(
          expression.toString(),
          contains('ST_Touches'),
        );
      });
    });

    group('when calling touchesLineString with LineString', () {
      test('then ST_Touches expression is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var expression = column.touchesLineString(line);

        expect(
          expression.toString(),
          contains('ST_Touches'),
        );
      });
    });

    group('when calling touches with MultiPolygon', () {
      test('then ST_Touches expression is returned.', () {
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
        var expression = column.touches(multiPolygon);

        expect(
          expression.toString(),
          contains('ST_Touches'),
        );
      });
    });

    group('when calling contains with Point', () {
      test('then ST_Contains expression is returned.', () {
        var point = const GeographyPoint(-122.3, 37.9);
        var expression = column.contains(point);

        expect(
          expression.toString(),
          contains('ST_Contains'),
        );
      });
    });

    group('when calling containsLineString with LineString', () {
      test('then ST_Contains expression is returned.', () {
        var line = GeographyLineString([
          const GeographyPoint(-122.4, 37.8),
          const GeographyPoint(-122.3, 37.9),
        ]);
        var expression = column.containsLineString(line);

        expect(
          expression.toString(),
          contains('ST_Contains'),
        );
      });
    });

    group('when calling containsPolygon with Polygon', () {
      test('then ST_Contains expression is returned.', () {
        var polygon = GeographyPolygon([
          [
            const GeographyPoint(-122.4, 37.8),
            const GeographyPoint(-122.3, 37.8),
            const GeographyPoint(-122.3, 37.9),
            const GeographyPoint(-122.4, 37.9),
            const GeographyPoint(-122.4, 37.8),
          ],
        ]);
        var expression = column.containsPolygon(polygon);

        expect(
          expression.toString(),
          contains('ST_Contains'),
        );
      });
    });

    group('when calling within with MultiPolygon', () {
      test('then ST_Within expression is returned.', () {
        var multiPolygon = GeographyMultiPolygon([
          GeographyPolygon([
            [
              const GeographyPoint(-122.4, 37.8),
              const GeographyPoint(-122.3, 37.8),
              const GeographyPoint(-122.3, 37.9),
              const GeographyPoint(-122.4, 37.9),
              const GeographyPoint(-122.4, 37.8),
            ],
          ]),
        ]);
        var expression = column.within(multiPolygon);

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

    group('when calling area', () {
      test('then ST_Area ColumnDouble is returned.', () {
        var areaColumn = column.area();
        expect(areaColumn, isA<ColumnDouble>());
        expect(
          areaColumn.toString(),
          contains('ST_Area'),
        );
      });
    });

    group('when calling perimeter', () {
      test('then ST_Perimeter ColumnDouble is returned.', () {
        var perimeterColumn = column.perimeter();
        expect(perimeterColumn, isA<ColumnDouble>());
        expect(
          perimeterColumn.toString(),
          contains('ST_Perimeter'),
        );
      });
    });

    group('when calling isValid', () {
      test('then ST_IsValid expression is returned.', () {
        var expression = column.isValid();
        expect(expression, isA<Expression>());
        expect(
          expression.toString(),
          contains('ST_IsValid'),
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
  });
}
