import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

class StockUpdateFail extends StatefulWidget {
  @override
  _StockUpdateFailState createState() => _StockUpdateFailState();
}

class _StockUpdateFailState extends State<StockUpdateFail> {
  @override
  Widget build(BuildContext context) {
    TextStyle suffixTextStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontSize: 20,
        fontWeight: FontWeight.w600);
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
                        getTranslated(context, 'UPDATE_STOCK_KEY'),
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
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 3),
                    ),
                    child: Icon(
                      Icons.sms_failed,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height / 10,
                    ),
                  ),
                ),
                Container(
                    child: Center(
                  child: Text(
                    getTranslated(context, 'UPDATE_STOCK_FAIL_KEY'),
                    style: suffixTextStyle,
                  ),
                )),
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
