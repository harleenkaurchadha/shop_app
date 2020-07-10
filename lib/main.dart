import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (ctx)=> Products(),   //provides instance of class to all child widgets which are interested & the widgets which
      child: MaterialApp(         //which are listening to changes in products class will be rebuild
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}

//class MyHomePage extends StatelessWidget{
//  @override
//  Widget build(BuildContext context){
//    return Scaffold(
//      appBar:AppBar(
//          title: Text('My Shop'),
//      ),
//      body: Center(
//        child: Text('Let\'s build a shop!'),
//      ),
//
//    );
//  }
//}
