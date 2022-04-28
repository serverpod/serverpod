import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_chat_client/module.dart';
import 'text_with_links.dart';
import 'web_util/web_util.dart';

class DefaultChatTile extends StatelessWidget {
  final ChatMessage message;
  final ChatMessage? previous;
  final double horizontalPadding;

  final DateFormat _timeFormat = DateFormat.jm();

  DefaultChatTile({
    Key? key,
    required this.message,
    this.previous,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool compress = previous != null &&
        message.sender == previous!.sender &&
        message.time
                .difference(previous!.time)
                .compareTo(const Duration(minutes: 3)) <
            0;

    bool hasPreview = message.attachments != null &&
        message.attachments!.length == 1 &&
        message.attachments![0].previewImage != null;

    List<Widget> attachmentTiles = <Widget>[];
    if (message.attachments != null && !hasPreview) {
      for (ChatMessageAttachment attachment in message.attachments!) {
        attachmentTiles.add(
          _AttachmentTile(attachment: attachment),
        );
      }
    }

    Widget tile = Container(
      padding: EdgeInsets.only(
          bottom: 20, left: horizontalPadding, right: horizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!compress)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircularUserImage(
                userInfo: message.senderInfo,
                size: 40,
              ),
            ),
          if (compress)
            const SizedBox(
              width: 52,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (!compress)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          message.senderInfo?.userName ?? 'Unknown sender',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            _formatTime(message.time),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (message.message.isNotEmpty)
                  TextWithLinks(
                    message.message,
                    selectable: true,
                    linkColor: Colors.lightBlue[300]!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(height: 1.5),
                  ),
                if (attachmentTiles.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: attachmentTiles,
                    ),
                  ),
                if (hasPreview)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _AttachmentTile(
                          attachment: message.attachments![0], preview: true),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );

    bool showDayHeader =
        previous == null || !_isSameDay(message.time, previous!.time);
    if (showDayHeader) {
      tile = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Center(
              child: Text(
                _formatDay(message.time),
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption!.color,
                ),
              ),
            ),
          ),
          tile,
        ],
      );
    }

    if (message.sent != null && !message.sent!) {
      tile = Opacity(
        opacity: 0.5,
        child: tile,
      );
    }

    return tile;
  }

  /// Formats the time component of [time] in the local timezone
  String _formatTime(DateTime time) {
    return _timeFormat.format(time.toLocal());
  }

  /// Returns whether the arguments are on the same day in the local timezone
  bool _isSameDay(DateTime a, DateTime b) {
    a = a.toLocal();
    b = b.toLocal();

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Formats the day of [date] in the local timezone
  String _formatDay(DateTime date) {
    date = date.toLocal();
    date = DateTime(date.year, date.month, date.day);

    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    int dayDiff = today.difference(date).inDays;
    if (dayDiff == 0) {
      return 'Today';
    } else if (dayDiff == 1) {
      return 'Yesterday';
    } else if (dayDiff < 7) {
      return DateFormat.EEEE().format(date);
    } else if (date.year == today.year) {
      return DateFormat.MMMd().format(date);
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
}

class _AttachmentTile extends StatefulWidget {
  final ChatMessageAttachment attachment;
  final bool preview;

  const _AttachmentTile({
    Key? key,
    required this.attachment,
    this.preview = false,
  }) : super(key: key);

  @override
  _AttachmentTileState createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<_AttachmentTile> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Widget previewTile;

    Color color;
    if (_pressed) {
      color = Colors.black54;
    } else if (_hover) {
      color = Colors.white24;
    } else {
      color = Theme.of(context).cardColor;
    }

    if (widget.preview) {
      previewTile = Container(
        width: widget.attachment.previewWidth!.toDouble(),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: color,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: widget.attachment.previewWidth!.toDouble(),
              height: widget.attachment.previewHeight!.toDouble(),
              child: Image.network(widget.attachment.previewImage!),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      _iconForName(widget.attachment.fileName),
                      color: Theme.of(context).textTheme.bodyText2!.color,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.attachment.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      previewTile = Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        margin: const EdgeInsets.only(right: 8),
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
                    _iconForName(widget.attachment.fileName),
                    color: Theme.of(context).textTheme.bodyText2!.color,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.attachment.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          _hover = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _pressed = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _pressed = false;
          });
        },
        onTapUp: (_) {
          setState(() {
            _pressed = false;
          });
          downloadURL(widget.attachment.url);
        },
        child: previewTile,
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
