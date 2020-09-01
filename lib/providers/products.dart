import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier{    // A class that can be extended or mixed in that provides a change notification
List<Product> _items=[                 //this property should never be accessible from outside
  Product(
    id: 'p1',
    title: 'Red Shirt',
    description: 'A red shirt - it is pretty red!',
    price: 29.99,
    imageUrl:
    'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  ),
  Product(
    id: 'p2',
    title: 'Trousers',
    description: 'A nice pair of trousers.',
    price: 59.99,
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  ),
  Product(
    id: 'p3',
    title: 'Yellow Scarf',
    description: 'Warm and cozy - exactly what you need for the winter.',
    price: 19.99,
    imageUrl:
    'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  ),
  Product(
    id: 'p4',
    title: 'A Pan',
    description: 'Prepare any meal you want.',
    price: 49.99,
    imageUrl:
    'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  ),
];
var _showFavouritesOnly = false;


List<Product> get items{              //a copy of _items
//  if(_showFavouritesOnly){
//    return _items.where((prodItem) => prodItem.isFavourite).toList();
//  }
  return [..._items];
}

List<Product> get favouriteItems {
  return _items.where((prodItem) => prodItem.isFavourite).toList();
}

Product findById(String id){
  return _items.firstWhere((prod) => prod.id == id);
}

//void showFavouritesOnly(){
//  _showFavouritesOnly = true;
//  notifyListeners();
//}

//void showAll(){
//  _showFavouritesOnly = false;
//  notifyListeners();
//}
  Future<void> fetchAndSetProducts() async{
    const url= 'https://flutter-update-59f18.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;         //since map of maps
      final List<Product> loadedProducts = [];
      if(extractedData == null){
        return ;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite: prodData['isFavourite'],
          imageUrl: prodData['imageUrl']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
     } catch(error) {
      throw (error);
    }
  }

Future<void> addProduct(Product product) async{
  const url= 'https://flutter-update-59f18.firebaseio.com/products.json';    // /products represent folder or collection in database
     try {                                                                //code we want to check for errors
       final response = await http.post(url, body: json.encode({
         //wait for this code to finish until we move on to next line of code
         'title': product.title,
         'description': product.description,
         'imageUrl': product.imageUrl,
         'price': product.price,
         'isFavourite': product.isFavourite,
       }),
       );
       final newProduct = Product(                                      //then code
         title: product.title,
         description: product.description,
         price: product.price,
         imageUrl: product.imageUrl,
         id: json.decode(response.body)['name'],
       );
       _items.add(newProduct);
       notifyListeners();          // to make other widgets know about changes in value
     }
      catch(error) {
        print(error);
        throw error;
      }
}
Future<void> updateProduct(String id, Product newProduct) async{
final prodIndex = _items.indexWhere((prod) => prod.id == id);
if(prodIndex >=0){
  final url= 'https://flutter-update-59f18.firebaseio.com/products/$id.json';
  await http.patch(url,body: json.encode({                                   //merge incoming data with existing data
  'title': newProduct.title,
  'description' : newProduct.description,
  'imageUrl' : newProduct.imageUrl,
  'price' : newProduct.price,
  }));
  _items[prodIndex] = newProduct;
  notifyListeners();
} else {
  print('...');
}
}
Future<void> deleteProduct(String id) async{
  final url = 'https://flutter-update-59f18.firebaseio.com/products/$id.json';
  final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  var existingProduct = _items[existingProductIndex];
  _items.removeAt(existingProductIndex);
  notifyListeners();
  final response = await http.delete(url);
  if(response.statusCode >=400){
    _items.insert(existingProductIndex, existingProduct);         //if deletion at server fails insert element locally since element will be deleted from there
    notifyListeners();
    throw HttpException('Could not delete product');
    }
    print(response.statusCode);
    existingProduct = null;                                 //delete its reference from memory
 }
}