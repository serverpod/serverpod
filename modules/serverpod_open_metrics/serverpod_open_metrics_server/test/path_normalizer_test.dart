import 'package:serverpod_open_metrics_server/src/util/path_normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('PathNormalizer', () {
    late PathNormalizer normalizer;

    setUp(() {
      normalizer = PathNormalizer();
    });

    group('static paths', () {
      test('preserves simple static path', () {
        expect(normalizer.normalize('/api/users'), equals('/api/users'));
      });

      test('preserves multi-segment static path', () {
        expect(
          normalizer.normalize('/api/v1/users'),
          equals('/api/v1/users'),
        );
      });

      test('preserves path with mixed case', () {
        expect(
          normalizer.normalize('/api/getUserInfo'),
          equals('/api/getUserInfo'),
        );
      });

      test('preserves root path', () {
        expect(normalizer.normalize('/'), equals('/'));
      });

      test('handles empty path', () {
        expect(normalizer.normalize(''), equals('/'));
      });

      test('handles path without leading slash', () {
        expect(normalizer.normalize('api/users'), equals('api/users'));
      });

      test('removes trailing slash', () {
        expect(normalizer.normalize('/api/users/'), equals('/api/users'));
      });

      test('handles single slash after trimming', () {
        expect(normalizer.normalize('//'), equals('/'));
      });
    });

    group('numeric IDs', () {
      test('normalizes integer ID', () {
        expect(
          normalizer.normalize('/api/user/123'),
          equals('/api/user/:id'),
        );
      });

      test('normalizes large integer', () {
        expect(
          normalizer.normalize('/api/user/999999999'),
          equals('/api/user/:id'),
        );
      });

      test('normalizes negative integer', () {
        expect(
          normalizer.normalize('/api/transaction/-42'),
          equals('/api/transaction/:id'),
        );
      });

      test('normalizes floating point number', () {
        expect(
          normalizer.normalize('/api/price/19.99'),
          equals('/api/price/:id'),
        );
      });

      test('normalizes hexadecimal number', () {
        expect(
          normalizer.normalize('/api/color/0x1a2b3c'),
          equals('/api/color/:id'),
        );
      });

      test('normalizes multiple numeric segments', () {
        expect(
          normalizer.normalize('/api/user/123/post/456'),
          equals('/api/user/:id/post/:id'),
        );
      });
    });

    group('UUIDs', () {
      test('normalizes standard UUID', () {
        expect(
          normalizer.normalize(
            '/api/user/550e8400-e29b-41d4-a716-446655440000',
          ),
          equals('/api/user/:id'),
        );
      });

      test('normalizes UUID with uppercase letters', () {
        expect(
          normalizer.normalize(
            '/api/session/A1B2C3D4-E5F6-7890-ABCD-EF1234567890',
          ),
          equals('/api/session/:id'),
        );
      });

      test('normalizes UUID in middle of path', () {
        expect(
          normalizer.normalize(
            '/api/user/550e8400-e29b-41d4-a716-446655440000/posts',
          ),
          equals('/api/user/:id/posts'),
        );
      });
    });

    group('hash-like segments', () {
      test('normalizes short hash (8 chars)', () {
        expect(
          normalizer.normalize('/api/file/a1b2c3d4'),
          equals('/api/file/:id'),
        );
      });

      test('normalizes long hash', () {
        expect(
          normalizer.normalize('/api/commit/a1b2c3d4e5f6g7h8i9j0'),
          equals('/api/commit/:id'),
        );
      });

      test('normalizes all-numeric hash', () {
        expect(
          normalizer.normalize('/api/token/12345678'),
          equals('/api/token/:id'),
        );
      });

      test('does not normalize short alphanumeric (< 8 chars)', () {
        expect(
          normalizer.normalize('/api/v1/users'),
          equals('/api/v1/users'),
        );
      });

      test('normalizes slug with hyphens', () {
        expect(
          normalizer.normalize('/api/file/a1b2-c3d4'),
          equals('/api/file/:id'),
        );
      });

      test('normalizes slug from documentation (abc-def-123)', () {
        expect(
          normalizer.normalize('/api/user/abc-def-123'),
          equals('/api/user/:id'),
        );
      });

      test('normalizes slug with underscores', () {
        expect(
          normalizer.normalize('/api/post/post_42_edit'),
          equals('/api/post/:id'),
        );
      });
    });

    group('date segments', () {
      test('normalizes ISO date', () {
        expect(
          normalizer.normalize('/api/posts/2024-01-15'),
          equals('/api/posts/:id'),
        );
      });

      test('normalizes date in middle of path', () {
        expect(
          normalizer.normalize('/api/posts/2024-12-31/comments'),
          equals('/api/posts/:id/comments'),
        );
      });

      test('does not normalize partial date', () {
        expect(
          normalizer.normalize('/api/posts/2024-01'),
          equals('/api/posts/2024-01'),
        );
      });
    });

    group('timestamp segments', () {
      test('normalizes Unix timestamp (10 digits)', () {
        expect(
          normalizer.normalize('/api/event/1704067200'),
          equals('/api/event/:id'),
        );
      });

      test('normalizes Unix timestamp in milliseconds (13 digits)', () {
        expect(
          normalizer.normalize('/api/event/1704067200000'),
          equals('/api/event/:id'),
        );
      });

      test('does not normalize shorter numbers', () {
        expect(
          normalizer.normalize('/api/event/123456789'),
          equals('/api/event/:id'),
        ); // This is still numeric, just not timestamp pattern
      });
    });

    group('mixed paths', () {
      test('normalizes complex path with multiple dynamic segments', () {
        expect(
          normalizer.normalize(
            '/api/user/123/posts/550e8400-e29b-41d4-a716-446655440000/comments/456',
          ),
          equals('/api/user/:id/posts/:id/comments/:id'),
        );
      });

      test('preserves static segments between dynamic ones', () {
        expect(
          normalizer.normalize('/api/user/123/profile/settings'),
          equals('/api/user/:id/profile/settings'),
        );
      });

      test('normalizes path with date and numeric ID', () {
        expect(
          normalizer.normalize('/api/posts/2024-01-15/123'),
          equals('/api/posts/:id/:id'),
        );
      });

      test('handles consecutive dynamic segments', () {
        expect(
          normalizer.normalize('/api/123/456/789'),
          equals('/api/:id/:id/:id'),
        );
      });
    });

    group('edge cases', () {
      test('handles path with only dynamic segments', () {
        expect(
          normalizer.normalize('/123/456'),
          equals('/:id/:id'),
        );
      });

      test('handles single dynamic segment', () {
        expect(normalizer.normalize('/123'), equals('/:id'));
      });

      test('handles very long path', () {
        expect(
          normalizer.normalize(
            '/api/v1/user/123/profile/posts/456/comments/789/replies/999',
          ),
          equals('/api/v1/user/:id/profile/posts/:id/comments/:id/replies/:id'),
        );
      });

      test('handles empty segment in path', () {
        // Double slashes create empty segments
        expect(
          normalizer.normalize('/api//users'),
          equals('/api//users'),
        );
      });

      test('does not handle query parameters', () {
        // Note: In a real middleware, query params should be stripped before normalization
        // The normalizer treats the entire segment including query params as one unit
        // This test documents that behavior - middleware must strip query params first
        expect(
          normalizer.normalize('/api/users/123?page=1'),
          equals('/api/users/123?page=1'), // Query params prevent normalization
        );
      });

      test('handles path with special characters', () {
        expect(
          normalizer.normalize('/api/user/foo_bar'),
          equals('/api/user/foo_bar'),
        );
      });

      test('handles path with dots', () {
        expect(
          normalizer.normalize('/api/user/foo.bar'),
          equals('/api/user/foo.bar'),
        );
      });
    });

    group('boundary cases', () {
      test('exactly 8 character alphanumeric is normalized', () {
        expect(
          normalizer.normalize('/api/abc12345'),
          equals('/api/:id'),
        );
      });

      test('exactly 7 character alphanumeric is preserved', () {
        expect(
          normalizer.normalize('/api/abc1234'),
          equals('/api/abc1234'),
        );
      });

      test('number with exactly 10 digits is normalized', () {
        expect(
          normalizer.normalize('/api/1234567890'),
          equals('/api/:id'),
        );
      });

      test('number with exactly 13 digits is normalized', () {
        expect(
          normalizer.normalize('/api/1234567890123'),
          equals('/api/:id'),
        );
      });

      test('number with 14 digits is still normalized as numeric', () {
        expect(
          normalizer.normalize('/api/12345678901234'),
          equals('/api/:id'),
        );
      });
    });

    group('realistic API paths', () {
      test('RESTful user endpoint', () {
        expect(
          normalizer.normalize('/api/v1/users/12345'),
          equals('/api/v1/users/:id'),
        );
      });

      test('RESTful nested resource', () {
        expect(
          normalizer.normalize('/api/v1/users/12345/posts/67890'),
          equals('/api/v1/users/:id/posts/:id'),
        );
      });

      test('UUID-based resource', () {
        expect(
          normalizer.normalize(
            '/api/sessions/550e8400-e29b-41d4-a716-446655440000',
          ),
          equals('/api/sessions/:id'),
        );
      });

      test('date-based archive', () {
        expect(
          normalizer.normalize('/archive/2024-01-15'),
          equals('/archive/:id'),
        );
      });

      test('file download by hash', () {
        expect(
          normalizer.normalize('/files/download/abc123def456ghi789'),
          equals('/files/download/:id'),
        );
      });

      test('static assets are preserved', () {
        expect(
          normalizer.normalize('/static/css/main.css'),
          equals('/static/css/main.css'),
        );
      });

      test('health check endpoint', () {
        expect(
          normalizer.normalize('/health'),
          equals('/health'),
        );
      });

      test('metrics endpoint', () {
        expect(
          normalizer.normalize('/metrics'),
          equals('/metrics'),
        );
      });
    });
  });
}
