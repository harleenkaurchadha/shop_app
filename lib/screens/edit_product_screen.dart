import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget{   // because until submission of form it is needed only in local state
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose(){                                 //since focus node needs to be disposed to avoid memory leaks
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Edit Product'),
     ),
     body: Padding(
       padding: EdgeInsets.all(16),
       child: Form(child: ListView(children: <Widget>[
        TextFormField(
          decoration: InputDecoration(labelText: 'Title'),
          textInputAction: TextInputAction.next,                //indicates what bottom right corner of keyboard will show
          onFieldSubmitted: (_){
            FocusScope.of(context).requestFocus(_priceFocusNode);
          },
        ),
         TextFormField(
           decoration: InputDecoration(labelText: 'Price'),
           textInputAction: TextInputAction.next,                //indicates what bottom right corner of keyboard will show
           keyboardType: TextInputType.number,
           focusNode: _priceFocusNode,
           onFieldSubmitted: (_){
             FocusScope.of(context).requestFocus(_descriptionFocusNode);
           },
         ),
         TextFormField(
           decoration: InputDecoration(labelText: 'Description'),
           maxLines: 3,
           keyboardType: TextInputType.multiline,
         ),
       ],),),
     ),
   );
  }
}