import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken ;

  Orders(this.authToken,this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async{
    final url = 'https://flutter-update-59f18.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return ;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) => CartItem(  //since products need to be list<cartItem> so we map them
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title'],
          )).toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
  Future<void> addOrder(List<CartItem> cartProducts, double total)                      // to add all contents of cart into order
  async{
    final url = 'https://flutter-update-59f18.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
   final response = await http.post(url, body: json.encode({
      'amount' : total,
      'dateTime' : timestamp.toIso8601String(),             //use timestamp to get same time otherwise time of post request also gets added
      'products' : cartProducts.map((cp) => {              //converting to maps to use for json.encode
           'id' : cp.id,
           'title' : cp.title,
           'quantity' : cp.quantity,
            'price' : cp.price,
      }).toList(),
    }),
    );
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      dateTime: timestamp,
      products: cartProducts,
    )
    );                                      //recent order will come at starting position
    notifyListeners();
  }
  }
