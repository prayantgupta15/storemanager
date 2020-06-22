import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bazarmanager/utils/utils_importer.dart';

Future<bool> assignBoy({@required String Boyid, @required String orderid}) {
  Map<String, String> body = {"boy_id": Boyid, "order_id": orderid};
  print(body);
  return http
      .post(UtilsImporter().stringUtils.ASSIGN_ORDER_URL, body: body)
      .then((onValue) {
    print(onValue.body);
    if (onValue.statusCode == 200) {
//      print((onValue.body)["assign"][0]["msg"]);
      return jsonDecode(onValue.body)["assign"][0]["msg"] == "Assign Failed"
          ? false
          : true;
    }
    return false;
  });
}
