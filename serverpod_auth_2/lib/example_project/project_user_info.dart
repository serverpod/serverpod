import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';

/// Extended user info for a specific project (their can only be 1 such implementation for project)
///
/// Since this is not the primary focus of this exploration, it is kept minimally.
/// But something like multi-tenant support deeply affects the structure, and thus we should explore this already.
class ProjectUserInfo extends UserInfo {
  late final String tenant;

  late final bool subscribedToNewsletter;
}
