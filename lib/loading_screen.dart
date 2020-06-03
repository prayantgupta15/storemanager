import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storemanager/home_screens/home_screen.dart';
import 'package:storemanager/login_screen/login_screen.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
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

    SharedPreferencesUtil.getIsLogin().then((onValue) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        onValue == true
            ? Navigator.pushReplacement(
                context, CupertinoPageRoute(builder: (context) => HomeScreen()))
            : Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => LoginScreen()));
      });
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/icons.png'),
              backgroundColor: Theme.of(context).primaryColorDark,
              radius: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Store Manager",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: UtilsImporter().stringUtils.HKGrotesk,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
