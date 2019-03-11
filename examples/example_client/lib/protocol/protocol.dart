/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'user_info.dart';
import 'company_info.dart';

export 'user_info.dart';
export 'company_info.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  Map<String, constructor> _constructors = <String, constructor>{};
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['UserInfo'] = (Map<String, dynamic> serialization) => UserInfo.fromSerialization(serialization);
    constructors['CompanyInfo'] = (Map<String, dynamic> serialization) => CompanyInfo.fromSerialization(serialization);
  }
}
