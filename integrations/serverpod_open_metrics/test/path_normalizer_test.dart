import 'package:serverpod_open_metrics/src/util/path_normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('PathNormalizer', () {
    late PathNormalizer normalizer;

    setUp(() {
      normalizer = PathNormalizer();
    });

    group('given a static path', () {
      test('when normalizing a simple static path, then it is preserved', () {
        expect(normalizer.normalize('/api/users'), equals('/api/users'));
      });

      test(
        'when normalizing a multi-segment static path, then it is preserved',
        () {
          expect(
            normalizer.normalize('/api/v1/users'),
            equals('/api/v1/users'),
          );
        },
      );

      test('when normalizing a path with mixed case, then it is preserved', () {
        expect(
          normalizer.normalize('/api/getUserInfo'),
          equals('/api/getUserInfo'),
        );
      });

      test('when normalizing the root path, then it is preserved', () {
        expect(normalizer.normalize('/'), equals('/'));
      });

      test('when normalizing an empty path, then it returns root', () {
        expect(normalizer.normalize(''), equals('/'));
      });

      test(
        'when normalizing a path without leading slash, then it is preserved without leading slash',
        () {
          expect(normalizer.normalize('api/users'), equals('api/users'));
        },
      );

      test(
        'when normalizing a path with trailing slash, then the trailing slash is removed',
        () {
          expect(normalizer.normalize('/api/users/'), equals('/api/users'));
        },
      );

      test(
        'when normalizing a double slash, then it returns a single root slash',
        () {
          expect(normalizer.normalize('//'), equals('/'));
        },
      );
    });

    group('given a path with numeric IDs', () {
      test(
        'when normalizing a path with an integer ID, then the ID is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/user/123'),
            equals('/api/user/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a large integer, then the integer is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/user/999999999'),
            equals('/api/user/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a negative integer, then the integer is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/transaction/-42'),
            equals('/api/transaction/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a floating point number, then the number is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/price/19.99'),
            equals('/api/price/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a hexadecimal number, then the number is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/color/0x1a2b3c'),
            equals('/api/color/:id'),
          );
        },
      );

      test(
        'when normalizing a path with multiple numeric segments, then all are replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/user/123/post/456'),
            equals('/api/user/:id/post/:id'),
          );
        },
      );
    });

    group('given a path with UUIDs', () {
      test(
        'when normalizing a path with a standard UUID, then the UUID is replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/user/550e8400-e29b-41d4-a716-446655440000',
            ),
            equals('/api/user/:id'),
          );
        },
      );

      test(
        'when normalizing a path with an uppercase UUID, then the UUID is replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/session/A1B2C3D4-E5F6-7890-ABCD-EF1234567890',
            ),
            equals('/api/session/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a UUID in the middle, then the UUID is replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/user/550e8400-e29b-41d4-a716-446655440000/posts',
            ),
            equals('/api/user/:id/posts'),
          );
        },
      );
    });

    group('given a path with hash-like segments', () {
      test(
        'when normalizing a path with an 8-char hash, then the hash is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/file/a1b2c3d4'),
            equals('/api/file/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a long hash, then the hash is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/commit/a1b2c3d4e5f6g7h8i9j0'),
            equals('/api/commit/:id'),
          );
        },
      );

      test(
        'when normalizing a path with an all-numeric 8-char hash, then it is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/token/12345678'),
            equals('/api/token/:id'),
          );
        },
      );

      test(
        'given a short alphanumeric segment less than 8 chars, when normalizing, then it is preserved',
        () {
          expect(
            normalizer.normalize('/api/v1/users'),
            equals('/api/v1/users'),
          );
        },
      );

      test(
        'when normalizing a path with a hyphenated slug, then the slug is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/file/a1b2-c3d4'),
            equals('/api/file/:id'),
          );
        },
      );

      test(
        'when normalizing a path with slug abc-def-123, then the slug is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/user/abc-def-123'),
            equals('/api/user/:id'),
          );
        },
      );

      test(
        'when normalizing a path with an underscored slug, then the slug is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/post/post_42_edit'),
            equals('/api/post/:id'),
          );
        },
      );
    });

    group('given a path with date segments', () {
      test(
        'when normalizing a path with an ISO date, then the date is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/posts/2024-01-15'),
            equals('/api/posts/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a date in the middle, then the date is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/posts/2024-12-31/comments'),
            equals('/api/posts/:id/comments'),
          );
        },
      );

      test(
        'when normalizing a path with a partial date, then it is preserved',
        () {
          expect(
            normalizer.normalize('/api/posts/2024-01'),
            equals('/api/posts/2024-01'),
          );
        },
      );
    });

    group('given a path with timestamp segments', () {
      test(
        'when normalizing a path with a 10-digit Unix timestamp, then it is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/event/1704067200'),
            equals('/api/event/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a 13-digit Unix timestamp in milliseconds, then it is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/event/1704067200000'),
            equals('/api/event/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a shorter numeric value, then it is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/event/123456789'),
            equals('/api/event/:id'),
          ); // This is still numeric, just not timestamp pattern
        },
      );
    });

    group('given a path with mixed dynamic segments', () {
      test(
        'when normalizing a path with multiple dynamic segment types, then all are replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/user/123/posts/550e8400-e29b-41d4-a716-446655440000/comments/456',
            ),
            equals('/api/user/:id/posts/:id/comments/:id'),
          );
        },
      );

      test(
        'when normalizing a path with static segments between dynamic ones, then static segments are preserved',
        () {
          expect(
            normalizer.normalize('/api/user/123/profile/settings'),
            equals('/api/user/:id/profile/settings'),
          );
        },
      );

      test(
        'when normalizing a path with a date and numeric ID, then both are replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/posts/2024-01-15/123'),
            equals('/api/posts/:id/:id'),
          );
        },
      );

      test(
        'when normalizing a path with consecutive dynamic segments, then all are replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/123/456/789'),
            equals('/api/:id/:id/:id'),
          );
        },
      );
    });

    group('given an edge case path', () {
      test(
        'when normalizing a path with only dynamic segments, then all are replaced with :id',
        () {
          expect(
            normalizer.normalize('/123/456'),
            equals('/:id/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a single dynamic segment, then it is replaced with :id',
        () {
          expect(normalizer.normalize('/123'), equals('/:id'));
        },
      );

      test(
        'when normalizing a very long path, then all dynamic segments are replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/v1/user/123/profile/posts/456/comments/789/replies/999',
            ),
            equals(
              '/api/v1/user/:id/profile/posts/:id/comments/:id/replies/:id',
            ),
          );
        },
      );

      test(
        'when normalizing a path with an empty segment from double slashes, then it is preserved',
        () {
          // Double slashes create empty segments
          expect(
            normalizer.normalize('/api//users'),
            equals('/api//users'),
          );
        },
      );

      test(
        'when normalizing a path with query parameters, then query parameters prevent normalization',
        () {
          // Note: In a real middleware, query params should be stripped before normalization
          // The normalizer treats the entire segment including query params as one unit
          // This test documents that behavior - middleware must strip query params first
          expect(
            normalizer.normalize('/api/users/123?page=1'),
            equals(
              '/api/users/123?page=1',
            ), // Query params prevent normalization
          );
        },
      );

      test(
        'when normalizing a path with special characters, then it is preserved',
        () {
          expect(
            normalizer.normalize('/api/user/foo_bar'),
            equals('/api/user/foo_bar'),
          );
        },
      );

      test('when normalizing a path with dots, then it is preserved', () {
        expect(
          normalizer.normalize('/api/user/foo.bar'),
          equals('/api/user/foo.bar'),
        );
      });
    });

    group('given a boundary case path', () {
      test(
        'when normalizing a path with exactly 8 alphanumeric characters, then the segment is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/abc12345'),
            equals('/api/:id'),
          );
        },
      );

      test(
        'when normalizing a path with exactly 7 alphanumeric characters, then the segment is preserved',
        () {
          expect(
            normalizer.normalize('/api/abc1234'),
            equals('/api/abc1234'),
          );
        },
      );

      test(
        'when normalizing a path with a 10-digit number, then the number is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/1234567890'),
            equals('/api/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a 13-digit number, then the number is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/1234567890123'),
            equals('/api/:id'),
          );
        },
      );

      test(
        'when normalizing a path with a 14-digit number, then the number is still replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/12345678901234'),
            equals('/api/:id'),
          );
        },
      );
    });

    group('given a realistic API path', () {
      test(
        'when normalizing a RESTful user endpoint, then the user ID is replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/v1/users/12345'),
            equals('/api/v1/users/:id'),
          );
        },
      );

      test(
        'when normalizing a RESTful nested resource, then all IDs are replaced with :id',
        () {
          expect(
            normalizer.normalize('/api/v1/users/12345/posts/67890'),
            equals('/api/v1/users/:id/posts/:id'),
          );
        },
      );

      test(
        'when normalizing a UUID-based resource, then the UUID is replaced with :id',
        () {
          expect(
            normalizer.normalize(
              '/api/sessions/550e8400-e29b-41d4-a716-446655440000',
            ),
            equals('/api/sessions/:id'),
          );
        },
      );

      test(
        'when normalizing a date-based archive path, then the date is replaced with :id',
        () {
          expect(
            normalizer.normalize('/archive/2024-01-15'),
            equals('/archive/:id'),
          );
        },
      );

      test(
        'when normalizing a file download by hash, then the hash is replaced with :id',
        () {
          expect(
            normalizer.normalize('/files/download/abc123def456ghi789'),
            equals('/files/download/:id'),
          );
        },
      );

      test('when normalizing a static asset path, then it is preserved', () {
        expect(
          normalizer.normalize('/static/css/main.css'),
          equals('/static/css/main.css'),
        );
      });

      test(
        'when normalizing a health check endpoint, then it is preserved',
        () {
          expect(
            normalizer.normalize('/health'),
            equals('/health'),
          );
        },
      );

      test('when normalizing a metrics endpoint, then it is preserved', () {
        expect(
          normalizer.normalize('/metrics'),
          equals('/metrics'),
        );
      });
    });
  });
}
