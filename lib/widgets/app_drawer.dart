import 'package:flutter/material.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,       // it will never show a back button
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
           Navigator.of(context).pushReplacementNamed('/');
            },
           ),
           Divider(),
           ListTile(
           leading: Icon(Icons.payment),
           title: Text('Orders'),
           onTap: () {
             Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
           },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();     //in case drawer is open,the hard reset of widgets can lead to error
              Navigator.of(context).pushReplacementNamed('/');     //so that we always go to home route and auth.isAuth logic always run
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}