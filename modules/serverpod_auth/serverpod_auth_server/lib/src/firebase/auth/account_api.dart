import 'package:firebaseapis/identitytoolkit/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class AccountApi {
  final String _projectId;
  final IdentityToolkitApi _identityToolkitApi;

  AccountApi(
    String projectId,
    AuthClient client,
  )   : _projectId = projectId,
        _identityToolkitApi = IdentityToolkitApi(client);

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
