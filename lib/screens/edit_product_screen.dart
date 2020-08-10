import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget{   // because until submission of form it is needed only in local state
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();              //use focus node to identify specific text fields in flutter focus tree
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();                              //global key will help to interact with state behind form widget
                                                                      //FormState is the state of FORM stateful widget
  var _editedProduct = Product(                                     //creating new product
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);    //if focus for image is changed
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        _editedProduct = Provider.of<Products>(context,listen: false).findById(productId);
        _initValues = {
          'title' : _editedProduct.title,
          'description' : _editedProduct.description,
          'price' : _editedProduct.price.toString(),
          'imageUrl' : '',
       };
        _imageUrlController.text = _editedProduct.imageUrl;
     }
    }
    _isInit = false;                               // so that didChangeDependencies do not run too often
    super.didChangeDependencies();
  }
  @override
  void dispose(){                                  //since focus node needs to be disposed to avoid memory leaks
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
      if(_imageUrlController.text.isEmpty || (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
      (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('jpeg')))
      {
        return ;              //so that we only get error on saving form and not on clicking outside
      }
        setState(() {

        });
    }
  }
  Future<void> _saveForm() async{
    final isValid = _form.currentState.validate();
    if(!isValid){
      return ;
    }
   _form.currentState.save();
    setState(() {
      _isLoading = true;
     });
    if(_editedProduct.id!= null ){                                  //product already exist so edit in that
      await Provider.of<Products>(context,listen: false)
          .updateProduct(_editedProduct.id,_editedProduct);
      }
    else
      {
        try{
          await Provider.of<Products>(context,listen: false)
              .addProduct(_editedProduct);
        }
        catch(error){
          await showDialog (
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something get wrong'),
              actions: <Widget>[
                FlatButton(child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        }
//        finally {                                                 //this code should run no matter if we succeeded or failed
//          setState(() {
//            _isLoading = false;
//          });
//          Navigator.of(context).pop();                      //only go to prev screen once we r done with adding product
//        }
     }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Edit Product'),
       actions: <Widget>[
         IconButton(
           icon: Icon(Icons.save),
           onPressed: _saveForm,
         ),
       ],
     ),
     body: _isLoading ?
        Center(
          child: CircularProgressIndicator(),
        )
     : Padding(
       padding: EdgeInsets.all(16),
       child: Form(
         key: _form,                                          //now we can use form property to interact with state managed by Form widget
         child: ListView(
           children: <Widget>[
         TextFormField(
          initialValue: _initValues['title'],
          decoration: InputDecoration(labelText: 'Title'),
          textInputAction: TextInputAction.next,                //indicates what bottom right corner of keyboard will show
          onFieldSubmitted: (_){
            FocusScope.of(context).requestFocus(_priceFocusNode);
          },
           validator: (value) {
            if (value.isEmpty) {
              return 'Please provide a value';
            }
            return null;
           },
           onSaved: (value){
            _editedProduct = Product(               //since product is final so we can't reassign the value after product is created so we create it again
              title: value,
              price: _editedProduct.price,
              description: _editedProduct.description,
              imageUrl: _editedProduct.imageUrl,
              id: _editedProduct.id,
              isFavourite: _editedProduct.isFavourite,
            );
           },
        ),
         TextFormField(
           initialValue: _initValues['price'],
           decoration: InputDecoration(labelText: 'Price'),
           textInputAction: TextInputAction.next,                //indicates what bottom right corner of keyboard will show
           keyboardType: TextInputType.number,
           focusNode: _priceFocusNode,
           onFieldSubmitted: (_){
             FocusScope.of(context).requestFocus(_descriptionFocusNode);
           },
           validator :(value) {
             if(value.isEmpty){
               return 'Please enter a value';
             }
             if(double.tryParse(value)== null){                          //since parse will return error and try parse null
                return 'Please enter valid price';
             }
             if(double.parse(value) <= 0){
               return 'Enter a price greater than 0';
             }
             return null;
           },
           onSaved: (value){
             _editedProduct = Product(               //since product is final so we can't reassign the value after product is created so we create it again
               title: _editedProduct.title,
               price: double.parse(value),
               description: _editedProduct.description,
               imageUrl: _editedProduct.imageUrl,
               id: _editedProduct.id,
               isFavourite: _editedProduct.isFavourite,
             );
           },
         ),
         TextFormField(
           initialValue: _initValues['description'],
           decoration: InputDecoration(labelText: 'Description'),
           maxLines: 3,
           keyboardType: TextInputType.multiline,
           validator: (value){
             if(value.isEmpty){
               return 'Please enter a description';
             }
             if(value.length < 10){
               return 'Should be atleast 10 characters long';
             }
             return null;
           },
           onSaved: (value) {
             _editedProduct =
                 Product( //since product is final so we can't reassign the value after product is created so we create it again
                   title: _editedProduct.title,
                   price: _editedProduct.price,
                   description: value,
                   imageUrl: _editedProduct.imageUrl,
                   id: _editedProduct.id,
                   isFavourite: _editedProduct.isFavourite,
                 );
           },
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
              onFieldSubmitted: (_){
                _saveForm();
              },
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter an image URL';
                }
                if(!value.startsWith('http') && !value.startsWith('https')){
                  return 'Please enter a valid URL';
                }
                if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('jpeg'))
                  {
                    return 'Please enter a valid image URL';
                  }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(               //since product is final so we can't reassign the value after product is created so we create it again
                title: _editedProduct.title,
                price: _editedProduct.price,
                description: _editedProduct.description,
                imageUrl: value,
                id: _editedProduct.id,
                isFavourite: _editedProduct.isFavourite,
                );
                },
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