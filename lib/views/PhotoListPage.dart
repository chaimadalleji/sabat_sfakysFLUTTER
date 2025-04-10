import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/services/photo_service.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart';

class PhotoListPage extends StatefulWidget {
  final File? photo;
  
  const PhotoListPage({Key? key, this.photo}) : super(key: key);

  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final PhotoController photoController = Get.put(PhotoController());
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadPhotos();
    
    // If a photo was passed, upload it
    if (widget.photo != null) {
      _uploadPhoto(widget.photo!);
    }
  }

  Future<void> _loadPhotos() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    
    try {
      await photoController.getPhotos();
    } catch (e) {
      setState(() {
        error = 'Erreur lors du chargement des photos: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _uploadPhoto(File photo) async {
    try {
      await PhotoService.uploadPhoto(photo);
      // Reload photos after upload
      _loadPhotos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo téléchargée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du téléchargement: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galerie de Photos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadPhotos,
          ),
        ],
      ),
      body: Obx(() {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (error.isNotEmpty) {
          return Center(child: Text(error, style: TextStyle(color: Colors.red)));
        }
        
        if (photoController.photos.isEmpty) {
          return Center(child: Text('Aucune photo disponible'));
        }
        
        return GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: photoController.photos.length,
          itemBuilder: (context, index) {
            final photo = photoController.photos[index];
            // Construire l'URL complète pour l'image
            final imageUrl = 'http://localhost:8080/upload/${photo.name}';
            
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.broken_image, size: 50));
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Text(
                        photo.name,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/createPhoto'),
        child: Icon(Icons.add_a_photo),
        tooltip: 'Ajouter une photo',
      ),
    );
  }
}