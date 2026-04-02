import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/passwordless.dart';

/// Reference [PasswordlessIdpConfig] for reading default field values so tests
/// stay aligned with production defaults.
final PasswordlessIdpConfig<String> passwordlessIdpConfigDefaultFieldValues =
    PasswordlessIdpConfig<String>(
      secretHashPepper: '_',
      resolveAuthUserId:
          (
            final Session _, {
            required final String handle,
            required final Transaction? transaction,
          }) async {
            return UuidValue.withValidation(const Uuid().v4());
          },
    );
