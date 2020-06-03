import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storemanager/home_screens/home_screen.dart';
import 'package:storemanager/login_screen/login_screen.dart';
import 'package:storemanager/models/loginModel.dart';
import 'package:storemanager/services/performLogin.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class LogOutScreen extends StatefulWidget {
  @override
  _LogOutScreenState createState() => _LogOutScreenState();
}

class _LogOutScreenState extends State<LogOutScreen> {
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
    } else
      setState(() {});
  }

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

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle formTitleTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: Theme.of(context).primaryColorDark);
    TextStyle labelTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Text(
                        "StoreManager",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorDark,
                      radius: 80,
                      child: Image(
                        image: AssetImage(
                            UtilsImporter().stringUtils.ICON_PATH),
                        gaplessPlayback: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Center(
                        child: Text(
                      "Are you sure you want to SignOut?",
                      style: labelTextStyle,
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                MdiIcons.logout,
                                size: 28,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {
                                await SharedPreferencesUtil.saveIsLogin(false);
                                SharedPreferencesUtil.getIsLogin()
                                    .then((onValue) {
                                  print("logout" + onValue.toString());
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => LoginScreen()),
                                  ModalRoute.withName('/'),
                                );
                              },
                            ),
                            Text(
                              "Yes",
                              style: formTitleTextStyle,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  MdiIcons.login,
                                  size: 28,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            Text(
                              "No",
                              style: formTitleTextStyle,
                            )
                          ],
                        ),
                      ],
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}