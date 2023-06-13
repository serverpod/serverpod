import 'dart:io';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:serverpod_cli/src/language_server/wireformat.dart';

Future<void> runLanguageServer() async {
  var peer = Peer(lspChannel(stdin, stdout));
  peer
    ..registerMethod('initialize', (params) async {
      return ({
        'capabilities': {
          'textDocumentSync': 1,
        }
      });
    })
    ..registerMethod('textDocument/didChange', (Parameters params) async {
      // todo implement
    });

  await peer.listen();
}
