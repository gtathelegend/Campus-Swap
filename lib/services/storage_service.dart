import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final _client = Supabase.instance.client;
  final _picker = ImagePicker();

  static const _bucket = 'products';

  /// Pick image from gallery or camera.
  Future<XFile?> pickImage({bool fromCamera = false}) async {
    return _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80,
    );
  }

  /// Pick multiple images from gallery.
  Future<List<XFile>> pickMultipleImages() async {
    final files = await _picker.pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80,
    );
    return files;
  }

  /// Upload a single image to Supabase Storage. Returns public URL.
  Future<String> uploadProductImage(XFile file, String productId) async {
    final userId = _client.auth.currentUser?.id ?? 'anonymous';
    final ext = file.path.split('.').last;
    final fileName =
        '$userId/$productId/${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _client.storage.from(_bucket).upload(
          fileName,
          File(file.path),
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from(_bucket).getPublicUrl(fileName);
  }

  /// Upload multiple images and return list of public URLs.
  Future<List<String>> uploadProductImages(
      List<XFile> files, String productId) async {
    final urls = <String>[];
    for (final file in files) {
      final url = await uploadProductImage(file, productId);
      urls.add(url);
    }
    return urls;
  }

  /// Upload avatar image for current user. Returns public URL.
  Future<String> uploadAvatar(XFile file) async {
    final userId = _client.auth.currentUser?.id ?? 'anonymous';
    final ext = file.path.split('.').last;
    final fileName = 'avatars/$userId.$ext';

    await _client.storage.from('avatars').upload(
          fileName,
          File(file.path),
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('avatars').getPublicUrl(fileName);
  }

  /// Delete a file by its URL path.
  Future<void> deleteFile(String url, {bool isAvatar = false}) async {
    try {
      final bucket = isAvatar ? 'avatars' : _bucket;
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(bucket);
      if (bucketIndex != -1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        await _client.storage.from(bucket).remove([filePath]);
      }
    } catch (_) {
      // Silently ignore deletion errors
    }
  }
}
