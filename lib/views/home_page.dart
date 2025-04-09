import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/services/ArticleService.dart';
import 'package:sabat_sfakys/services/category_service.dart';
import '../controllers/auth_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryService _categoryService = CategoryService();
  final ArticleService _articleService = ArticleService();
  bool _isLoading = true;
  List<String> _photos = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      await _categoryService.getAllCategories();
      final photos = await _articleService.getAllPhotos();
      setState(() {
        _photos = photos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('Erreur', 'Impossible de charger les photos: $e');
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
          : _buildPhotoGrid(),

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

  Widget _buildPhotoGrid() {
    if (_photos.isEmpty) {
      return Center(child: Text('Aucune photo disponible'));
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final photoUrl = _photos[index];
        return _buildPhotoCard(photoUrl);
      },
    );
  }

  Widget _buildPhotoCard(String photoUrl) {
    // Si l'URL ne commence pas par http, on ajoute le baseUrl
    if (photoUrl.isNotEmpty && !photoUrl.startsWith('http')) {
      photoUrl = 'http://localhost:8080$photoUrl';
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Afficher l'image en plein écran ou naviguer vers un détail
          Get.to(() => _buildFullScreenImage(photoUrl));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print("❌ Erreur de chargement d'image: $error");
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenImage(String photoUrl) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            photoUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Impossible de charger l\'image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}