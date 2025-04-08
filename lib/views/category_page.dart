// lib/views/category_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sabat_sfakys/services/category_service.dart';
import 'package:sabat_sfakys/models/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    try {
      List<Category> categories = await _categoryService.getAllCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  _deleteCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      setState(() {
        _categories.removeWhere((category) => category.id == id);
      });
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer la catégorie');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erreur: $_errorMessage'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(category.name),
                        subtitle: Text(category.description),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteCategory(category.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
