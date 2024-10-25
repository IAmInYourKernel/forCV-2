import 'package:fluttertoast/fluttertoast.dart';

displayToastMessage(String message, context) {
  Fluttertoast.showToast(
      msg: message, fontSize: 18, gravity: ToastGravity.BOTTOM);
}
