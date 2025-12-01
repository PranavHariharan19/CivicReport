// File: lib/services/storage_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery or camera
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Pick video from gallery or camera
  Future<File?> pickVideo({ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  // Upload file to Supabase Storage
  Future<String?> uploadFile(File file, String bucketName, String folderPath) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      final String filePath = '$folderPath/$fileName';

      final response = await _supabase.storage
          .from(bucketName)
          .upload(filePath, file);

      // Supabase upload returns the file path, so we construct the URL
      final String publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Upload image specifically
  Future<String?> uploadImage(File image, {String folder = 'images'}) async {
    return await uploadFile(image, 'images', folder);
  }

  // Upload video specifically
  Future<String?> uploadVideo(File video, {String folder = 'videos'}) async {
    return await uploadFile(video, 'videos', folder);
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(File image, String userId) async {
    return await uploadFile(image, 'avatars', 'profile_pictures/$userId');
  }

  // Upload report media (images/videos)
  Future<String?> uploadReportMedia(File file, String reportId) async {
    final String fileExtension = path.extension(file.path).toLowerCase();
    // Use reportId as a unique folder to prevent name clashes and group media
    final String folderPath = 'report_media/$reportId';
    final String fileName = 'media$fileExtension';
    final String filePath = '$folderPath/$fileName';

    try {
      await _supabase.storage.from('reports').upload(filePath, file);

      final String publicUrl = _supabase.storage.from('reports').getPublicUrl(filePath);

      return publicUrl;
    } on StorageException catch (e) {
      // If file already exists, get its public URL
      if (e.statusCode == '409') {
        final String publicUrl = _supabase.storage.from('reports').getPublicUrl(filePath);
        return publicUrl;
      }
      print('Error uploading report media: $e');
      return null;
    } catch (e) {
      print('Error uploading report media: $e');
      return null;
    }
  }

  // Delete file from Supabase Storage
  Future<bool> deleteFile(String filePath, String bucketName) async {
    try {
      await _supabase.storage.from(bucketName).remove([filePath]);
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // Get file metadata (Supabase does not have a direct method like Firebase)
  // You would typically get this from your database after the upload
  Future<void> getFileMetadata(String filePath) async {
    print('Supabase does not have a direct getMetadata method. Metadata is typically stored in your database.');
  }
}