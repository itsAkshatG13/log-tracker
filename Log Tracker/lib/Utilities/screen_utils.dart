import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ScreenUtils {

  static double screenHeight(context) => MediaQuery.of(context).size.height;

  static double screenWidth(context) => MediaQuery.of(context).size.width;

  static EdgeInsets get rootPaddingInsets => EdgeInsets.symmetric(horizontal: 20.0);

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

}


