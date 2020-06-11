import 'package:flutter/material.dart';

class StringUtils {
  static String BASE_URL = "http://bridcodes.app/bmart_base/index.php/api/";

  String ASSIGN_ORDER_URL = BASE_URL + 'assign_order';
  String ALL_APP_USERS_URL = BASE_URL + 'grab_all_users';
  String ALL_ORDERS_URL = BASE_URL + 'grab_all_orders';
  String GET_PRODUCTS_URL = BASE_URL + 'get_products';
  String DELIVERY_BOY_LIST_URL = BASE_URL + 'delivery_boy';
  String ORDER_DETAILS_URL = BASE_URL + 'order_details';
  String TODAYS_ORDERS_URL = BASE_URL + 'grab_todays_orders';
  String LOGIN_URL = BASE_URL + 'store_manager_login';
  String STOCK_UPDATE_URL = BASE_URL + 'stock_insert';
  String UPDATE_PROFILE_URL = BASE_URL + 'update_store_manager';

  //Font
  String HKGrotesk = 'HKGrotesk';

  //Images
  String ICON_PATH = "assets/icons.png";

  String settings_descrip =
      'Update your settings like Profile Edit, Stock Update etc.';
}
