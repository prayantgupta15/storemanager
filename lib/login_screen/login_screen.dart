import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bazarmanager/home_screens/home_screen.dart';
import 'package:bazarmanager/models/loginModel.dart';
import 'package:bazarmanager/services/performLogin.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/shared_preferences_util.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

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
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
        color: Theme.of(context).primaryColorDark);
    TextStyle labelTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
    );
    TextStyle subHeadingTextStyle = TextStyle(
      color: UtilsImporter().colorUtils.greycolor,
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
              child: CustomScrollView(
                slivers: <Widget>[
//                  SliverAppBar(
//                    backgroundColor: Theme.of(context).primaryColorLight,
//                    title: Text("Sign In", style: formTitleTextStyle),
//                    pinned: true,
//                    elevation: 0,
//                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 80),
                            Text(getTranslated(context, 'TITLE_KEY'),
//                                "Welcome to Store Manager",
                                style: formTitleTextStyle),
                            SizedBox(height: 10),
                            Text(
                                "Enter E-mail address and Password for Sign in",
                                style: subHeadingTextStyle),
                            SizedBox(height: 30),
                          ],
                        ),
                      )
                    ]),
                  ),
                  Form(
                    key: _formKey,
                    child: SliverList(
                      delegate: SliverChildListDelegate([
//                        CircleAvatar(
//                          backgroundColor: Theme.of(context).primaryColor,
//                          radius: 80,
//                          child: Image(
//                            image: AssetImage(
//                                UtilsImporter().stringUtils.ICON_PATH),
//                            gaplessPlayback: true,
//                          ),
//                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            validator: (String val) {
                              if (val.isEmpty) return 'Value  cannot be empty';
                            },
                            enableInteractiveSelection: true,
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _loginidController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
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
//                              border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            validator: (String val) {
                              if (val.isEmpty) return 'Value  cannot be empty';
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
                                  obscure ? obscure = false : obscure = true;
                                  setState(() {});
                                },
                              ),
                              labelText: "Password",
                              labelStyle: labelTextStyle,
//                              border: OutlineInputBorder(
//                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 30),
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
                                    msg: "Wrong Credentials",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
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
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            width: MediaQuery.of(context).size.width / 3,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).primaryColor),
                            child: Center(
                                child: Text(
                              getTranslated(context, 'LOGIN_BUTTON_KEY'),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(),
          ],
        ),
      ),
    );
  }
}
