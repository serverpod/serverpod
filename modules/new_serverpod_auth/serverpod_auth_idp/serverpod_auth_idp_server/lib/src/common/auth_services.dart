import '../../providers/apple.dart';
import '../../providers/google.dart';

/// Centralized access to authentication services.
class AuthServices {
  static AuthServices _instance = AuthServices.empty();

  /// Singleton instance of [AuthServices].
  static AuthServices get instance => _instance;

  final GoogleIDP? _googleIDP;
  final AppleIDP? _appleIDP;

  /// Create [an AuthServices] instance.
  AuthServices({
    final GoogleIDP? googleIDP,
    final AppleIDP? appleIDP,
  })  : _googleIDP = googleIDP,
        _appleIDP = appleIDP;

  /// Create an empty [AuthServices] instance with no configured IDPs.
  factory AuthServices.empty() => AuthServices(googleIDP: null);

  /// Initialize the [AuthServices] singleton.
  static void initialize({
    final GoogleIDPConfig? googleIDPConfig,
    final AppleIDPConfig? appleIDPConfig,
  }) {
    _instance = AuthServices(
      googleIDP:
          googleIDPConfig != null ? GoogleIDP(config: googleIDPConfig) : null,
      appleIDP:
          appleIDPConfig != null ? AppleIDP(config: appleIDPConfig) : null,
    );
  }
}

/// Extension methods for easier access to configured IDPs.
extension IDPExtension on AuthServices {
  /// The Google IDP instance used for authentication.
  GoogleIDP get googleIDP {
    final googleIDP = _googleIDP;
    if (googleIDP == null) {
      throw StateError(
        'GoogleIDP is not configured. Make sure to provide a valid GoogleIDPConfig when initializing AuthServices.',
      );
    }

    return googleIDP;
  }

  /// The Apple IDP instance used for authentication.
  AppleIDP get appleIDP {
    final appleIDP = _appleIDP;
    if (appleIDP == null) {
      throw StateError(
        'AppleIDP is not configured. Make sure to provide a valid AppleIDPConfig when initializing AuthServices.',
      );
    }

    return appleIDP;
  }
}
