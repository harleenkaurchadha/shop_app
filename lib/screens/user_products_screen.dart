import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget{
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false,).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
  //  final productsData= Provider.of<Products>(context);           //otherwise we will go into infinite loop
    print('rebuilding');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);     //we have not used replacement since we want to push on stack of pages & back on current page then
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(                              // we used it since we need to load only user specific products as soon as screen is presented
        future: _refreshProducts(context),                     //future to which futureBuilder should wait
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(
          child: CircularProgressIndicator(),
        )
            :RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(                              // we used it so that only this part rebuilds
            builder: (ctx, productsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_,i) => Column(
                  children : [
                    UserProductItem(
                  productsData.items[i].id,
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
              ),
              Divider(),
              ],
              ),
              ),
            ),
          ),
        ),
      ),
    );









  }
}