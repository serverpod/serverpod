import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

// Constants for entitlements content
const String _debugProfileContent = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
	<key>com.apple.security.network.server</key>
	<true/>
</dict>
</plist>
''';

const String _debugProfileContentWithAddedClient =
    '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.cs.allow-jit</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
	<key>com.apple.security.network.server</key>
	<true/>
</dict>
</plist>
''';

const String _releaseProfileContent = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
</dict>
</plist>
''';

const String _releaseProfileContentWithAddedClient =
    '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
</dict>
</plist>
''';

class EntitlementsModifier {
  /// Adds network client entitlement to the debug and release entitlements files.
  static Future<bool> addNetworkToEntitlements(Directory dir) async {
    var debugEntitlementsPath = path.join(
      dir.path,
      'macos',
      'Runner',
      'DebugProfile.entitlements',
    );

    var releaseEntitlementsPath = path.join(
      dir.path,
      'macos',
      'Runner',
      'Release.entitlements',
    );

    bool debugResult = await _modifyEntitlements(
      debugEntitlementsPath,
      _debugProfileContent,
      _debugProfileContentWithAddedClient,
    );
    bool releaseResult = await _modifyEntitlements(
      releaseEntitlementsPath,
      _releaseProfileContent,
      _releaseProfileContentWithAddedClient,
    );
    return debugResult && releaseResult;
  }

  /// Modifies the entitlements file by adding the network client entitlement.
  static Future<bool> _modifyEntitlements(
    String filePath,
    String originalContent,
    String modifiedContent,
  ) async {
    try {
      var file = File(filePath);

      // Check if file exists
      if (!file.existsSync()) {
        log.debug(
          'Entitlements file not found: $filePath, updating entitlements skipped.',
        );
        return false;
      }
      String contents = await file.readAsString();

      // Check if the current content matches the expected original content
      if (contents.trim() != originalContent.trim()) {
        log.debug(
          'Entitlements file content does not match expected content, updating entitlements skipped for $filePath.',
        );
        return false;
      }

      await file.writeAsString(modifiedContent);
      log.debug(
        'Added `com.apple.security.network.client` entitlement to $filePath',
      );
      return true;
    } catch (e) {
      log.debug(
        'Error modifying entitlements: $e, updating entitlements skipped.',
      );
      return false;
    }
  }
}
