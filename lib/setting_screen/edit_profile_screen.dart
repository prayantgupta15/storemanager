import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bazarmanager/models/profile.dart';
import 'package:bazarmanager/services/updateProfileMethod.dart';
import 'package:bazarmanager/status_screens/Faiulure/editProfileFail.dart';
import 'package:bazarmanager/status_screens/succefull/profileUpdateSuccess.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/shared_preferences_util.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

class EditProfilescreen extends StatefulWidget {
  @override
  _EditProfilescreenState createState() => _EditProfilescreenState();
}

class _EditProfilescreenState extends State<EditProfilescreen> {
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
    super.initState();
    checkConnection();
  }

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _mobileFocus = FocusNode();
  final FocusNode _emailAddressFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    TextStyle labelTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
    );
    TextStyle formTitleTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.w700,
        fontSize: 15.0,
        color: Theme.of(context).primaryColorDark);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          //APPBAR
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Icon(
                                  Icons.keyboard_backspace,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(width: 20),
                              Text(
                                getTranslated(context, 'EDIT_PROFILE_KEY'),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        UtilsImporter().stringUtils.HKGrotesk),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 20),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          color: Colors.grey.withOpacity(0.2),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      validator: (String val) {
                                        if (val.isEmpty)
                                          return 'Value  cannot be empty';
                                      },
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      controller: nameController,
                                      textInputAction: TextInputAction.next,
                                      autofocus: false,
                                      focusNode: _nameFocus,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(_mobileFocus);
                                      },
                                      style: formTitleTextStyle,
                                      decoration: InputDecoration(
                                        labelText: "Store Name",
                                        labelStyle: labelTextStyle,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      validator: (String val) {
                                        if (val.isEmpty)
                                          return 'Value  cannot be empty';
                                      },
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      controller: mobileController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      focusNode: _mobileFocus,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(_emailAddressFocus);
                                      },
                                      style: formTitleTextStyle,
                                      decoration: InputDecoration(
                                        labelText: "Mobile Number",
                                        labelStyle: labelTextStyle,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      validator: (String val) {
                                        if (val.isEmpty)
                                          return 'Value  cannot be empty';
                                      },
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      controller: emailController,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.emailAddress,
                                      autofocus: false,
                                      focusNode: _emailAddressFocus,
                                      onFieldSubmitted: (value) {
                                        _emailAddressFocus.unfocus();
                                      },
                                      style: formTitleTextStyle,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: labelTextStyle,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  height: 40,
                                  color: Theme.of(context).primaryColor,
                                  child: Center(
                                    child: Text(
                                      getTranslated(
                                          context, 'UPDATE_PROFILE_BUTTON_KEY'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: UtilsImporter()
                                            .stringUtils
                                            .HKGrotesk,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    print("VALIDATION TREU");
                                    bool result = await updateProfile(
                                      Profile(
                                          store_name: nameController.text,
                                          number: (mobileController.text),
                                          email: emailController.text,
                                          store_id: await SharedPreferencesUtil
                                              .getStoreId()
//                                    store_id: '224'
                                          ),
                                    );
                                    print("RESULT" + result.toString());
                                    result
                                        ? Navigator.push(context,
                                            CupertinoPageRoute(
                                                builder: (context) {
                                            _isLoading = false;
                                            nameController.clear();
                                            mobileController.clear();
                                            emailController.clear();
                                            FocusScope.of(context).unfocus();
                                            return EditProfilesuccess();
                                          }))
                                        : Navigator.push(context,
                                            CupertinoPageRoute(
                                                builder: (context) {
                                            _isLoading = false;
                                            FocusScope.of(context).unfocus();
                                            return EditProfileFail();
                                          }));
                                  } else
                                    print("ALL VALUES ARE NOT ENTRED");
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }
}
