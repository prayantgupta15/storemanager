import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bazarmanager/models/allOrders.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

List<AllOrders> TodaysOrdersList;
Future<List<AllOrders>> getTodaysOrders() async {
  print("getTodaysOrders()");
  final response =
      await http.get(UtilsImporter().stringUtils.TODAYS_ORDERS_URL);

  var jsondata = jsonDecode(response.body);
  print(jsondata.toString());
  TodaysOrdersList = List<AllOrders>();
  for (var i in jsondata) {
    TodaysOrdersList.add(AllOrders.fromJson(i));
  }
  print("TodaysOrdersList" + TodaysOrdersList.length.toString());
  return TodaysOrdersList;
}
