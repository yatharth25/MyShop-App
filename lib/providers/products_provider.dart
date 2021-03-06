import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exceptions.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;
  String _username;
  Products(this.authToken, this.userId, this._items);

  String get username {
    return _username;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id, orElse: () => null);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://myshop-fef51-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final uri =
          'https://myshop-fef51-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favResponse = await http.get(Uri.parse(uri));
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchUserName() async {
    final url =
        'https://myshop-fef51-default-rtdb.firebaseio.com/username/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final nameData = json.decode(response.body);
    _username = nameData['name'];
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-fef51-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prodId) => prodId.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-fef51-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-fef51-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prodId) => prodId.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
