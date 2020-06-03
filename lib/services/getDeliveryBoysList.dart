import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storemanager/models/deliveryboy.dart';
import 'package:storemanager/utils/utils_importer.dart';

List<DeliveryBoy> list;
getBoysList() async {
  print('getting delivery boy list');
  final response =
      await http.get(UtilsImporter().stringUtils.DELIVERY_BOY_LIST_URL);
  print('response.body' + response.body);

  var jsondata = jsonDecode(response.body)["delivery_boy"];
  print(jsondata);
  list = List<DeliveryBoy>();

  for (var i in jsondata) {
    list.add(DeliveryBoy.fromJson(i));
  }
  print(list);
  print("list.length.toString()" + list.length.toString());
}

String getBoyName(String id) {
  if (list.length == 0) return "NA";
  for (int i = 0; i < list.length; i++) {
    if (list[i].id == id)
      return list[i].name;
    else
      return " N.A.";
  }
}
