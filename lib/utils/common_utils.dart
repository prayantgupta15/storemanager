import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bazarmanager/localization/demolocalization.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

class CommonUtils {
  Size deviceScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

StreamSubscription<DataConnectionStatus> listener;

checkInternet() async {
  print("The statement 'this machine is connected to the Internet' is: ");
  print(await DataConnectionChecker().hasConnection);
  // returns a bool

  // We can also get an enum value instead of a bool
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  // prints either DataConnectionStatus.connected
  // or DataConnectionStatus.disconnected

  // This returns the last results from the last call
  // to either hasConnection or connectionStatus
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  // this will cause DataConnectionChecker to check periodically
  // with the interval specified in DataConnectionChecker().checkInterval
  // until listener.cancel() is called
  listener = DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        break;
    }
  });
  await Future.delayed(Duration(seconds: 5));
  return (await DataConnectionChecker().connectionStatus);
}

String showInfo(var str) {
  if (str == null)
    str = "null";
  else if (str.runtimeType == DateTime) str = str.toString().substring(0, 10);
  return (str);
}

void showToast(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Theme.of(context).primaryColorDark,
      textColor: Theme.of(context).primaryColorLight);
}

//TAGS
inStockTag() {
  return Text(
    "In Stock",
    style: TextStyle(
        color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

outOfStockTag() {
  return Text(
    "Out of Stock",
    style:
        TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

deliveredTag() {
  return Align(
      alignment: Alignment.topRight,
      child: Text(
        "DELIVERED",
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
      ));
}

pendingTag() {
  return Text(
    "PENDING",
    style: TextStyle(
        color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

outTag() {
  return Text(
    "Out For Delivery",
    style: TextStyle(
        color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

cancelTag() {
  return Text(
    "CANCELLED",
    style:
        TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

confirmTag() {
  return Text(
    "CONFIRMED",
    style: TextStyle(
        color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 15),
  );
}

trackOrder(String status) {
  if (status == "0") return pendingTag();
  if (status == "1") return confirmTag();
  if (status == "2") return outTag();
  if (status == "3") return cancelTag();
  if (status == "4")
    return deliveredTag();
  else
    return Container();
}

enum MyThemeKeys { LIGHT, DARK, DARKER }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: UtilsImporter().colorUtils.primarycolor,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,
    brightness: Brightness.light,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: UtilsImporter().colorUtils.primarycolor))),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: UtilsImporter().colorUtils.primarycolor,
    primaryColorLight: Colors.black,
    primaryColorDark: Colors.white,
    brightness: Brightness.dark,
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: UtilsImporter().colorUtils.primarycolor))),
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme;
    }
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys initialThemeKey;

  const CustomTheme({
    Key key,
    this.initialThemeKey,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        (context.inheritFromWidgetOfExactType(_CustomTheme) as _CustomTheme);
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).getTranslatedValue(key);
}
