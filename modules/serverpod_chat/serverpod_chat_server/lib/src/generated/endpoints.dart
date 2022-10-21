/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/chat_endpoint.dart' as _i2;
import 'package:serverpod_auth_server/module.dart' as _i3;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'chat': _i2.ChatEndpoint()
        ..initialize(
          server,
          'chat',
          'serverpod_chat',
        )
    };
    connectors['chat'] = _i1.EndpointConnector(
      name: 'chat',
      endpoint: endpoints['chat']!,
      methodConnectors: {
        'createAttachmentUploadDescription': _i1.MethodConnector(
          name: 'createAttachmentUploadDescription',
          params: {
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['chat'] as _i2.ChatEndpoint)
                  .createAttachmentUploadDescription(
            session,
            params['fileName'],
          ),
        ),
        'verifyAttachmentUpload': _i1.MethodConnector(
          name: 'verifyAttachmentUpload',
          params: {
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'filePath': _i1.ParameterDescription(
              name: 'filePath',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['chat'] as _i2.ChatEndpoint).verifyAttachmentUpload(
            session,
            params['fileName'],
            params['filePath'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i3.Endpoints()..initializeEndpoints(server);
  }

  @override
  void registerModules(_i1.Serverpod pod) {
    pod.registerModule(
      _i3.Protocol(),
      'auth',
    );
  }
}
