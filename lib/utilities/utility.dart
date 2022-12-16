import 'dart:typed_data';
import 'dart:convert';

// encode, decode image in order to store and retrieve image from sqllite
class Utility {
  // to decode image to str 
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  // to encode image to str 
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
