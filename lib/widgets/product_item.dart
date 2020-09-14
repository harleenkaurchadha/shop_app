import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final product= Provider.of<Product>(context, listen: false,);
    final cart= Provider.of<Cart>(context, listen: false,);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
          );
        },
        child: GridTile(
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product-placeholder.png'),         //image to display initially before loading
            image: NetworkImage(product.imageUrl),                                    //actual image to be displayed
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
                builder: (ctx, Product, child) => IconButton(
                icon: Icon(
                    product.isFavourite ?
                    Icons.favorite :
                    Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () async{
                  await product.toggleFavouriteStatus(authData.token, authData.userId,);
                  },
                ),
               ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                  Icons.shopping_cart,
              ),
              onPressed: (){
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(                     //in this we reach out to nearest scaffold in widget tree
                  SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: (){
                        cart.removeSingleItem(product.id);
                      },
                      ),
                      ),
                      );
                      },
                  color: Theme.of(context).accentColor,
                 ),
                ),
                ),
    ),
    );

        }
}