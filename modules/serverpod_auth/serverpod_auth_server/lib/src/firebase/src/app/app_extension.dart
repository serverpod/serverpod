import 'dart:io';


import 'package:serverpod_auth_server/src/firebase/src/auth/credential.dart';

import '../../firebase_admin.dart';

extension GetProjectIdExtension on App {
  String get projectId => _getProjectId(this);
}

String _getProjectId(App app) {
  final options = app.options;
  if (options.projectId != null && options.projectId!.isNotEmpty) {
    return options.projectId!;
  }

  final cert = _tryGetCertificate(options.credential);
  if (cert != null && cert.projectId != null && cert.projectId!.isNotEmpty) {
    return cert.projectId!;
  }

  final projectId = Platform.environment['GOOGLE_CLOUD_PROJECT'] ??
      Platform.environment['GCLOUD_PROJECT'];
  if (projectId != null && projectId.isNotEmpty) {
    return projectId;
  }

  throw FirebaseAuthError.invalidCredential(
    'Must initialize app with a cert credential or set your Firebase project ID as the '
    'GOOGLE_CLOUD_PROJECT environment variable.',
  );
}

Certificate? _tryGetCertificate(Credential credential) {
  if (credential is FirebaseCredential) {
    return credential.certificate;
  }
  return null;
}
