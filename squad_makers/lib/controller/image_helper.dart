import 'dart:io';
import 'package:image/image.dart';

File getResizedProfileImage(File originImage) {
  Image? image = decodeImage(originImage.readAsBytesSync());
  Image resizedImage = copyResizeCropSquare(image!, size: 200);

  File resizedFile =
      File(originImage.path.substring(0, originImage.path.length));
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 70));
  return resizedFile;
}

File getResizedImage(File originImage) {
  Image? image = decodeImage(originImage.readAsBytesSync());
  Image resizedImage = copyResizeCropSquare(image!, size: 400);

  File resizedFile =
      File(originImage.path.substring(0, originImage.path.length));
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50));
  return resizedFile;
}
