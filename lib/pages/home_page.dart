
import 'package:flutter/material.dart';
import 'package:logging/logging.dart'; // Importa el paquete para el selector de imágenes
import 'package:flutter_firebase_storage/services/images_service.dart'; // Asegúrate de que este archivo está en tu proyecto
import 'package:permission_handler/permission_handler.dart'; // Importa el paquete de permisos
 // Importa el paquete de permisos

class HomePage extends StatelessWidget {
  final Logger _logger = Logger('HomePage');

  HomePage({
    super.key,
  });

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (cameraStatus.isDenied || galleryStatus.isDenied) {
      _logger.severe('Permisos necesarios para la cámara o la galería fueron denegados.');
    }
  }

  Future<void> getImageFromGallery() async {
    await requestPermissions(); // Solicita permisos antes de intentar acceder a la galería
    final imageService = ImageService();
    final image = await imageService.getImageFromGallery();
    if (image != null) {
      // Manejar la imagen seleccionada
    }
  }

  Future<void> getImageFromCamera() async {
    await requestPermissions(); // Solicita permisos antes de intentar acceder a la cámara
    final imageService = ImageService();
    final image = await imageService.getImageFromCamera();
    if (image != null) {
      // Manejar la imagen capturada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.blue[400],
            margin: const EdgeInsets.all(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: getImageFromGallery, // Llama al método para seleccionar una imagen
                child: const Text("Obtener Fotografía"),
              ),
              ElevatedButton(
                onPressed: getImageFromCamera, // Llama al método para tomar una foto
                child: const Text("Tomar Foto"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




