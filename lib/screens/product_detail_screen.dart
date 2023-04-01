import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/products_provider.dart';

class Productdetail extends StatelessWidget {
  // final String title;
  // Productdetail(this.title);

  //
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
          ),
          Text('\$${loadedProduct.price}'),
          Text(loadedProduct.description),
        ],
      ),
    );
  }
}
