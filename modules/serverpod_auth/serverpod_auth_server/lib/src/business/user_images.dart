import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_auth_server/src/business/users.dart';

import 'config.dart';

class UserImages {
  static Future<bool> setUserImageFromUrl(Session session, int userId, Uri url) async {
    var result = await http.get(url);
    var bytes = result.bodyBytes;
    return await setUserImageFromBytes(session, userId, bytes);
  }

  static Future<bool> setUserImageFromBytes(Session session, int userId, Uint8List bytes) async {
    var image = decodeImage(bytes);
    if (image == null)
      return false;

    var imageSize = AuthConfig.current.userImageSize;
    if (image.width != imageSize || image.height != imageSize)
      image = copyResizeCropSquare(image, imageSize);

    var format = AuthConfig.current.userImageFormat;
    List<int> encoded;
    if (format == UserImageType.jpg)
      encoded = encodeJpg(image, quality: AuthConfig.current.userImageQuality);
    else
      encoded = encodePng(image);

    // Reference as ByteData.
    var encodedBytes = Uint8List.fromList(encoded);
    var imageData = ByteData.view(encodedBytes.buffer);

    return await _setUserImage(session, userId, imageData);
  }

  static Future<bool> _setUserImage(Session session, int userId, ByteData imageData) async {
    // Find the latest version of the user image if any.
    var oldImageRef = await session.db.findSingleRow(
      tUserImage,
      where: tUserImage.userId.equals(userId),
      orderDescending: true,
      orderBy: tUserImage.version,
    ) as UserImage?;
    
    // Add one to the version number or create a new version 1.
    var version = (oldImageRef?.version ?? 0) + 1;

    String pathExtension;
    if (AuthConfig.current.userImageFormat == UserImageType.jpg)
      pathExtension = '.jpg';
    else
      pathExtension = '.png';
    
    // Store the image.
    var path = 'serverpod/user_images/$userId-$version$pathExtension';
    await session.storage.storeFile(storageId: 'public', path: path, byteData: imageData);
    var publicUrl = await session.storage.getPublicUrl(storageId: 'public', path: path);
    if (publicUrl == null)
      return false;

    // Store the path to the image.
    var imageRef = UserImage(userId: userId, version: version, url: publicUrl.toString());
    await session.db.insert(imageRef);

    // Update the UserInfo with the new image path.
    var user = await Users.findUserByUserId(session, userId);
    if (user == null)
      return false;
    user.imageUrl = publicUrl.toString();
    await session.db.update(user);
    
    return true;
  }
}

class UserImageException extends IOException {
  final String message;
  UserImageException(this.message);

  @override
  String toString() {
    return 'UserImageException: $message';
  }
}