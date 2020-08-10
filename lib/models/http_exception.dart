class HttpException implements Exception{             //we r forced to implement all functns exception class has
final String message;

HttpException(this.message);

@override
  String toString() {
   return message;
  //    return super.toString();              //Instance of HttpException
  }

}