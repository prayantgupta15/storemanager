import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:bazarmanager/utils/shared_preferences_util.dart';

class Profile {
  String store_name;
  String number;
  String email;
  String store_id;

  Profile(
      {@required this.store_name,
      @required this.number,
      @required this.email,
      @required this.store_id});

  Map<String, dynamic> toJson() {
    return {
      "user_name": store_name,
      "user_mobile": number,
      "user_id": store_id,
      "user_email": email
    };
  }
}
