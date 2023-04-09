import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favitems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://myshop-7e0d6-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      print('---->>>>${jsonDecode(response.body)}');
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId.toString(),
          title: prodData['title'].toString(),
          description: prodData['description'].toString(),
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'].toString(),
        ));
        _items = loadedProducts;
        notifyListeners();
      });
    } catch (error) {
      print('======>>>>>>$error');
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://myshop-7e0d6-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.patch(url,
          body: jsonEncode({
            'title': product.title,
            'descrption': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));

      print(json.decode(response.body));

      //        https://picsum.photos/200/300.jpg

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('ERROR----->>>$error');
      throw error;
    }

    //assert(product != null);
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> updateExistingProduct(String id, Product newPoduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://myshop-7e0d6-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: jsonEncode({
            'title': newPoduct.title,
            'desccription': newPoduct.description,
            'imageUrl': newPoduct.imageUrl,
            'price': newPoduct.price
          }));
      _items[productIndex] = newPoduct;
    } else {
      print("---");
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
