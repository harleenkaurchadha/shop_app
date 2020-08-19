import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget{
  static const routeName= '/orders';
  @override
  Widget build(BuildContext context) {
    print('building orders');
//    final orderData= Provider.of<Orders>(context);  it will result in infinite loop since fetchAndSetOrders will notify listeners & it will be called & rebuild
     return Scaffold(
       appBar: AppBar(
         title: Text('Your Orders'),
       ),
       drawer: AppDrawer(),
       body: FutureBuilder(future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
             builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {          //i.e we are currently loading
                return Center(
                    child: CircularProgressIndicator());
              } else {
                if(dataSnapshot.error != null) {
                // Do error handling
                  return Center(child: Text('An error occured'),);
                } else {
                  return Consumer<Orders>(builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx,i) => OrderItem(orderData.orders[i]),
               ),
                  );
                }
                }
              },
              ),
              );
            }
          }