import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sabat_sfakys/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePhotoPage extends StatefulWidget {
  @override
  _CreatePhotoPageState createState() => _CreatePhotoPageState();
}

class _CreatePhotoPageState extends State<CreatePhotoPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _webImage;
  String? _webImagePath;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        // Pour le web, nous devons lire le fichier différemment
        if (kIsWeb) {
          _readWebImage(pickedFile);
        }
      });
    }
  }

  Future<void> _readWebImage(XFile file) async {
    // Lire les données de l'image pour le web
    final bytes = await file.readAsBytes();
    setState(() {
      _webImage = bytes;
      _webImagePath = file.name;
    });
  }

  void _savePhoto() async {
    // Vérifier si une image a été sélectionnée
    if ((_imageFile == null && !kIsWeb) || (kIsWeb && _webImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une image')),
      );
      return;
    }

    // Vérifier si le titre est renseigné
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un titre')),
      );
      return;
    }

    try {
      // Obtenir les données de l'image
      late Uint8List imageData;
      if (kIsWeb) {
        imageData = _webImage!;
      } else {
        imageData = await _imageFile!.readAsBytes();
      }

      // Créer un objet pour la photo
      Map<String, dynamic> newPhoto = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _titleController.text,
        'description': _descriptionController.text,
        'data': base64Encode(imageData),
      };

      // Sauvegarder dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      // Récupérer les photos existantes
      List<Map<String, dynamic>> photos = [];
      String? existingPhotos = prefs.getString('uploaded_photos');
      
      if (existingPhotos != null) {
        List<dynamic> parsed = jsonDecode(existingPhotos);
        photos = parsed.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      
      // Ajouter la nouvelle photo
      photos.add(newPhoto);
      
      // Sauvegarder la liste mise à jour
      await prefs.setString('uploaded_photos', jsonEncode(photos));

      // Mettre à jour les options de logo dans AuthController
      Get.find<AuthController>().updateLogoOptions();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo enregistrée avec succès')),
      );

      // Retour à la page précédente
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une nouvelle photo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Zone d'affichage de l'image
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _buildImageWidget(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Bouton pour sélectionner une image
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library),
              label: Text('Sélectionner une image'),
            ),
            SizedBox(height: 20.0),
            
            // Champ pour le titre
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre de la photo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            
            // Champ pour la description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optionnel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24.0),
            
            // Bouton de sauvegarde
            ElevatedButton(
              onPressed: _savePhoto,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Enregistrer la photo',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      // Affichage pour Flutter Web
      if (_webImage != null) {
        return Image.memory(
          _webImage!,
          fit: BoxFit.cover,
        );
      }
    } else {
      // Affichage pour mobile
      if (_imageFile != null) {
        return Image.file(
          File(_imageFile!.path),
          fit: BoxFit.cover,
        );
      }
    }

    // Affichage par défaut si aucune image n'est sélectionnée
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 50.0, color: Colors.grey),
          SizedBox(height: 8.0),
          Text(
            'Appuyez pour ajouter une image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}