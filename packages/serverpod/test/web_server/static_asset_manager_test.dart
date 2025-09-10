import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/web_server/static_asset_manager.dart';

void main() {
  group('StaticAssetManager', () {
    late StaticAssetManager manager;
    late Directory tempDir;
    late File testFile;

    setUp(() async {
      manager = StaticAssetManager();
      manager.clearCache();

      // Create a temporary directory for testing
      tempDir = await Directory.systemTemp.createTemp('serverpod_test_');
      manager.configureStaticDirectories([tempDir.path]);

      // Create a test file
      testFile = File(p.join(tempDir.path, 'test.txt'));
      await testFile.writeAsString('Hello, World!');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
      manager.clearCache();
    });

    test('should generate versioned URLs for existing files', () async {
      var url = await manager.assetUrl('test.txt');
      expect(url, isNotNull);
      expect(url, contains('test.'));
      expect(url, endsWith('.txt'));
    });

    test('should return null for non-existent files', () async {
      var url = await manager.assetUrl('nonexistent.txt');
      expect(url, isNull);
    });

    test('should cache hash results', () async {
      var url1 = await manager.assetUrl('test.txt');
      var url2 = await manager.assetUrl('test.txt');

      expect(url1, equals(url2));

      var stats = manager.getCacheStats();
      expect(stats['cacheSize'], equals(1));
    });

    test('should invalidate cache when file changes', () async {
      var url1 = await manager.assetUrl('test.txt');

      // Wait a bit to ensure different modification time
      await Future.delayed(Duration(milliseconds: 10));

      // Modify the file
      await testFile.writeAsString('Hello, Updated World!');

      var url2 = await manager.assetUrl('test.txt');

      expect(url1, isNot(equals(url2)));
    });

    test('should support CDN URLs', () async {
      manager.configureCdnUrl('https://mycdn.com/static');

      var url = await manager.assetUrl('test.txt');
      expect(url, startsWith('https://mycdn.com/static/'));
    });

    test('should handle subdirectories', () async {
      var subDir = Directory(p.join(tempDir.path, 'images'));
      await subDir.create();

      var imageFile = File(p.join(subDir.path, 'logo.png'));
      await imageFile.writeAsString('fake image data');

      var url = await manager.assetUrl('images/logo.png');
      expect(url, isNotNull);
      expect(url, contains('images/logo.'));
      expect(url, endsWith('.png'));
    });
  });
}
