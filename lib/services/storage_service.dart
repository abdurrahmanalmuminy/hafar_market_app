import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UploadedImageUrls {
  final String originalUrl;
  final String thumbnailUrl;
  UploadedImageUrls({required this.originalUrl, required this.thumbnailUrl});
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask? _uploadTask;

  Future<String> uploadOfferImage({
    required String userId,
    required PlatformFile pickedImage,
  }) async {
    if (pickedImage.path == null) {
      throw Exception('Image file path is null');
    }

    try {
      final ext = pickedImage.extension ?? 'jpg';
      final imageId = const Uuid().v4();
      final filename = "$imageId.$ext";
      final path = "offers/$userId/$filename";
      final file = File(pickedImage.path!);

      final ref = _storage.ref().child(path);

      final metadata = SettableMetadata(
        contentType: 'image/${pickedImage.extension ?? 'jpeg'}',
        customMetadata: {'picked-file-path': file.path},
      );

      _uploadTask = ref.putData(await file.readAsBytes(), metadata);

      await _uploadTask!.whenComplete(() async {});

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }
}


