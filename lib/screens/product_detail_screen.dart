import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget{
  static const routeName= '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId= ModalRoute.of(context).settings.arguments as String;
     final loadedProduct = Provider.of<Products>(
       context,
       listen: false,                    //since it should not rebuild with updates as this screen is fixed
     ).findById(productId);
     return Scaffold(
       // appBar: AppBar(
       //   title: Text(loadedProduct.title),
       //   ),
       body: CustomScrollView(
         slivers: <Widget>[                                                     //scrollable area on the screen
           SliverAppBar(
             expandedHeight: 300,                                              //height of the image when not converted to appbar
             pinned: true,                                                     //appbar will be visible & stick aat the top when we scroll
             flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),                                 //appbar title
               background: Hero(                                                //part which we can see when expanded
                   tag: loadedProduct.id,
                   child: Image.network(
                     loadedProduct.imageUrl,
                     fit: BoxFit.cover,)
               ),
             ),
           ),
           SliverList(
             delegate: SliverChildListDelegate([                                //delegate tells how to render content of the list
               SizedBox(height: 10,),
               Text('\$${loadedProduct.price}',
                 style: TextStyle(
                   color: Colors.grey,
                   fontSize: 20,
                 ),
                 textAlign: TextAlign.center,
               ),
               SizedBox(height: 10,),
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 10,) ,
                 width: double.infinity,
                 child: Text(
                   loadedProduct.description,
                   textAlign: TextAlign.center,
                   softWrap: true,),
               ),
               SizedBox(height: 800,),                                          //adding a box at bottom to make screen scrollable
             ]),
           ),
         ],
         ),
     );
  }
}