import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storemanager/home_screens/homeorTodaysOrder.dart';
import 'package:storemanager/setting_screen/edit_profile_screen.dart';
import 'package:storemanager/home_screens/menu_screen.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  TextStyle bottomNavigationItemTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
      fontSize: 15);

  final _pageOptions = [
    HomeorTodaysOrdersScreen(),
    MenuScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection();
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

  checkConnection() async {
    var status = await checkInternet();
    Fluttertoast.showToast(
      msg: "Refreshing",
      //textColor: Colors.blue,
      toastLength: Toast.LENGTH_LONG,
    );
    debugPrint("make request");
    if (status == DataConnectionStatus.disconnected) {
      showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (context) {
            print("dialog");
            return CupertinoAlertDialog(
              title: Text("No Internet!"),
              content: Text('Connect to Internet and refresh.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Settings'),
                  onPressed: () {
                    HapticFeedback.vibrate();
                    AppSettings.openWIFISettings();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Refresh'),
                  onPressed: () {
                    print("clicked REFREHSEG");
                    HapticFeedback.vibrate();
                    Navigator.of(context).pop();
                    checkConnection();
                  },
                )
              ],
            );
          });
    }
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      backgroundColor: Theme.of(context).primaryColorLight,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).primaryColor,
        elevation: 5,
        currentIndex: _selectedPage,
        onTap: (_index) {
          setState(() {
            _selectedPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            icon: Icon(
              Icons.home,
              color: UtilsImporter().colorUtils.greycolor.withOpacity(0.8),
            ),
            title: Text(
              "Home",
              style: bottomNavigationItemTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu,
                color: UtilsImporter().colorUtils.greycolor.withOpacity(0.8)),
            title: Text(
              "Menu",
              style: bottomNavigationItemTextStyle,
            ),
            activeIcon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}
