import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product.dart';
import 'package:shopapp/provider/products_provider.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // variable for showing only favorite
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(
      context,
    );
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                //print(selectedValue);

                setState(() {
                  if (selectedValue == FilterOptions.favorite) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('only favorite'),
                        value: FilterOptions.favorite),
                    PopupMenuItem(
                        child: Text('show all'), value: FilterOptions.all),
                  ]),
          Consumer(
              builder: (BuildContext context, Cart, Widget? child) => Badg(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      icon: const Icon(Icons.shopping_cart)),
                  value: cart.itemcount.toString(),
                  color: Colors.pinkAccent)),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
