import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:storemanager/models/allAppUsers.dart';
import 'package:storemanager/services/getAllAppUsers.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/utils_importer.dart';
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
    return Align(
        alignment: Alignment.topRight,
        child: Text(
          "ACTIVE",
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
        ));
  }

  inactiveTag() {
    return Align(
        alignment: Alignment.topRight,
        child: Text(
          "INACTIVE",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ));
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
                      floating: true,
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
                      expandedHeight: 140,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              width = MediaQuery.of(context).size.width * 0.7;
                            });
                          },
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                                padding: EdgeInsets.only(bottom: 10),
                                duration: Duration(milliseconds: 800),
                                width: width,
                                child: TextField(
                                  autofocus: false,
                                  controller: searchController,
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: formTitleTextStyle,
                                  decoration: InputDecoration(
                                    helperText:
                                        "Search by User Name, Contact no., E-mail",
                                    helperMaxLines: 2,
                                    hintText: "Eg. 9978xxx",
                                    labelText: "Search",
                                    labelStyle: labelTextStyle,
                                  ),
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
                                )),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
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
                              Divider(
                                color: Theme.of(context).primaryColorDark,
                              ),

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
                                      flex: 2,
                                      child: Text(
                                        searchList[index].userId,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

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
                                      flex: 2,
                                      child: Text(
                                        searchList[index].userFullname,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

                              //CONTACT
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Contact: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                              showInfo(
                                                  searchList[index].userPhone),
                                              style: suffixTextStyle),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.call),
                                          color: Colors.green,
                                          onPressed: () async {
                                            var url =
                                                'tel:${searchList[index].userPhone}';
                                            if (await canLaunch(url))
                                              await launch(url);
                                            else
                                              throw 'cant';
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

                              //EMAIL
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "EMAIL: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                              showInfo(
                                                  searchList[index].userEmail),
                                              style: suffixTextStyle),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon:
                                                Icon(MdiIcons.cardAccountMail),
                                            color: Colors.red,
                                            onPressed: () async {
                                              var url =
                                                  'mailto:${searchList[index].userEmail}';
                                              if (await canLaunch(url))
                                                await launch(url);
                                              else
                                                throw 'cant';
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

                              //WALLET
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
                                      flex: 2,
                                      child: Text(
                                        searchList[index].wallet,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

                              //TOTAL AMOUNT
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Total Amount: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].totalAmount),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].totalOrders),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

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
                                      flex: 2,
                                      child: Text(
                                        showInfo(
                                            searchList[index].totalRewards),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),
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
