import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

enum FilterOptions{
  Favourites,
  All,
}
class ProductsOverviewScreen extends StatefulWidget{

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
   var _showOnlyFavourites = false;

  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('MyShop'),
       actions: <Widget>[
         PopupMenuButton(
           onSelected: (FilterOptions SelectedValue){
             setState(() {
               if(SelectedValue ==FilterOptions.Favourites)
               {
                 _showOnlyFavourites = true;
               }
               else
               {
                 _showOnlyFavourites = false;

               }
             });
            },
           icon: Icon(Icons.more_vert),
           itemBuilder: (_) => [
             PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.Favourites,),
             PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,),
           ],
         ),
         Consumer<Cart>(builder: (_, cart, ch) => Badge(
           child: ch,
            value: cart.itemCount.toString(),
            ),
           child: IconButton(      // this part will not rebuild on cart changes
             icon: Icon(
                 Icons.shopping_cart
             ),
             onPressed: () {
               Navigator.of(context).pushNamed(CartScreen.routeName,);
            },
           ),
            ),
           ],
            ),
           drawer: AppDrawer(),
     body: ProductsGrid(_showOnlyFavourites),
    );
  }
}

