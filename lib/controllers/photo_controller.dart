import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/photo.dart';
import '../services/photo_service.dart' as services;

class PhotoController extends GetxController {
  final services.PhotoService _photoService = services.PhotoService();
  
  RxList<Photo> photos = <Photo>[].obs;
  RxList<dynamic> fileInfos = <dynamic>[].obs;
  RxList<Map<String, dynamic>> progressInfos = <Map<String, dynamic>>[].obs;
  RxString message = ''.obs;
  RxList<File> currentFiles = <File>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    getFiles();
  }

  // Get all photos
  Future<void> getPhotos() async {
    try {
      final List<Photo> result = await _photoService.getPhotos();
      photos.value = result;
    } catch (e) {
      message.value = 'Failed to load photos: $e';
    }
  }

  // Get all files
  Future<void> getFiles() async {
    try {
      final result = await _photoService.getFiles();
      fileInfos.value = result;
    } catch (e) {
      message.value = 'Failed to load files: $e';
    }
  }

  // Select files
  void selectFiles(List<File> files) {
    currentFiles.value = files;
    progressInfos.value = files.map((file) => {
      'value': 0,
      'fileName': file.path.split('/').last
    }).toList();
  }

  // Upload all selected files
  Future<void> upload() async {
    message.value = '';
    
    if (currentFiles.isNotEmpty) {
      for (int i = 0; i < currentFiles.length; i++) {
        await uploadFile(currentFiles[i], i);
      }
    }
  }

  // Upload a single file
  Future<void> uploadFile(File file, int index) async {
    try {
      await _photoService.upload(
        file,
        (sent, total) {
          final progress = (sent / total * 100).round();
          final updatedProgressInfos = [...progressInfos];
          updatedProgressInfos[index]['value'] = progress;
          progressInfos.value = updatedProgressInfos;
        },
      );
      
      message.value = 'Upload success.';
      getFiles();
    } catch (e) {
      final updatedProgressInfos = [...progressInfos];
      updatedProgressInfos[index]['value'] = 0;
      progressInfos.value = updatedProgressInfos;
      
      message.value = 'Could not upload the file ${file.path.split('/').last}';
    }
  }

  // Confirm and delete file
  void openDeleteModal(String fileName) {
    Get.defaultDialog(
      title: 'Confirmation',
      middleText: 'Êtes-vous sûr de vouloir supprimer le fichier $fileName?',
      textConfirm: 'Oui',
      textCancel: 'Non',
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteFile(fileName);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  // Delete a file
  Future<void> deleteFile(String fileName) async {
    try {
      final response = await _photoService.deleteFile(fileName);
      message.value = response;
      getFiles();
    } catch (e) {
      print(e);
      message.value = 'Could not delete the file!';
    }
  }

  // Create multiple photos
  Future<void> createMultiplePhotos(List<Photo> photosList) async {
    try {
      final List<Photo> result = await _photoService.createMultiplePhotos(photosList);
      photos.addAll(result);
    } catch (e) {
      message.value = 'Failed to create photos: $e';
    }
  }

  // Update a photo
  Future<void> updatePhoto(int id, Photo photo) async {
    try {
      final Photo updatedPhoto = await _photoService.updatePhoto(id, photo);
      final index = photos.indexWhere((p) => p.id == id);
      if (index != -1) {
        photos[index] = updatedPhoto;
        photos.refresh();
      }
    } catch (e) {
      message.value = 'Failed to update photo: $e';
    }
  }

  // Delete a photo
  Future<void> deletePhoto(int id) async {
    try {
      await _photoService.deletePhoto(id);
      photos.removeWhere((photo) => photo.id == id);
    } catch (e) {
      message.value = 'Failed to delete photo: $e';
    }
  }

  // Navigate to edit photo
  void navigateToEditPhoto(int photoId) {
    Get.toNamed('/editPhoto/$photoId');
  }

  // Navigate to create photo page
  void redirectToCreatePhoto() {
    Get.toNamed('/createPhoto');
  }

  // Cancel and go back to photo list
  void cancel() {
    Get.back();
  }
}