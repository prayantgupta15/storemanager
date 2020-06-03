import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:storemanager/models/allAppUsers.dart';
import 'package:storemanager/utils/utils_importer.dart';

List<AllAppUsers> AppUsersList = List<AllAppUsers>();

Future<List<AllAppUsers>> getAllAppUsers() async {
  final response =
      await http.get(UtilsImporter().stringUtils.ALL_APP_USERS_URL);

  var jsondata = jsonDecode(response.body);
  print(jsondata.toString());
  AppUsersList = List<AllAppUsers>();

  for (var i in jsondata) {
    AppUsersList.add(AllAppUsers.fromJson(i));
  }
  return AppUsersList;
}
