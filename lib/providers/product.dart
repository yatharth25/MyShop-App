import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url =
        'https://myshop-fef51-default-rtdb.firebaseio.com/products/$id.json?auth=$token';
    try {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'siFavorite': isFavorite,
          }));
    } catch (error) {
      isFavorite = oldStatus;
    }

    notifyListeners();
  }
}
