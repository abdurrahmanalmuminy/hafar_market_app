import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class UploadedImageUrls {
  final String originalUrl;
  final String thumbnailUrl;
  UploadedImageUrls({required this.originalUrl, required this.thumbnailUrl});
}

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UploadedImageUrls> uploadOfferImage({
    required String userId,
    required Uint8List imageBytes,
    String contentType = 'image/jpeg',
  }) async {
    // Create compressed original and thumbnail
    final img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw Exception('Invalid image data');
    }

    // Resize if very large
    final img.Image resized = img.copyResize(
      decoded,
      width: decoded.width > 2048 ? 2048 : decoded.width,
      height: decoded.height > 2048 ? 2048 : decoded.height,
      interpolation: img.Interpolation.average,
    );

    final img.Image thumb = img.copyResize(
      decoded,
      width: 300,
      height: (300 * decoded.height / decoded.width).round(),
      interpolation: img.Interpolation.average,
    );

    final Uint8List originalJpg = Uint8List.fromList(
      img.encodeJpg(resized, quality: 85),
    );
    final Uint8List thumbJpg = Uint8List.fromList(
      img.encodeJpg(thumb, quality: 80),
    );

    final String imageId = const Uuid().v4();
    final String basePath = 'offers/$userId/$imageId';

    final Reference originalRef = _storage.ref('$basePath.jpg');
    final Reference thumbRef = _storage.ref('offers/$userId/thumbnails/${imageId}_thumb.jpg');

    final SettableMetadata meta = SettableMetadata(contentType: contentType);

    await originalRef.putData(originalJpg, meta);
    await thumbRef.putData(thumbJpg, meta);

    final String originalUrl = await originalRef.getDownloadURL();
    final String thumbnailUrl = await thumbRef.getDownloadURL();

    return UploadedImageUrls(originalUrl: originalUrl, thumbnailUrl: thumbnailUrl);
  }
}


