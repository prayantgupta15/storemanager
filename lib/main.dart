import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:bazarmanager/loading_screen.dart';
import 'package:bazarmanager/localization/demolocalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(
      CustomTheme(
        initialThemeKey: MyThemeKeys.LIGHT,
        child: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
    SharedPreferencesUtil.getLang().then((onValue) {
      _locale = Locale(onValue);
    });
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bazar Manager',
      theme: CustomTheme.of(context),
      home: LoadingScreen(),
      debugShowCheckedModeBanner: true,
      locale: _locale,
      supportedLocales: [
        Locale('es', ''),
        Locale('ar', ''),
        Locale('hi', ''),
        Locale('fr', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: [
        DemoLocalization.delegate,
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        print("deviceLocale" + deviceLocale.languageCode);
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode)
            return deviceLocale;
        }
        return supportedLocales.first;
      },
    );
  }
}
