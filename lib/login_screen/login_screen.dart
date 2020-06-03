import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:storemanager/home_screens/home_screen.dart';
import 'package:storemanager/models/loginModel.dart';
import 'package:storemanager/services/performLogin.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginidController = TextEditingController();
  final FocusNode _loginFocus = FocusNode();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _pwdFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool obscure = true;
  bool _isLoading = false;

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
    print("building" + obscure.toString());
    TextStyle formTitleTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: Theme.of(context).primaryColorDark);
    TextStyle labelTextStyle = TextStyle(
//    color: UtilsImporter().colorUtils.greycolor,
      color: Theme.of(context).primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GestureDetector(
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
                                fontFamily:
                                    UtilsImporter().stringUtils.HKGrotesk),
                          ),
                        ),
                      ]),
                    ),
                    Form(
                      key: _formKey,
                      child: SliverList(
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
                              "Sign In",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (String val) {
                                if (val.isEmpty)
                                  return 'Value  cannot be empty';
                              },
                              enableInteractiveSelection: true,
                              cursorColor: Theme.of(context).primaryColor,
                              controller: _loginidController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              focusNode: _loginFocus,
                              onFieldSubmitted: (value) {
//                            _loginidController.text.trim();
                                FocusScope.of(context).requestFocus(_pwdFocus);
                              },
                              style: formTitleTextStyle,
                              decoration: InputDecoration(
                                  labelText: "User ID",
                                  labelStyle: labelTextStyle,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              validator: (String val) {
                                if (val.isEmpty)
                                  return 'Value  cannot be empty';
                              },
                              cursorColor: Theme.of(context).primaryColor,
                              enableInteractiveSelection: true,
                              controller: _pwdController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              obscureText: obscure,
                              autofocus: false,
                              focusNode: _pwdFocus,
                              onFieldSubmitted: (value) {
//                            _pwdController.text.replaceAll(" ","");
                                _pwdFocus.unfocus();
                              },
                              style: formTitleTextStyle,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    color: Theme.of(context).primaryColor,
                                    icon: obscure
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(MdiIcons.eyeOff),
                                    onPressed: () {
                                      print("pressed");
                                      obscure
                                          ? obscure = false
                                          : obscure = true;
                                      setState(() {});
                                    },
                                  ),
                                  labelText: "Password",
                                  labelStyle: labelTextStyle,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 30,
                          ),
                          GestureDetector(
                            onTap: () async {
                              _loginidController.text =
                                  _loginidController.text.replaceAll(" ", "");
                              _pwdController.text =
                                  _pwdController.text.replaceAll(" ", "");
                              _pwdFocus.unfocus();
                              _loginFocus.unfocus();

                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                LoginModel loginDetails = LoginModel(
                                    user_email: _loginidController.text,
                                    password: _pwdController.text);

                                final result = await performLogin(loginDetails);
                                print("result: " + result.toString());
                                if (result) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    _isLoading = false;
                                    return HomeScreen();
                                  }));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "WRONG CREDENTIALS",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      textColor:
                                          Theme.of(context).primaryColorLight);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).primaryColor),
                              child: Center(
                                  child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                          )
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }
}