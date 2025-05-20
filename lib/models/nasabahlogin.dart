import 'package:shared_preferences/shared_preferences.dart';


class Nasabahlogin {
  bool? status = false;
  String? message;
  String? username;

  Nasabahlogin({
    this.status,
    this.message,
    this.username,
  });

  Future<void> prefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("status", status!);
    prefs.setString("message", message!);
    prefs.setString("username", username!);
  }
Future getUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Nasabahlogin userLogin = Nasabahlogin(
        status: prefs.getBool("status")!,
        message: prefs.getString("message")!,
        username: prefs.getString("username")!);
    return userLogin;
  }

}

