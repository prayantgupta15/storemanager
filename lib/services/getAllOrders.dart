import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bazarmanager/models/allOrders.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

List<AllOrders> AllOrdersList = List<AllOrders>();
Future<List<AllOrders>> getAllOrders() async {
  final response = await http.get(UtilsImporter().stringUtils.ALL_ORDERS_URL);

  var jsondata = jsonDecode(response.body);
  print(jsondata.toString());

  AllOrdersList = List<AllOrders>();

  for (var i in jsondata) {
    AllOrdersList.add(AllOrders.fromJson(i));
  }
  return AllOrdersList;
}
