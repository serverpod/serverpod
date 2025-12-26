import '../../../../../core.dart';
import 'anonymous_idp_config.dart';
import 'utils/anonymous_idp_account_creation_util.dart';

/// Anonymous account management functions.
class AnonymousIdpUtils {
  /// {@macro anonymous_idp_account_creation_util}
  final AnonymousIdpAccountCreationUtil accountCreation;

  /// Creates a new instance of [AnonymousIdpUtils].
  AnonymousIdpUtils({
    required final AnonymousIdpConfig config,
    required final AuthUsers authUsers,
  }) : accountCreation = AnonymousIdpAccountCreationUtil(
         config: AnonymousIdpAccountCreationUtilsConfig.fromAnonymousIdpConfig(
           config,
         ),
         authUsers: authUsers,
       );
}
