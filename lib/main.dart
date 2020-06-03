import 'package:flutter/material.dart';
import 'package:storemanager/home_screens/home_screen.dart';
import 'package:storemanager/loading_screen.dart';
import 'package:storemanager/login_screen/login_screen.dart';
import 'package:storemanager/login_screen/logout_screen.dart';
import 'package:storemanager/setting_screen/all_products_screen.dart';
import 'package:storemanager/setting_screen/app_users_screeen.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';

void main() => runApp(
      CustomTheme(
        initialThemeKey: MyThemeKeys.LIGHT,
        child: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferencesUtil.getIsDarkThemeMode().then((onValue) {
      if (onValue != null) {
        if (onValue == false) {
          _changeTheme(context, MyThemeKeys.LIGHT);
        } else {
          _changeTheme(context, MyThemeKeys.DARK);
        }
      }
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Manager',
      theme: CustomTheme.of(context),
      home: LoadingScreen(),
    );
  }
}
