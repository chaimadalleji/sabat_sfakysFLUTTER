import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/controllers/auth_controller.dart';
import 'package:sabat_sfakys/views/CartPage.dart';
import 'package:sabat_sfakys/views/CreateArticlePage.dart';
import 'package:sabat_sfakys/views/ListArticlePage.dart';
import 'package:sabat_sfakys/views/ProfilePage.dart';
import 'package:sabat_sfakys/views/register_Client_View.dart';
import 'package:sabat_sfakys/views/category_page.dart';
import 'package:sabat_sfakys/views/home_page.dart';
import 'package:sabat_sfakys/views/login_vendeur_view.dart';
import 'package:sabat_sfakys/views/register_vendeur_view.dart';
import 'package:sabat_sfakys/views/welcome_view.dart';
import 'package:sabat_sfakys/views/login_client_view.dart';
import 'package:sabat_sfakys/views/create_photo_view.dart'; // Importation de CreatePhotoView
import 'package:sabat_sfakys/views/photo_view.dart'; // Importation de PhotoView
import 'services/api_service.dart';

void main() {
   // 🔥 Injection du AuthController
  Get.put(AuthController()); // ou Get.lazyPut(() => AuthController());

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
        GetPage(name: '/create-photo', page: () => CreatePhotoView()), // Nouvelle route pour CreatePhotoView
        GetPage(name: '/photo-view', page: () => PhotoView(photo: File(""))), // Nouvelle route pour PhotoView
           GetPage(name: '/categories', page: () => CategoryPage()),
   // GetPage(name: '/favorites', page: () => FavoritePage()),
    GetPage(name: '/profile', page: () => ProfilePage()),
    GetPage(name: '/articles', page: () => ListArticlePage()), // ✅ ici tu mets ListArticlePage
    GetPage(name: '/create-article', page: () => CreateArticlePage()),
    GetPage(name: '/cart', page: () => CartPage()),


      ],
    );
  }
}
