import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();
  
  // Cette fonction retourne un widget qui affiche l'image, peu importe la plateforme
  Widget getImageWidget({required dynamic imageData, double? width, double? height}) {
    if (kIsWeb) {
      if (imageData is Uint8List) {
        return Image.memory(
          imageData,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } else if (imageData is String && (imageData.startsWith('http') || imageData.startsWith('https'))) {
        return Image.network(
          imageData,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    } else {
      if (imageData is File) {
        return Image.file(
          imageData,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } else if (imageData is String && (imageData.startsWith('http') || imageData.startsWith('https'))) {
        return Image.network(
          imageData,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    }
    
    // Image par défaut si aucune condition n'est remplie
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  // Cette fonction permet de sélectionner une image depuis la galerie
  Future<dynamic> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile == null) return null;
    
    if (kIsWeb) {
      // Pour le Web, nous retournons les bytes
      return await pickedFile.readAsBytes();
    } else {
      // Pour Mobile, nous retournons le File
      return File(pickedFile.path);
    }
  }

  // Cette fonction permet de prendre une photo avec la caméra
  Future<dynamic> pickImageFromCamera() async {
    // La caméra n'est pas disponible sur le Web de la même manière
    if (kIsWeb) {
      // Sur certains navigateurs modernes, on peut utiliser la camera
      // Mais c'est plus limité, donc on reste sur gallery pour le web
      return await pickImageFromGallery();
    }
    
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  // Télécharger l'image sur un serveur
  Future<bool> uploadImage(dynamic imageData, String uploadUrl) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      
      if (kIsWeb) {
        if (imageData is Uint8List) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              imageData,
              filename: 'image.jpg',
            ),
          );
        }
      } else {
        if (imageData is File) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              imageData.path,
            ),
          );
        }
      }
      
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de l\'upload: $e');
      return false;
    }
  }
  
  // Télécharger une image depuis une URL et la convertir au format approprié
  Future<dynamic> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        
        if (kIsWeb) {
          return bytes;
        } else {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(bytes);
          return file;
        }
      }
      return null;
    } catch (e) {
      print('Erreur lors du téléchargement: $e');
      return null;
    }
  }
}

// Widget d'exemple pour utiliser le service
class ImagePickerWidget extends StatefulWidget {
  final String uploadUrl;
  
  const ImagePickerWidget({Key? key, required this.uploadUrl}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImageUploadService _service = ImageUploadService();
  dynamic _selectedImage;
  bool _isUploading = false;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedImage == null
              ? const Center(child: Text('Aucune image sélectionnée'))
              : _service.getImageWidget(
                  imageData: _selectedImage,
                  width: 200,
                  height: 200,
                ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Galerie'),
              onPressed: () async {
                final image = await _service.pickImageFromGallery();
                if (image != null) {
                  setState(() {
                    _selectedImage = image;
                  });
                }
              },
            ),
            const SizedBox(width: 16),
            if (!kIsWeb) // Afficher le bouton de caméra uniquement sur les plateformes mobiles
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Caméra'),
                onPressed: () async {
                  final image = await _service.pickImageFromCamera();
                  if (image != null) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }
                },
              ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.cloud_upload),
          label: _isUploading 
              ? const Text('Téléchargement en cours...') 
              : const Text('Télécharger'),
          onPressed: _selectedImage == null || _isUploading
              ? null
              : () async {
                  setState(() {
                    _isUploading = true;
                  });
                  
                  final success = await _service.uploadImage(
                    _selectedImage,
                    widget.uploadUrl,
                  );
                  
                  setState(() {
                    _isUploading = false;
                  });
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Image téléchargée avec succès!'
                              : 'Échec du téléchargement',
                        ),
                      ),
                    );
                  }
                },
        ),
      ],
    );
  }
}

// Exemple d'utilisation dans une page
class ImageUploadPage extends StatelessWidget {
  const ImageUploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Téléchargement d\'images'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ImagePickerWidget(
            uploadUrl: 'https://votre-api.com/upload',
          ),
        ),
      ),
    );
  }
}