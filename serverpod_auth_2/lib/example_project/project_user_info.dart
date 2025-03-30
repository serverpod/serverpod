import 'package:serverpod_auth_2/serverpod_auth_module/user_info.dart';

/// Extended user info for a specific project (there can only be 1 such implementation per project)
///
/// Since this is not the primary focus of this exploration, it is kept minimally.
///
/// But something like multi-tenant support deeply affects the structure, and thus we should explore this already
/// (e.g. having mulitple extended user infos mapped to one user, and then getting it by user ID + tenant key (or any other further parameters))
class ProjectUserInfo extends UserInfo {
  late final String tenant;

  late final bool subscribedToNewsletter;
}
