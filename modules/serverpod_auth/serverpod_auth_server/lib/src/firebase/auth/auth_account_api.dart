import 'package:firebaseapis/identitytoolkit/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

/// Authorized http requests agains google identity toolkit api
class AuthRequestApi {
  final String _projectId;
  final IdentityToolkitApi _identityToolkitApi;

  /// Creates a new [AuthRequestApi] object with a [projectId] and [AuthClient]
  AuthRequestApi({
    required String projectId,
    required AuthClient client,
  })  : _projectId = projectId,
        _identityToolkitApi = IdentityToolkitApi(client);

  /// Get UserRecord by user [uiid/localId]
  Future<GoogleCloudIdentitytoolkitV1UserInfo> getUserByUiid(
    String uiid,
  ) async {
    var users = await _identityToolkitApi.projects.accounts_1.lookup(
      GoogleCloudIdentitytoolkitV1GetAccountInfoRequest(
        localId: [uiid],
      ),
      _projectId,
    );

    return users.users!.first;
  }
}
