import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget{
  static const routeName= '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState(){                               //fetch in initState is good since it runs only once
//    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        _isLoading = true;
      });
     Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_) { //no need for future delayed with listen set to false
       setState(() {
         _isLoading = false;
       });
     });
//    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData= Provider.of<Orders>(context);
     return Scaffold(
       appBar: AppBar(
         title: Text('Your Orders'),
       ),
       drawer: AppDrawer(),
       body: _isLoading ? Center(
         child: CircularProgressIndicator())
       : ListView.builder(
           itemCount: orderData.orders.length,
           itemBuilder: (ctx,i) => OrderItem(orderData.orders[i]),),
     );
  }
}