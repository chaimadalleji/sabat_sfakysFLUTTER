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
    setState(() {
      isLoading = true;
    });
    
    try {
      Map<String, dynamic> result = await PhotoService.uploadPhoto(photo);
      
      if (result['success'] == false) {
        throw Exception(result['error']);
      }
      
      // Reload photos after upload
      await _loadPhotos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo téléchargée avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du téléchargement: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : Obx(() {
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
                final imageUrl = 'http://localhost:8080/photo/file/${photo.name}';
                
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50),
                              SizedBox(height: 10),
                              Text("Impossible de charger l'image", 
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
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
                      // Ajout d'un bouton de suppression
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white, size: 20),
                            onPressed: () {
                              photoController.openDeleteModal(photo.name);
                            },
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(8),
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