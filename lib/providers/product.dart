import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String token, String userId) async{
    final oldValue = isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
    final url = 'https://shop-app-ad559-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try{
      final response = await http.put(                                //using put since we only want to send true or false as a value
        url,
        body: json.encode(
        isFavourite,
       ),
      );
      if(response.statusCode >=400){                                        //i.e there is an error of status codes
        isFavourite = oldValue;
        notifyListeners();
      }
     } catch(error){                                                        //only cover network issue error
      isFavourite = oldValue;
      notifyListeners();
      }


  }
}