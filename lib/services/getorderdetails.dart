import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bazarmanager/models/Order_Details.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

Future<List<OrderDetails>> getOrderDetails(String orderId) async {
  List<OrderDetails> orderDetailsList = List<OrderDetails>();
  print("GETTING ORDER DETAILS");
  print("getOrderDetails(orderId)");
  final response = await http.post(
      UtilsImporter().stringUtils.ORDER_DETAILS_URL,
      body: {"sale_id": orderId});
  print(response.body);

  var jsonData = jsonDecode(response.body);

  for (var i in jsonData) orderDetailsList.add(OrderDetails.fromJson(i));

  return orderDetailsList;
}
