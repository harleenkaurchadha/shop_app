import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProductScreen extends StatefulWidget{   // because until submission of form it is needed only in local state
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);    //if focus for image is changed
    super.initState();
  }

  @override
  void dispose(){                                 //since focus node needs to be disposed to avoid memory leaks
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageFocusNode.hasFocus)                     //if we do not have focus anymore
      {
        setState(() {

        });
    }
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
         Row(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: <Widget>[
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top: 8,right: 10,),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: _imageUrlController.text.isEmpty
                ? Text('Enter a URL')
                : FittedBox(
                  child: Image.network(_imageUrlController.text),
                  fit: BoxFit.cover,
            ),
          ),
          Expanded(                                                       //since TextFormField takes max width available
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Image URL'),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              controller: _imageUrlController,                        //since we need url before form is submitted
              focusNode: _imageFocusNode,
            ),
          ),
         ],
         ),
       ],
       ),
       ),
     ),
   );
  }
}