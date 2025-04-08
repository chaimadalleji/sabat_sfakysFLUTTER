import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/services/category_service.dart';
import '../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryService _categoryService = CategoryService();
  bool _isLoading = true;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    try {
      await _categoryService.getAllCategories();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Erreur', 'Impossible de charger les catégories');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/categories');
        break;
      case 2:
        Get.toNamed('/favorites');
        break;
      case 3:
        Get.toNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo
            Image.asset('assets/logo (1).png', height: 40),

            SizedBox(width: 10),

            // Recherche
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  isDense: true,
                ),
              ),
            ),

            SizedBox(width: 10),

            // 🛒 Icône Panier
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Get.toNamed('/cart'); // redirection vers la page panier
              },
            ),

            // ☰ Menu
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  final AuthController authController = Get.find<AuthController>();
                  authController.logout();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Déconnexion'),
                ),
              ],
              icon: Icon(Icons.menu),
            ),
          ],
        ),
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text('Contenu principal de la page d\'accueil')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/create-article');
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.category, color: _selectedIndex == 1 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(1),
            ),
            SizedBox(width: 40), // Espace pour le bouton "+"
            IconButton(
              icon: Icon(Icons.favorite, color: _selectedIndex == 2 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.green : Colors.grey),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
