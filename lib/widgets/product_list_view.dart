import 'package:flutter/material.dart';
import '../provider/products_provider.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

class ProductListView extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  ProductListView(
      {required this.imageUrl, required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$title'),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 97,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProduct.routeName,
                      arguments: id);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                )),
            IconButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
