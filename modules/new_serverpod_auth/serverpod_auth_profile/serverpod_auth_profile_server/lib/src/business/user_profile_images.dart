import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart';
import 'package:serverpod_auth_profile_server/src/generated/user_profile_image.dart';
import 'package:serverpod_auth_profile_server/src/util/roboto_138_fnt.dart';

/// Business logic to handle user images.
abstract final class UserProfileImages {
  /// Sets a user's image from the provided [url].
  ///
  /// The image is downloaded, stored in the cloud and associated with the user.
  static Future<void> setUserImageFromUrl(
    final Session session,
    final UuidValue authUserId,
    final Uri url,
  ) async {
    final result = await http.get(url);
    final bytes = result.bodyBytes;

    await setUserImageFromBytes(session, authUserId, bytes);
  }

  /// Sets a user's image from image data.
  ///
  /// The image is resized before being stored in the cloud and associated with the user.
  static Future<void> setUserImageFromBytes(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes,
  ) async {
    final reEncodedImageBytes = await Isolate.run(() async {
      var image = decodeImage(imageBytes)!;

      final imageSize = UserProfileConfig.current.userImageSize;
      if (image.width != imageSize || image.height != imageSize) {
        image = copyResizeCropSquare(
          image,
          size: imageSize,
          interpolation: Interpolation.average,
        );
      }

      return _encodeImage(image);
    });

    await _setUserImage(session, authUserId, reEncodedImageBytes);
  }

  /// Sets a user's image to the default image for that user.
  static Future<void> setDefaultUserImage(
    final Session session,
    final UuidValue userId,
  ) async {
    final userInfo = await UserProfiles.findUserProfileByUserId(
      session,
      userId,
    );

    final image = await UserProfileConfig.current.userImageGenerator(userInfo);
    final imageBytes = await Isolate.run(() => _encodeImage(image));

    await _setUserImage(session, userId, imageBytes);
  }

  static Uint8List _encodeImage(final Image image) =>
      switch (UserProfileConfig.current.userImageFormat) {
        UserProfileImageType.jpg => encodeJpg(
            image,
            quality: UserProfileConfig.current.userImageQuality,
          ),
        UserProfileImageType.png => encodePng(image),
      };

  static Future<void> _setUserImage(
    final Session session,
    final UuidValue authUserId,
    final Uint8List imageBytes,
  ) async {
    // Find the latest version of the user image if any.
    final oldImageRef = await UserProfileImage.db.findFirstRow(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      orderBy: (final t) => t.version,
      orderDescending: true,
    );

    // Add one to the version number or create a new version 1.
    final version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (UserProfileConfig.current.userImageFormat == UserProfileImageType.jpg) {
      pathExtension = '.jpg';
    } else {
      pathExtension = '.png';
    }

    // Store the image.
    final path = 'serverpod/user_images/$authUserId-$version$pathExtension';
    await session.storage.storeFile(
      storageId: 'public',
      path: path,
      byteData: ByteData.view(imageBytes.buffer),
    );
    final publicUrl = (await session.storage.getPublicUrl(
      storageId: 'public',
      path: path,
    ))!;

    await setUserImageFromOwnedUrl(session, authUserId, version, publicUrl);
  }

  /// Sets the profile image to the given URL, which is presumed to be owned by this application.
  @visibleForTesting
  static Future<void> setUserImageFromOwnedUrl(
    final Session session,
    final UuidValue authUserId,
    final int version,
    final Uri publicUrl,
  ) async {
    var profileImage = UserProfileImage(
      authUserId: authUserId,
      version: version,
      url: publicUrl,
    );

    profileImage = await UserProfileImage.db.insertRow(session, profileImage);

    await UserProfiles.changeImage(session, authUserId, profileImage);
  }
}

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
