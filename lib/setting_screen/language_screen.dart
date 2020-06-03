import 'package:flutter/material.dart';
import 'package:storemanager/utils/utils_importer.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
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
                        "Language",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
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
