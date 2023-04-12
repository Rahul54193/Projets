import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../widgets/product_list_view.dart';
import 'edit_product_screen.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/userproducts';

  // Future<Void> _pullToRefresh(){

  // };

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        //centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProduct.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => Column(
                  children: [
                    ProductListView(
                      title: productsData.items[index].title,
                      imageUrl: productsData.items[index].imageUrl,
                      id: productsData.items[index].id,
                    ),
                    Divider(),
                  ],
                )),
      ),
    );
  }
}
