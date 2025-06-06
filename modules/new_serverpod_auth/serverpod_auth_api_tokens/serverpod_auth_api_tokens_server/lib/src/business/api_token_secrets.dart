import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';

/// Secrets used for API tokens.
@internal
class ApiTokenSecrets {
  ApiTokenSecrets({
    @visibleForTesting final String? apiTokenHashPepper,
  }) : apiTokenHashPepper = apiTokenHashPepper ?? _apiTokenHashPepper;

  final String apiTokenHashPepper;

  /// The configuration key for the API token hash pepper entry.
  static const String apiTokenHashPepperConfigurationKey =
      'serverpod_auth_api_token.apiTokenHashPepper';

  /// The pepper used for hashing API tokens.
  ///
  /// This influences the stored API token hashes, so it must not be changed for a given deployment,
  /// as otherwise all tokens become invalid.
  static String get _apiTokenHashPepper {
    final pepper = Serverpod.instance.getPassword(
      apiTokenHashPepperConfigurationKey,
    );

    if (pepper == null || pepper.isEmpty) {
      throw ArgumentError(
        'No "pepper" was configured in the API token passwords.',
        apiTokenHashPepperConfigurationKey,
      );
    }

    if (pepper.length < 10) {
      throw ArgumentError(
        'Given "pepper" in the API token passwords is too short. Use at least 10 random characters.',
        apiTokenHashPepperConfigurationKey,
      );
    }

    return pepper;
  }
}
