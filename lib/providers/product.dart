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

  Future<void> toggleFavouriteStatus(String token) async{
    final oldValue = isFavourite;
    isFavourite=!isFavourite;
    notifyListeners();
    final url = 'https://flutter-update-59f18.firebaseio.com/products/$id.json?auth=$token';
    try{
      final response = await http.patch(url,body: json.encode({             //http dosen't throws an error for patch ,put &delete
      'isFavourite' : isFavourite,
      }),
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