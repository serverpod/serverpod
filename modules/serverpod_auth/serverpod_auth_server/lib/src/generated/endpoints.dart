/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

import 'package:serverpod/serverpod.dart';

// ignore: unused_import
import 'protocol.dart';

import '../endpoints/apple_endpoint.dart';
import '../endpoints/google_endpoint.dart';
import '../endpoints/user_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'apple': AppleEndpoint()..initialize(server, 'apple'),
      'google': GoogleEndpoint()..initialize(server, 'google'),
      'user': UserEndpoint()..initialize(server, 'user'),
    };

    connectors['apple'] = EndpointConnector(
      name: 'apple',
      endpoint: endpoints['apple']!,
      methodConnectors: {
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['apple'] as AppleEndpoint).authenticate(session,);
          },
        ),
      },
    );

    connectors['google'] = EndpointConnector(
      name: 'google',
      endpoint: endpoints['google']!,
      methodConnectors: {
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
            'authenticationCode': ParameterDescription(name: 'authenticationCode', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['google'] as GoogleEndpoint).authenticate(session,params['authenticationCode'],);
          },
        ),
      },
    );

    connectors['user'] = EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getAuthenticatedUserInfo': MethodConnector(
          name: 'getAuthenticatedUserInfo',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['user'] as UserEndpoint).getAuthenticatedUserInfo(session,);
          },
        ),
        'updateUserInfo': MethodConnector(
          name: 'updateUserInfo',
          params: {
            'userInfo': ParameterDescription(name: 'userInfo', type: UserInfo, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['user'] as UserEndpoint).updateUserInfo(session,params['userInfo'],);
          },
        ),
      },
    );
  }

  @override
  void registerModules(Serverpod pod) {
  }
}

