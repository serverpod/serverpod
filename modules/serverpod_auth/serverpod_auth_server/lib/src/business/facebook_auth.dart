import 'dart:convert';
import 'dart:io';

const _configFilePath = 'config/facebook_app_secret.json';

/// Convenience methods for handling authentication with Facebook and accessing
/// Facebook's APIs.
class FacebookAuth {
  /// The client secret loaded from `config/facebook_app_secret.json`, null
  /// if the client secrets failed to load.
  static final appSecret = _loadAppSecret();

  static FacebookAppSecret? _loadAppSecret() {
    try {
      return FacebookAppSecret._(_configFilePath);
    } catch (e) {
      stdout.writeln(
        'serverpod_auth_server: Failed to load $_configFilePath. '
        'Sign in with Facebook will be disabled.',
      );
    }
    return null;
  }
}

/// Contains information about the credentials for the server to access
/// Facebook's APIs. The app_id and app_secret are loaded from
/// `config/facebook_app_secret.json`. The values in this file
/// are obtained from Facebook's developer console.
class FacebookAppSecret {
  final String _path;

  /// The client identifier.
  late final String appId;

  /// The client secret.
  late final String appSecret;

  /// Loads the facebook app secret from the provided path.
  FacebookAppSecret._(this._path) {
    var file = File(_path);
    var jsonData = file.readAsStringSync();
    var data = jsonDecode(jsonData);

    appId = data['app_id'];
    appSecret = data['app_secret'];
  }
}
