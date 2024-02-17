import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

/// Input control for the chat. Typically, a chat is setup using a [ChatInput]
/// and a [ChatView].
class ChatInput extends StatefulWidget {
  /// The [ChatController] associated with this chat input.
  final ChatController controller;

  /// The [InputDecoration] used to draw the text input.
  final InputDecoration? inputDecoration;

  /// [BoxDecoration] for drawing the box around the text input.
  final BoxDecoration? boxDecoration;

  /// Padding around the text input.
  final EdgeInsets? padding;

  /// Text input hint text. Shown when the text field is empty.
  final String? hintText;

  /// The text style used for the text input.
  final TextStyle? style;

  /// Icon used for send button.
  final IconData iconSend;

  /// Icon used for attachment button.
  final IconData iconAttach;

  /// True if attachments are enabled.
  final bool enableAttachments;

  /// Creates a new [ChatInput] associated with a [controller].
  const ChatInput({
    super.key,
    required this.controller,
    this.inputDecoration,
    this.boxDecoration,
    this.padding,
    this.hintText,
    this.style,
    this.iconSend = Icons.send,
    this.iconAttach = Icons.attach_file,
    this.enableAttachments = true,
  });

  @override
  ChatInputState createState() => ChatInputState();
}

/// The state of a [ChatInput].
class ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();

  bool _uploadingAttachment = false;
  String? _uploadingAttachementFileName;
  List<ChatMessageAttachment> _attachments = [];

  late final _focusNode = FocusNode(
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
    var attachementTiles = <Widget>[];
    if (_uploadingAttachementFileName != null || _attachments.isNotEmpty) {
      for (var attachment in _attachments) {
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
          children: [
            Row(
              children: [
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
                    color: Theme.of(context).textTheme.bodySmall!.color,
                    onPressed: _uploadingAttachment ? null : _attachFile,
                    iconSize: 18,
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(widget.iconSend),
                    color: Theme.of(context).textTheme.bodySmall!.color,
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

    var text = _textController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    widget.controller.postMessage(text, _attachments);

    _textController.text = '';
    setState(() {
      _attachments = [];
    });
    _focusNode.requestFocus();
  }

  Future<void> _attachFile() async {
    setState(() {
      _uploadingAttachment = true;
    });

    // ChatMessageAttachment attachment;
    try {
      var result = await FilePicker.platform.pickFiles(withReadStream: true);
      if (result == null) {
        _uploadCancelled();
        return;
      }

      var fileName = result.files.first.name;

      if (mounted) {
        setState(() {
          _uploadingAttachementFileName = fileName;
        });
      }

      var bytes = result.files.first.bytes;

      if (bytes == null) {
        _uploadCancelled();
        return;
      }

      var uploadDescription = await widget.controller.module.chat
          .createAttachmentUploadDescription(fileName);
      if (uploadDescription == null) {
        _uploadCancelled();
        return;
      }

      var uploader = FileUploader(uploadDescription.uploadDescription);
      await uploader.uploadUint8List(bytes);

      var attachment = await widget.controller.module.chat
          .verifyAttachmentUpload(fileName, uploadDescription.filePath);
      if (attachment == null) {
        _uploadCancelled();
        return;
      }

      if (mounted) {
        setState(() {
          _attachments.add(attachment);
        });
      }
    } catch (e) {
      _uploadCancelled();
    }

    _uploadingAttachementFileName = null;
    _uploadingAttachment = false;
    if (mounted) setState(() {});
  }

  void _uploadCancelled() {
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
    required this.fileName,
    this.loading = false,
    this.onDelete,
  });

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
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  _iconForName(fileName),
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Expanded(
                child: Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium,
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
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForName(String name) {
    var ext = path.extension(name.toLowerCase());
    if ({'.png', '.jpg', '.jpeg', '.gif'}.contains(ext)) {
      return Icons.image_outlined;
    } else if ({'.pdf'}.contains(ext)) {
      return Icons.insert_drive_file_outlined;
    } else {
      return Icons.insert_drive_file_outlined;
    }
  }
}
