import 'dart:async';
import 'dart:io';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:xml/xml.dart';

// Constants for entitlements content
const String debugProfileContent = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>com.apple.security.app-sandbox</key>
  <true/>
</dict>
</plist>
''';

const String debugProfileContentWithAddedClient = '''
<?xml version="1.0" encoding="UTF-8"?>
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

const String releaseProfileContent = '''
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

const String releaseProfileContentWithAddedClient = '''
<?xml version="1.0" encoding="UTF-8"?>
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
    var debugEntitlementsPath =
        '${dir.path}/macos/Runner/DebugProfile.entitlements';
    var releaseEntitlementsPath =
        '${dir.path}/macos/Runner/Release.entitlements';

    bool debugResult = await _modifyEntitlements(debugEntitlementsPath,
        debugProfileContent, debugProfileContentWithAddedClient);
    bool releaseResult = await _modifyEntitlements(releaseEntitlementsPath,
        releaseProfileContent, releaseProfileContentWithAddedClient);

    return debugResult && releaseResult;
  }

  /// Modifies the entitlements file by adding the network client entitlement if needed.
  static Future<bool> _modifyEntitlements(
      String filePath, String originalContent, String modifiedContent) async {
    try {
      var file = File(filePath);

      // Check if file exists
      if (!file.existsSync()) {
        log.error('Entitlements file not found: $filePath');
        return false;
      }

      String contents = await file.readAsString();

      // Check if the current content matches the expected original content
      if (contents == originalContent) {
        await file.writeAsString(modifiedContent);
        log.debug(
            'Added `com.apple.security.network.client` entitlement to $filePath');
        return true;
      }

      return false;
    } catch (e) {
      log.error('Error modifying entitlements: $e');
      return false;
    }
  }
}
