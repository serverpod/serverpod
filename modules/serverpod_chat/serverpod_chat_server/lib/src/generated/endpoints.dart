/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: unused_import

import 'dart:typed_data' as typed_data;
import 'package:serverpod/serverpod.dart';

import 'protocol.dart';

import '../endpoints/chat_endpoint.dart';

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    var endpoints = <String, Endpoint>{
      'chat': ChatEndpoint()..initialize(server, 'chat', 'serverpod_chat'),
    };

    connectors['chat'] = EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'createAttachmentUploadDescription': MethodConnector(
          name: 'createAttachmentUploadDescription',
          params: {
            'fileName': ParameterDescription(
                name: 'fileName', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['chat'] as ChatEndpoint)
                .createAttachmentUploadDescription(
              session,
              params['fileName'],
            );
          },
        ),
        'verifyAttachmentUpload': MethodConnector(
          name: 'verifyAttachmentUpload',
          params: {
            'fileName': ParameterDescription(
                name: 'fileName', type: String, nullable: false),
            'filePath': ParameterDescription(
                name: 'filePath', type: String, nullable: false),
          },
          call: (Session session, Map<String, dynamic> params) async {
            return (endpoints['chat'] as ChatEndpoint).verifyAttachmentUpload(
              session,
              params['fileName'],
              params['filePath'],
            );
          },
        ),
      },
    );
  }

  @override
  void registerModules(Serverpod pod) {}
}
