import 'package:image_picker/image_picker.dart';
import 'package:squad_makers/controller/storage_controller.dart';

ImagePickUploader imagePickUploader = ImagePickUploader();

class ImagePickUploader {
  final _picker = ImagePicker();
  Future<String?> pickAndUpload(
    String uploadPath,
  ) async {
    try {
      XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      print(image?.path ?? 'null');
      if (image != null) {
        var result = await storageController.uploadFile(
          filePath: image.path,
          uploadPath: uploadPath,
        );

        return result;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<XFile?> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    } else {
      return null;
    }
  }
}
