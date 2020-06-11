import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storemanager/login_screen/login_screen.dart';
import 'package:storemanager/login_screen/logout_screen.dart';
import 'package:storemanager/setting_screen/all_orders_screen.dart';
import 'package:storemanager/setting_screen/all_products_screen.dart';
import 'package:storemanager/setting_screen/app_users_screeen.dart';
import 'package:storemanager/setting_screen/edit_profile_screen.dart';
import 'package:storemanager/raw_data.dart';
import 'package:storemanager/setting_screen/language_screen.dart';
import 'package:storemanager/setting_screen/stock_screen.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isDarkThemeMode = false;
  List<IconData> icon = [
    Icons.person,
    Icons.people,
    Icons.videogame_asset,
    Icons.featured_play_list,
    Icons.assessment,
    Icons.language,
    Icons.power_settings_new,
  ];

  TextStyle titleTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
      fontSize: 18);

  TextStyle subtitleTextStyle = TextStyle(
      color: UtilsImporter().colorUtils.greycolor,
      fontWeight: FontWeight.w400,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
      fontSize: 14);

  List<Widget> screenList = [
    EditProfilescreen(),
    AppUsersScreen(),
    AllProductsScreen(),
    AllOrdersScreen(),
    StockScreen(),
    LanguageScreen(),
    LogOutScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferencesUtil.getIsDarkThemeMode().then((onValue) {
      if (onValue != null) {
        setState(() {
          isDarkThemeMode = onValue;
        });
      }
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        getTranslated(context, 'MENU_KEY'),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                      IconButton(
                        icon: Icon(isDarkThemeMode
                            ? Icons.brightness_7
                            : Icons.brightness_2),
                        iconSize: 30,
                        highlightColor: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          if (isDarkThemeMode == true) {
                            setState(() {
                              isDarkThemeMode = false;
                            });
                            SharedPreferencesUtil.saveIsDarkThemeMode(false);
                            _changeTheme(context, MyThemeKeys.LIGHT);
                          } else {
                            setState(() {
                              isDarkThemeMode = true;
                            });
                            SharedPreferencesUtil.saveIsDarkThemeMode(true);
                            _changeTheme(context, MyThemeKeys.DARK);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  getTranslated(context, 'MENU_DES'),
                  style: TextStyle(
                      color: UtilsImporter().colorUtils.greycolor,
                      fontWeight: FontWeight.w400,
                      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
                      fontSize: 17),
                ),
                SizedBox(height: 10),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    onTap: () {
                      print(index.toString());
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => screenList[index]));
                    },
                    onLongPress: () {
                      print("long pressed");
                    },
                    title: Text(
                      menuItemTitle(context, index),
                      style: titleTextStyle,
                    ),
                    subtitle: Text(
                      menuItemDes(context, index),
                      style: subtitleTextStyle,
                    ),
                    leading: Icon(icon[index],
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.4)),
                    trailing: Icon(Icons.chevron_right,
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.4)),
                  );
                },
                childCount: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
