import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

const String _originalSigningConfig = '''
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")''';

const String _modifiedSigningConfig = '''
            // Release builds on Serverpod Cloud are signed with the release
            // signing config. Everywhere else, the debug keys are used so
            // `flutter run --release` works.
            signingConfig = if (isServerpodCloudBuild) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }''';

const String _signingConfigsBlock = '''
    signingConfigs {
        // Only configured on Serverpod Cloud builds. The keystore is provided
        // through the ANDROID_KEYSTORE_PATH, ANDROID_KEYSTORE_PASSWORD,
        // ANDROID_KEY_ALIAS and ANDROID_KEY_PASSWORD environment variables.
        if (isServerpodCloudBuild) {
            create("release") {
                storeFile = file(System.getenv("ANDROID_KEYSTORE_PATH"))
                storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("ANDROID_KEY_ALIAS")
                keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
            }
        }
    }

''';

const String _isCloudBuildDeclaration = '''
// SERVERPOD_APP_BUILD is set when building on Serverpod Cloud.
val isServerpodCloudBuild = System.getenv("SERVERPOD_APP_BUILD") != null

''';

class AndroidSigningModifier {
  /// Adds a release signing config to the Flutter app's Android Gradle build
  /// file. The config is only used when building on Serverpod Cloud, detected
  /// through the `SERVERPOD_APP_BUILD` environment variable.
  static Future<bool> addReleaseSigningConfig(Directory dir) async {
    var filePath = path.join(dir.path, 'android', 'app', 'build.gradle.kts');

    try {
      var file = File(filePath);
      if (!file.existsSync()) {
        log.debug(
          'Gradle build file not found: $filePath, adding release signing config skipped.',
        );
        return false;
      }

      var contents = await file.readAsString();

      if (!contents.contains(_originalSigningConfig) ||
          !contents.contains('\nandroid {\n')) {
        log.debug(
          'Gradle build file content does not match expected content, adding release signing config skipped for $filePath.',
        );
        return false;
      }

      contents = contents
          .replaceFirst(_originalSigningConfig, _modifiedSigningConfig)
          .replaceFirst(
            '\nandroid {\n',
            '\n$_isCloudBuildDeclaration'
                'android {\n'
                '$_signingConfigsBlock',
          );

      await file.writeAsString(contents);
      log.debug('Added release signing config to $filePath');
      return true;
    } catch (e) {
      log.debug(
        'Error adding release signing config: $e, adding release signing config skipped.',
      );
      return false;
    }
  }
}
