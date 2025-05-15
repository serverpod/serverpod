import 'dart:isolate';

import 'package:image/image.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/util/roboto_138_fnt.dart';

var _defaultUserImageColors = <int>[
  _colorFromHexStr('D32F2F'),
  _colorFromHexStr('D81B60'),
  _colorFromHexStr('AB47BC'),
  _colorFromHexStr('7E57C2'),
  _colorFromHexStr('5C6BC0'),
  _colorFromHexStr('1976D2'),
  _colorFromHexStr('0277BD'),
  _colorFromHexStr('006064'),
  _colorFromHexStr('00796B'),
  _colorFromHexStr('2E7D32'),
  _colorFromHexStr('33691E'),
  _colorFromHexStr('BF360C'),
  _colorFromHexStr('8D6E63'),
  _colorFromHexStr('546E7A'),
];

int _colorFromHexStr(final String hexStr) {
  return int.parse(hexStr, radix: 16) | 0xff000000;
}

/// The default [UserImageGenerator], mimics the default avatars used by Google.
Future<Image> defaultUserImageGenerator(final UserProfileModel userInfo) {
  return Isolate.run(() {
    final imageSize = UserProfileConfig.current.userImageSize;
    final image = Image(width: 256, height: 256);

    final font = roboto_138;

    // Get first letter of the user name (or * if not found in bitmap font).
    final name = userInfo.userName ?? '';
    var charCode = (name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '*')
        .codeUnits[0];
    if (font.characters[charCode] == null) charCode = '*'.codeUnits[0];

    // Draw the image.
    final chWidth = font.characters[charCode]!.width;
    final chHeight = font.characters[charCode]!.height;
    final chOffsetY = font.characters[charCode]!.yOffset;
    final chOffsetX = font.characters[charCode]!.xOffset;
    final xPos = 128 - chWidth ~/ 2;
    final yPos = 128 - chHeight ~/ 2;

    // Pick color based on user id from the default colors (from material design).
    final color = _defaultUserImageColors[
        userInfo.authUserId.hashCode % _defaultUserImageColors.length];
    fill(image,
        color: ColorUint8.rgba((color >> 16) & 0xff, (color >> 16) & 0xff,
            color & 0xff, (color >> 24) & 0xff));

    // Draw the character on top of the solid filled image.
    drawString(
      image,
      String.fromCharCode(charCode),
      font: font,
      x: xPos - chOffsetX,
      y: yPos - chOffsetY,
    );

    // Resize image if it's not the preferred size.
    return imageSize == 256
        ? image
        : copyResizeCropSquare(image, size: imageSize);
  });
}
