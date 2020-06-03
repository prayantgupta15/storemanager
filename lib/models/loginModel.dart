import 'dart:convert';

import 'package:flutter/cupertino.dart';

class LoginModel {
  String user_email;
  String password;

  LoginModel({@required this.user_email, @required this.password});



  Map<String, dynamic> toJson() {
    return {'user_email': user_email, 'user_password': password};
  }
}
