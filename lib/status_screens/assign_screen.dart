import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storemanager/services/assignBoy.dart';
import 'package:storemanager/services/getDeliveryBoysList.dart';
import 'package:storemanager/status_screens/Faiulure/orderAssignFail.dart';
import 'package:storemanager/status_screens/succefull/orderAssignSucess.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/utils_importer.dart';

class AssignOrderScreen extends StatefulWidget {
  String Orderid;
  AssignOrderScreen({@required this.Orderid});
  @override
  _AssignOrderScreenState createState() => _AssignOrderScreenState();
}

class _AssignOrderScreenState extends State<AssignOrderScreen> {
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

  //TEXT STYLES
  TextStyle prefixTextStyle = TextStyle(
      color: Colors.grey,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
      fontSize: 15,
      fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    TextStyle suffixTextStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontSize: 15,
        fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).primaryColorLight,
              floating: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Theme.of(context).primaryColorDark,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                "Select Delivery Boy",
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: UtilsImporter().stringUtils.HKGrotesk),
              ),
            ),
            list.length == 0
                ? SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                        child: Text(
                          "Nothing to Show",
                          style: suffixTextStyle,
                        ),
                      )
                    ]),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return GestureDetector(
                        onTap: () {
                          assignBoy(
                                  Boyid: list[index].id,
                                  orderid: widget.Orderid)
                              .then((onValue) {
                            if (onValue) {
                              Navigator.pushReplacement(context,
                                  CupertinoPageRoute(builder: (context) {
                                return AssignSuccessfullScreen();
                              }));
                            } else {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return AssignFailureScreen();
                              }));
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: <Widget>[
                              //NAME
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Name: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        list[index].name,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "ID: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        list[index].id,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: list.length),
                  ),
          ],
        ),
      ),
    );
  }
}
