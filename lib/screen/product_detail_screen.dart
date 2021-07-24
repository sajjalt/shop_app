import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  // final String title;
  // ProductDetailScreen(this.title);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
              height: 300,
              width: double.infinity,
            ),
            SizedBox(
              height:10,
            ),
            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  loadedProduct.title,
                  style: TextStyle(fontSize: 20),
                ),
                Text('Price : ${loadedProduct.price}',style: TextStyle(fontSize: 20),)
              ],
            ),
          Divider(),
          Text(loadedProduct.description,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
