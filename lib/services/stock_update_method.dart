import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bazarmanager/models/stock_update.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

Future<bool> stockUpdate(StockUpdateItem stockUpdateItem) {
  print(stockUpdateItem.toJson());
  return http
      .post(UtilsImporter().stringUtils.STOCK_UPDATE_URL,
          body: stockUpdateItem.toJson())
      .then((onValue) {
    print(stockUpdateItem.toJson());
    print(onValue.body);
    if (onValue.statusCode == 200) {
      return jsonDecode(onValue.body)["responce"] == false
          ? false
          : jsonDecode(onValue.body)["product"][0] != null ? true : false;
    }
    return false;
  });
}
