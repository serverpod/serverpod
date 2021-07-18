import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:flutter/material.dart';

import 'package:serverpod_auth_client/module.dart';

import 'session_manager.dart';
import 'circular_user_image.dart';

class UserImageButton extends StatefulWidget {
  final Caller caller;
  final SessionManager sessionManager;

  final bool compact;
  final double elevation;
  final double borderWidth;
  final Color borderColor;

  UserImageButton({
    required this.caller,
    required this.sessionManager,
    this.compact = true,
    this.elevation = 0,
    this.borderWidth = 0,
    this.borderColor = Colors.white,
  });

  @override
  State<StatefulWidget> createState() => _UserImageButtonState();
}

class _UserImageButtonState extends State<UserImageButton> {
  UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.sessionManager.signedInUser;
    widget.sessionManager.addListener(_onSessionManagerUpdate);
  }

  void _onSessionManagerUpdate() {
    setState(() {
      _userInfo = widget.sessionManager.signedInUser;
    });
  }

  @override
  void dispose() {
    widget.sessionManager.removeListener(_onSessionManagerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _userInfo != null ? _updateUserImage : null,
      child: Stack(
        children: [
          CircularUserImage(
            userInfo: _userInfo,
            size: widget.compact ? 56 : 168,
            elevation: widget.elevation,
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
          ),
          if (_userInfo != null) Positioned(
            right: widget.compact ? 0 : 12,
            bottom: widget.compact ? 0 : 12,
            child: Container(
              width: widget.compact ? 18: 24,
              height: widget.compact ? 18 : 24,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(widget.compact ? 9 : 12)),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: widget.compact ? 12 : 18,
                  color: Theme.of(context).buttonTheme.colorScheme!.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserImage() async {
    var imageSize = 256;

    var toolbarColor = Theme.of(context).primaryColor;
    var toolbarWidgetColor = Theme.of(context).buttonTheme.colorScheme?.onPrimary ?? Colors.white;

    final picker = ImagePicker();
    // Pick an image
    var imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null)
      return;

    // Crop the image
    var croppedImageFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxHeight: imageSize,
      maxWidth: imageSize,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      cropStyle: CropStyle.circle,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: toolbarColor,
          toolbarWidgetColor: toolbarWidgetColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    if (croppedImageFile == null)
      return;

    // Load and resize
    var image = img.decodeImage(await croppedImageFile.readAsBytes());
    if (image == null)
      return;

    if (image.width != imageSize || image.height != imageSize);
    image = img.copyResize(image, width: imageSize, height: imageSize);

    // Encode as png
    var encoded = img.encodePng(image);
    var bytes = Uint8List.fromList(encoded);
    var data = ByteData.view(bytes.buffer);

    // Upload the image to the server
    await widget.sessionManager.uploadUserImage(data);
  }
}