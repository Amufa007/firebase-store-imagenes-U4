import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger('ImageService');

  ImageService() {
    Logger.root.level = Level.ALL; // Configura el nivel de logging
    Logger.root.onRecord.listen((record) {
      Logger('${record.level.name}: ${record.time}: ${record.message}'); // Reemplaza con un método de logging adecuado en producción
    });
  }

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (cameraStatus.isDenied || galleryStatus.isDenied) {
      _logger.severe('Permisos necesarios para la cámara o la galería fueron denegados.');
    }
  }

  Future<XFile?> getImageFromGallery() async {
    await requestPermissions(); // Solicita permisos antes de intentar acceder a la galería
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> getImageFromCamera() async {
    await requestPermissions(); // Solicita permisos antes de intentar acceder a la cámara
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      final ref = _storage.ref().child('images/${DateTime.now().toIso8601String()}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      _logger.severe('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> fetchImageUrls() async {
    try {
      final ref = _storage.ref().child('images');
      final ListResult result = await ref.listAll();
      final urls = await Future.wait(result.items.map((item) => item.getDownloadURL()));
      return urls;
    } catch (e) {
      _logger.severe('Error fetching image URLs: $e');
      return [];
    }
  }
}






