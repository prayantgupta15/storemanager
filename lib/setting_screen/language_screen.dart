import 'package:flutter/material.dart';
import 'package:storemanager/main.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
//  void changeLang(Locale language) {
//    print("changing language (LanguageScreen)");
//
//    print(language.languageCode);
//    Locale _temp;
//    switch (language.languageCode) {
//      case "en":
//        _temp = Locale(language.languageCode, "US");
//        break;
//      case 'ar':
//        _temp = Locale(language.languageCode, "SA");
//        print("SA");
//        break;
//
//      case "hi":
//        _temp = Locale(language.languageCode, "IN");
//        break;
//      case "fr":
//        _temp = Locale(language.languageCode, "");
//        break;
//      case "es":
//        _temp = Locale(language.languageCode, "");
//        break;
//      default:
//        _temp = Locale("en", "US");
//    }
//    print("_temp" + _temp.languageCode);
//    MyApp.setLocale(context, _temp);
//  }

  @override
  Widget build(BuildContext context) {
    TextStyle suffixTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
        color: Theme.of(context).primaryColorDark);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Container(
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
                              getTranslated(context, 'LANGUAGE_KEY'),
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      UtilsImporter().stringUtils.HKGrotesk),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "🇺🇸" + getTranslated(context, 'ENGLISH_KEY'),
                          style: suffixTextStyle,
                        ),
                        onTap: () {
//                          changeLang(Locale('en'));
                          SharedPreferencesUtil.saveLang('en');
                          MyApp.setLocale(context, Locale('en'));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "🇸🇦" + getTranslated(context, 'ARABIC_KEY'),
                          style: suffixTextStyle,
                        ),
                        onTap: () {
                          SharedPreferencesUtil.saveLang('ar');
                          MyApp.setLocale(context, Locale('ar'));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "🇮🇳" + getTranslated(context, 'HINDI_KEY'),
                          style: suffixTextStyle,
                        ),
                        onTap: () {
                          SharedPreferencesUtil.saveLang('hi');
                          MyApp.setLocale(context, Locale('hi'));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "🇧🇪" + getTranslated(context, 'FRENCH_KEY'),
                          style: suffixTextStyle,
                        ),
                        onTap: () {
                          SharedPreferencesUtil.saveLang('fr');
                          MyApp.setLocale(context, Locale('fr'));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "🇲🇽" + getTranslated(context, 'SPANISH_KEY'),
                          style: suffixTextStyle,
                        ),
                        onTap: () {
                          SharedPreferencesUtil.saveLang('es');
                          MyApp.setLocale(context, Locale('es'));
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
