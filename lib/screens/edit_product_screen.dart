import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/editproduct';
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descripationFocusNode = FocusNode();
  final _imageEditingController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _init = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    _imgUrlFocusNode.addListener(_updateImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_init) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageEditingController.text = _editedProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

//dispose focus node after use
  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_updateImgUrl);
    _priceFocusNode.dispose();
    _descripationFocusNode.dispose();
    _imageEditingController.dispose();
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImgUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      if ((!_imageEditingController.text.startsWith('http') &&
              !_imageEditingController.text.startsWith('https')) ||
          (!_imageEditingController.text.endsWith('png') &&
              !_imageEditingController.text.endsWith('jpg') &&
              !_imageEditingController.text.endsWith("jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }

    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    // ignore: unnecessary_null_comparison
    if (_editedProduct.id == '') {
      // Provider.of<Products>(context, listen: false)
      //     .updateExistingProduct(_editedProduct.id, _editedProduct);
      // print('update product');
      print('new product');
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Error occured'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('ok'))
                  ],
                ));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      // print('new product');
      // Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      Provider.of<Products>(context, listen: false)
          .updateExistingProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      print('update product');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit product'),
          actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))]),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value.toString(),
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descripationFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite,
                              price: double.parse(value!));
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter price.";
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number greater than zero.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descripationFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value.toString(),
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter descripation";
                          }
                          if (value.length < 10) {
                            return "Please enter at least 10 character";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 10, right: 8),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageEditingController.text.isEmpty
                                ? Center(child: Text('Enter Img Url'))
                                : FittedBox(
                                    child: Image.network(
                                        _imageEditingController.text),
                                    fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: TextFormField(
                                //initialValue: _initValues['imageUrl'] ?? '',
                                decoration:
                                    InputDecoration(labelText: "Img Url"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageEditingController,
                                focusNode: _imgUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      imageUrl: value.toString(),
                                      price: _editedProduct.price,
                                      isFavorite: _editedProduct.isFavorite);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter image Url";
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return "Please enter valid Url";
                                  }
                                  if (!value.endsWith('png') &&
                                      !value.endsWith('jpg') &&
                                      !value.endsWith("jpeg")) {
                                    return 'PLease enter valid url';
                                  }
                                  return null;
                                }),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
