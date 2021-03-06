import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bazarmanager/models/loginModel.dart';
import 'package:bazarmanager/utils/shared_preferences_util.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

Future<bool> performLogin(LoginModel loginModel) async {
  print("perform");
  print(loginModel.toJson());
  final response = await http.post(UtilsImporter().stringUtils.LOGIN_URL,
      body: loginModel.toJson());
  if (response.statusCode == 200) {
    print(response.body);
    final data = jsonDecode(response.body);
    print("data['responce']" + data["responce"].toString());
    if (data["responce"] == true) {
      SharedPreferencesUtil.saveIsLogin(true);
      print("SharedPreferencesUtil.getIsLogin().toString()");
      SharedPreferencesUtil.getIsLogin().then((onValue) {
        print(onValue.toString());
      });
      print("data[\"data\"][\"user_id\"].toString():" +
          data["data"]["user_id"].toString());
      SharedPreferencesUtil.saveStoreId(data["data"]["user_id"].toString());
      return true;
    } else
      return false;
  }
  return false;
}
