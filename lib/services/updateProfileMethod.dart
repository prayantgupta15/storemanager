import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storemanager/models/profile.dart';
import 'package:storemanager/utils/utils_importer.dart';

Future<bool> updateProfile(Profile profileItem) {
  print(profileItem.toJson());
  return http
      .post(UtilsImporter().stringUtils.UPDATE_PROFILE_URL,
          body: profileItem.toJson())
      .then((onValue) {
    print(onValue.body);
    if (onValue.statusCode == 200) {
      if (jsonDecode(onValue.body)["responce"])
        return true;
      else
        return false;
    }

    return false;
  });
}
