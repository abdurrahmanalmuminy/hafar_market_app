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

    final SettableMetadata meta = SettableMetadata(contentType: contentType);

    String _newImageId() => const Uuid().v4();

    Future<Reference> _putWithPathRetry({
      required String initialPath,
      required Uint8List data,
      required SettableMetadata metadata,
    }) async {
      const int maxAttempts = 3;
      int attempt = 0;
      String currentPath = initialPath;
      while (true) {
        try {
          final ref = _storage.ref().child(currentPath);
          await ref.putData(data, metadata);
          return ref;
        } catch (e) {
          attempt++;
          if (attempt >= maxAttempts) rethrow;
          final errorText = e.toString();
          // If we hit a 412 precondition failed (seen on iOS), regenerate a fresh path
          if (errorText.contains('412')) {
            // place under a fresh id to avoid any stalled resumable upload session conflicts
            final String newId = _newImageId();
            final String parentDir = initialPath.substring(0, initialPath.lastIndexOf('/'));
            final String fileName = initialPath.substring(initialPath.lastIndexOf('/') + 1);
            final String ext = fileName.contains('.') ? fileName.split('.').last : 'jpg';
            final String prefix = fileName.contains('.') ? fileName.split('.').first : 'image';
            currentPath = '$parentDir/${prefix}_$newId.$ext';
          }
          // Exponential backoff: 300ms, 800ms
          final int delayMs = attempt == 1 ? 300 : 800;
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }
    }

    // Create initial paths
    final String imageId = _newImageId();
    final String originalPath = 'offers/$userId/$imageId.jpg';
    final String thumbPath = 'offers/$userId/thumbnails/${imageId}_thumb.jpg';

    final Reference finalOriginalRef = await _putWithPathRetry(
      initialPath: originalPath,
      data: originalJpg,
      metadata: meta,
    );
    final Reference finalThumbRef = await _putWithPathRetry(
      initialPath: thumbPath,
      data: thumbJpg,
      metadata: meta,
    );

    final String originalUrl = await finalOriginalRef.getDownloadURL();
    final String thumbnailUrl = await finalThumbRef.getDownloadURL();

    return UploadedImageUrls(originalUrl: originalUrl, thumbnailUrl: thumbnailUrl);
  }
}


