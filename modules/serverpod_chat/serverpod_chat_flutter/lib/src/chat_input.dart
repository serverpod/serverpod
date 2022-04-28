import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_chat_client/module.dart';
import '../serverpod_chat_flutter.dart';

class ChatInput extends StatefulWidget {
  final ChatController controller;
  final InputDecoration? inputDecoration;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? padding;
  final String? hintText;
  final TextStyle? style;
  final IconData iconSend;
  final IconData iconAttach;
  final bool enableAttachments;

  const ChatInput({
    Key? key,
    required this.controller,
    this.inputDecoration,
    this.boxDecoration,
    this.padding,
    this.hintText,
    this.style,
    this.iconSend = Icons.send,
    this.iconAttach = Icons.attach_file,
    this.enableAttachments = true,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();

  bool _uploadingAttachment = false;
  String? _uploadingAttachementFileName;
  List<ChatMessageAttachment> _attachments = <ChatMessageAttachment>[];

  late final FocusNode _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          _sendTextMessage();
        }
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> attachementTiles = <Widget>[];
    if (_uploadingAttachementFileName != null || _attachments.isNotEmpty) {
      for (ChatMessageAttachment attachment in _attachments) {
        attachementTiles.add(
          _AttachmentTile(
            fileName: attachment.fileName,
            loading: false,
            onDelete: () {
              setState(() {
                _attachments.remove(attachment);
                // TODO: Remove from server
              });
            },
          ),
        );
      }
      if (_uploadingAttachementFileName != null) {
        attachementTiles.add(
          _AttachmentTile(
            fileName: _uploadingAttachementFileName!,
            loading: true,
            onDelete: null,
          ),
        );
      }
    }

    return Container(
      decoration: widget.boxDecoration ??
          BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      autofocus: true,
                      style: widget.style,
                      minLines: 1,
                      maxLines: 10,
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: widget.inputDecoration ??
                          const InputDecoration(
                            hintText: 'Send a message...',
                            isDense: false,
                            border: InputBorder.none,
                          ).copyWith(hintText: widget.hintText),
                    ),
                  ),
                ),
                if (widget.controller.sessionManager.isSignedIn &&
                    widget.enableAttachments)
                  IconButton(
                    icon: Icon(widget.iconAttach),
                    color: Theme.of(context).textTheme.caption!.color,
                    onPressed: _uploadingAttachment ? null : _attachFile,
                    iconSize: 18,
                  ),
                // SizedBox(width: 8,),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(widget.iconSend),
                    color: Theme.of(context).textTheme.caption!.color,
                    onPressed: _uploadingAttachment ? null : _sendTextMessage,
                    iconSize: 18,
                  ),
                ),
              ],
            ),
            if (attachementTiles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                child: SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: attachementTiles,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _sendTextMessage() {
    if (_uploadingAttachment) return;

    String text = _textController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.controller.postMessage(text, _attachments);

    _textController.text = '';
    setState(() {
      _attachments = <ChatMessageAttachment>[];
    });
    _focusNode.requestFocus();
  }

  Future<void> _attachFile() async {
    setState(() {
      _uploadingAttachment = true;
    });

    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(withReadStream: true);
      if (result == null) {
        _uploadCancelled();
        return;
      }

      String fileName = result.files.first.name;
      // var fileName = result.name;
      debugPrint(' - picked file: $fileName');

      if (mounted) {
        setState(() {
          _uploadingAttachementFileName = fileName;
        });
      }

      Stream<List<int>>? stream = result.files.first.readStream;
      // var stream = result.openRead();
      Uint8List? bytes;
      if (stream == null) {
        debugPrint(' - stream is null');
        bytes = result.files.first.bytes;
        // bytes = await result.readAsBytes();
      }

      if (stream == null && bytes == null) {
        debugPrint(' - bytes is null');
        _uploadCancelled();
        return;
      }
      debugPrint(' - stream or bytes is not null');

      ChatMessageAttachmentUploadDescription? uploadDescription = await widget
          .controller.module.chat
          .createAttachmentUploadDescription(fileName);
      if (uploadDescription == null) {
        _uploadCancelled();
        return;
      }
      debugPrint(' - got upload description');

      FileUploader uploader = FileUploader(uploadDescription.uploadDescription);
      if (stream != null) {
        await uploader.upload(stream, result.files.first.size);
      } else if (bytes != null) {
        await uploader.uploadByteData(ByteData.view(bytes.buffer));
      } else {
        _uploadCancelled();
        return;
      }

      debugPrint(' - uploaded file');

      ChatMessageAttachment? attachment = await widget.controller.module.chat
          .verifyAttachmentUpload(fileName, uploadDescription.filePath);
      if (attachment == null) {
        _uploadCancelled();
        return;
      }
      debugPrint(' - got attachment');

      if (mounted) {
        setState(() {
          _attachments.add(attachment);
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Attachment upload failed: $e');
      debugPrint('$stackTrace');
      _uploadCancelled();
    }

    _uploadingAttachementFileName = null;
    _uploadingAttachment = false;
    if (mounted) setState(() {});
  }

  void _uploadCancelled() {
    debugPrint('uploadCancelled');
    _uploadingAttachementFileName = null;
    _uploadingAttachment = false;
    if (mounted) setState(() {});
  }
}

class _AttachmentTile extends StatelessWidget {
  final String fileName;
  final bool loading;
  final VoidCallback? onDelete;

  const _AttachmentTile({
    Key? key,
    required this.fileName,
    this.loading = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      margin: const EdgeInsets.only(left: 8),
      width: 180,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  _iconForName(fileName),
                  color: Theme.of(context).textTheme.bodyText2!.color,
                ),
              ),
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              if (loading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
              if (!loading)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                    onPressed: onDelete,
                    icon: const Icon(Icons.close_rounded),
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForName(String name) {
    String ext = path.extension(name.toLowerCase());
    if (<String>{'.png', '.jpg', '.jpeg', '.gif'}.contains(ext)) {
      return Icons.image_outlined;
    } else if (<String>{'.pdf'}.contains(ext)) {
      return Icons.insert_drive_file_outlined;
    } else {
      return Icons.insert_drive_file_outlined;
    }
  }
}
