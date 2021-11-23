/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'protocol.dart';

import '../endpoints/apple_endpoint.dart';
import '../endpoints/email_endpoint.dart';
import '../endpoints/google_endpoint.dart';
import '../endpoints/user_endpoint.dart';
import '../endpoints/status_endpoint.dart';
import '../endpoints/admin_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'apple': AppleEndpoint()..initialize(server, 'apple', 'serverpod_auth'),
      'email': EmailEndpoint()..initialize(server, 'email', 'serverpod_auth'),
      'google': GoogleEndpoint()..initialize(server, 'google', 'serverpod_auth'),
      'user': UserEndpoint()..initialize(server, 'user', 'serverpod_auth'),
      'status': StatusEndpoint()..initialize(server, 'status', 'serverpod_auth'),
      'admin': AdminEndpoint()..initialize(server, 'admin', 'serverpod_auth'),
    };

    connectors['apple'] = EndpointConnector(
      name: 'apple',
      endpoint: endpoints['apple']!,
      methodConnectors: {
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
            'authInfo': ParameterDescription(name: 'authInfo', type: AppleAuthInfo, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['apple'] as AppleEndpoint).authenticate(session,params['authInfo'],);
          },
        ),
      },
    );

    connectors['email'] = EndpointConnector(
      name: 'email',
      endpoint: endpoints['email']!,
      methodConnectors: {
        'authenticate': MethodConnector(
          name: 'authenticate',
          params: {
            'email': ParameterDescription(name: 'email', type: String, nullable: false),
            'password': ParameterDescription(name: 'password', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['email'] as EmailEndpoint).authenticate(session,params['email'],params['password'],);
          },
        ),
        'changePassword': MethodConnector(
          name: 'changePassword',
          params: {
            'oldPassword': ParameterDescription(name: 'oldPassword', type: String, nullable: false),
            'newPassword': ParameterDescription(name: 'newPassword', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['email'] as EmailEndpoint).changePassword(session,params['oldPassword'],params['newPassword'],);
          },
        ),
        'initiatePasswordReset': MethodConnector(
          name: 'initiatePasswordReset',
          params: {
            'email': ParameterDescription(name: 'email', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['email'] as EmailEndpoint).initiatePasswordReset(session,params['email'],);
          },
        ),
        'verifyEmailPasswordReset': MethodConnector(
          name: 'verifyEmailPasswordReset',
          params: {
            'verificationCode': ParameterDescription(name: 'verificationCode', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['email'] as EmailEndpoint).verifyEmailPasswordReset(session,params['verificationCode'],);
          },
        ),
        'resetPassword': MethodConnector(
          name: 'resetPassword',
          params: {
            'verificationCode': ParameterDescription(name: 'verificationCode', type: String, nullable: false),
            'password': ParameterDescription(name: 'password', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['email'] as EmailEndpoint).resetPassword(session,params['verificationCode'],params['password'],);
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
        'removeUserImage': MethodConnector(
          name: 'removeUserImage',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['user'] as UserEndpoint).removeUserImage(session,);
          },
        ),
        'setUserImage': MethodConnector(
          name: 'setUserImage',
          params: {
            'image': ParameterDescription(name: 'image', type: typed_data.ByteData, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['user'] as UserEndpoint).setUserImage(session,params['image'],);
          },
        ),
        'changeUserName': MethodConnector(
          name: 'changeUserName',
          params: {
            'userName': ParameterDescription(name: 'userName', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['user'] as UserEndpoint).changeUserName(session,params['userName'],);
          },
        ),
      },
    );

    connectors['status'] = EndpointConnector(
      name: 'status',
      endpoint: endpoints['status']!,
      methodConnectors: {
        'isSignedIn': MethodConnector(
          name: 'isSignedIn',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['status'] as StatusEndpoint).isSignedIn(session,);
          },
        ),
        'signOut': MethodConnector(
          name: 'signOut',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['status'] as StatusEndpoint).signOut(session,);
          },
        ),
        'getUserInfo': MethodConnector(
          name: 'getUserInfo',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['status'] as StatusEndpoint).getUserInfo(session,);
          },
        ),
        'getUserSettingsConfig': MethodConnector(
          name: 'getUserSettingsConfig',
          params: {
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['status'] as StatusEndpoint).getUserSettingsConfig(session,);
          },
        ),
      },
    );

    connectors['admin'] = EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getUserInfo': MethodConnector(
          name: 'getUserInfo',
          params: {
            'userId': ParameterDescription(name: 'userId', type: int, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['admin'] as AdminEndpoint).getUserInfo(session,params['userId'],);
          },
        ),
      },
    );
  }

  @override
  void registerModules(Serverpod pod) {
  }
}

