// Exemple simple à mettre dans /pages/cart_page.dart
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon Panier')),
      body: Center(child: Text('Contenu du panier ici')),
    );
  }
}
