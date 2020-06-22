import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:bazarmanager/models/allAppUsers.dart';
import 'package:bazarmanager/services/getAllAppUsers.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/utils_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUsersScreen extends StatefulWidget {
  @override
  _AppUsersScreenState createState() => _AppUsersScreenState();
}

double width = 0;

class _AppUsersScreenState extends State<AppUsersScreen> {
  List<AllAppUsers> searchList = List<AllAppUsers>();
  final searchController = TextEditingController();

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

  //TAGS
  activeTag() {
    return Text(
      "ACTIVE",
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
    );
  }

  inactiveTag() {
    return Text(
      "INACTIVE",
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle suffixTextStyle = TextStyle(
        color: Theme.of(context).primaryColorDark,
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontSize: 15,
        fontWeight: FontWeight.w600);

    TextStyle formTitleTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
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
        child: FutureBuilder(
          future: getAllAppUsers(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
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
                          getTranslated(context, 'APP_USERS_KEY'),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              );
            } else if (snapshot.data.length > 0) {
              if (searchController.text.length == 0) {
                searchList = AppUsersList;
                print("SNAPSHOT.DATA => SEARCH_LIST" +
                    searchList.length.toString());
              }

              return Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      floating: false,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        getTranslated(context, 'APP_USERS_KEY'),
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                      expandedHeight: 120,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                                height: 50,
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                constraints: BoxConstraints(maxHeight: 50),
                                width: MediaQuery.of(context).size.width * 0.68,
                                child: TextField(
                                  autofocus: false,
                                  controller: searchController,
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: formTitleTextStyle,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText:
                                          "Search by User Name, Contact no., E-mail",
                                      hintMaxLines: 2,
                                      hintStyle: TextStyle(fontSize: 12)),
                                  onChanged: (text) {
                                    setState(() {
                                      searchList = List<AllAppUsers>();

                                      text = text.toLowerCase();
                                      print(text);
                                      text = text.trim();
                                      for (int i = 0;
                                          i < snapshot.data.length;
                                          i++) {
                                        print("index" + i.toString());
                                        print("searching for: " + text);
                                        if (snapshot.data[i].userFullname !=
                                                null &&
                                            snapshot.data[i].userFullname
                                                .toLowerCase()
                                                .contains(text))
                                          searchList.add(snapshot.data[i]);
                                        else if (snapshot.data[i].userEmail !=
                                                null &&
                                            snapshot.data[i].userEmail
                                                .contains(text))
                                          searchList.add(snapshot.data[i]);
                                        else if (snapshot.data[i].userPhone !=
                                                null &&
                                            snapshot.data[i].userPhone
                                                .contains(text))
                                          searchList.add(snapshot.data[i]);
                                      }
                                      print(searchList.length.toString());
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: <Widget>[
                                    //STATUS
                                    Container(
//                    color: Colors.red,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Text("Status: ",
                                                style: prefixTextStyle)),
                                        Expanded(
                                          child: searchList[index].status == "0"
                                              ? inactiveTag()
                                              : activeTag(),
                                        )
                                      ]),
                                    ),
                                    SizedBox(height: 15),

                                    //USER ID
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "User ID: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          searchList[index].userId,
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

//                            NAME
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
                                            child: Text(
                                          searchList[index].userFullname,
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

//                                WALLT
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Wallet: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          searchList[index].wallet,
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //TOTAL AMOUNT
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Order Amount: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(
                                              searchList[index].totalAmount),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //total orders
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Total Orders: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(
                                              searchList[index].totalOrders),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //REWARDS
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Rewards: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(
                                              searchList[index].totalRewards),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        var url =
                                            'tel:${searchList[index].userPhone}';
                                        if (await canLaunch(url))
                                          await launch(url);
                                        else
                                          throw 'cant';
                                      },
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "CALL",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: UtilsImporter()
                                                    .stringUtils
                                                    .HKGrotesk,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        var url =
                                            'mailto:${searchList[index].userEmail}';
                                        if (await canLaunch(url))
                                          await launch(url);
                                        else
                                          throw 'cant';
                                      },
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "EMAIL",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: UtilsImporter()
                                                    .stringUtils
                                                    .HKGrotesk,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                mainAxisSize: MainAxisSize.max,
                              )
                            ],
                          ),
                        );
                      }, childCount: searchList.length),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
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
                          getTranslated(context, 'APP_USERS_KEY'),
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily:
                                  UtilsImporter().stringUtils.HKGrotesk),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Center(
                      child: Text(
                        "Nothing to Show",
                        style: suffixTextStyle,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
