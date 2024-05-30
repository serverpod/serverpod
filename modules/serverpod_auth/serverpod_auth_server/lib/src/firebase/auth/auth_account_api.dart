import 'package:firebaseapis/identitytoolkit/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:serverpod_auth_server/src/firebase/errors/firebase_error.dart';

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
    var response = await _identityToolkitApi.projects.accounts_1.lookup(
      GoogleCloudIdentitytoolkitV1GetAccountInfoRequest(
        localId: [uiid],
      ),
      _projectId,
    );

    if (response.users == null || response.users!.isEmpty) {
      throw FirebaseError(
        'There is no user record corresponding to the provided identifier.',
      );
    }

    return response.users!.first;
  }
}
