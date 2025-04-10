import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/controllers/auth_controller.dart';
import 'package:sabat_sfakys/controllers/photo_controller.dart'; // Ajout du contrôleur photo
import 'package:sabat_sfakys/views/CartPage.dart';
import 'package:sabat_sfakys/views/CreateArticlePage.dart';
import 'package:sabat_sfakys/views/ListArticlePage.dart';
import 'package:sabat_sfakys/views/ProfilePage.dart';
import 'package:sabat_sfakys/views/PhotoListPage.dart';
import 'package:sabat_sfakys/views/register_Client_View.dart';
import 'package:sabat_sfakys/views/category_page.dart';
import 'package:sabat_sfakys/views/home_page.dart';
import 'package:sabat_sfakys/views/login_vendeur_view.dart';
import 'package:sabat_sfakys/views/register_vendeur_view.dart';
import 'package:sabat_sfakys/views/welcome_view.dart';
import 'package:sabat_sfakys/views/login_client_view.dart';
import 'package:sabat_sfakys/views/create_photo_page.dart';
import 'package:sabat_sfakys/bindings/photo_binding.dart'; // Ajout du binding photo
import 'services/api_service.dart';

void main() {
  // Injection des contrôleurs
  Get.put(AuthController());
  Get.put(PhotoController()); // Ajout du PhotoController dès le démarrage si nécessaire

  ApiService.setupInterceptor();
  runApp(SabatSfakysApp());
}

class SabatSfakysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabat Sfakys',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomeView()),
        GetPage(name: '/categories', page: () => CategoryPage()),
        GetPage(name: '/login-client', page: () => LoginClientView()),
        GetPage(name: '/login-vendeur', page: () => LoginVendeurPage()),
        GetPage(name: '/register-client', page: () => RegisterClientView()),
        GetPage(name: '/home-client', page: () => HomePage()),
        GetPage(name: '/home-vendeur', page: () => HomePage()),
        GetPage(name: '/register-vendeur', page: () => RegisterVendeurView()),
        
        // Configuration des routes pour la gestion des photos avec binding
        GetPage(
          name: '/photo', 
          page: () => PhotoListPage(),
          binding: PhotoBinding(),
        ),
        GetPage(
          name: '/createPhoto', 
          page: () => CreatePhotoPage(),
          binding: PhotoBinding(),
        ),
        GetPage(
          name: '/editPhoto/:id',
          page: () => CreatePhotoPage(), 
          binding: PhotoBinding(),
        ),
        
        GetPage(name: '/categories', page: () => CategoryPage()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/articles', page: () => ListArticlePage()),
        GetPage(name: '/create-article', page: () => CreateArticlePage()),
        GetPage(name: '/cart', page: () => CartPage()),
      ],
    );
  }
}