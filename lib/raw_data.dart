import 'package:storemanager/utils/common_utils.dart';

String menuItemTitle(context, index) {
  List<String> menuItem = [
    getTranslated(context, 'EDIT_PROFILE_KEY'),
    getTranslated(context, 'APP_USERS_KEY'),
    getTranslated(context, 'PRODUCTS_KEY'),
    getTranslated(context, 'ALL_ORDERS_KEY'),
    getTranslated(context, 'UPDATE_STOCK_KEY'),
    getTranslated(context, 'LANGUAGE_KEY'),
    getTranslated(context, 'LOGOUT_KEY'),
  ];

  return menuItem[index];
}

String menuItemDes(context, index) {
  List<String> menuItem = [
    getTranslated(context, 'EDIT_PROFILE_DES_KEY'),
    getTranslated(context, 'APP_USERS_DES_KEY'),
    getTranslated(context, 'PRODUCTS_DES_KEY'),
    getTranslated(context, 'ALL_ORDERS__DES_KEY'),
    getTranslated(context, 'UPDATE_STOCK_DES_KEY'),
    getTranslated(context, 'LANGUAGE_DES_KEY'),
    getTranslated(context, 'LOGOUT_DES_KEY'),
  ];
  return menuItem[index];
}
