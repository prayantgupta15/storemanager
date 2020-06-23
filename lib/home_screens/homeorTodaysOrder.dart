import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bazarmanager/models/allOrders.dart';
import 'package:bazarmanager/models/allProducts.dart';
import 'package:bazarmanager/services/getDeliveryBoysList.dart';
import 'package:bazarmanager/services/getTodaysOrders.dart';
import 'package:bazarmanager/status_screens/Faiulure/Order_Cancelled_Screen.dart';
import 'package:bazarmanager/status_screens/Order_Details_Screen.dart';
import 'package:bazarmanager/status_screens/assign_screen.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/utils_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeorTodaysOrdersScreen extends StatefulWidget {
  @override
  _HomeorTodaysOrdersScreenState createState() =>
      _HomeorTodaysOrdersScreenState();
}

double width = 0;

class _HomeorTodaysOrdersScreenState extends State<HomeorTodaysOrdersScreen> {
  TextEditingController searchController = TextEditingController(text: '');
  List<AllOrders> searchList = List<AllOrders>();

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
    } else {
      getBoysList();

      setState(() {});
    }
  }

  TextStyle prefixTextStyle = TextStyle(
      color: Colors.grey,
      fontFamily: UtilsImporter().stringUtils.HKGrotesk,
      fontSize: 15,
      fontWeight: FontWeight.w700);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoysList();
    checkConnection();
    print("TODAYS INIT");
  }

  var snapshot;
  @override
  Widget build(BuildContext context) {
    print(("BUILD"));

//TEXT STYLES
    TextStyle bottomRowStyle = TextStyle(
        color: Colors.white,
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontSize: 15,
        fontWeight: FontWeight.w700);
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

    return SafeArea(
      child: FutureBuilder(
        future: getTodaysOrders(),
        builder: (context, snapshot) {
          print("futurebuilder");
          if (snapshot.data == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    getTranslated(context, 'TODAY_ORDERS_KEY'),
//                    "Today's Orders",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk),
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
              print(" SNAPSHOT.DATA => SEARCH_LIST");
              searchList = TodaysOrdersList;
              print(searchList.length.toString());
            }
            return Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    floating: false,
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
                                        "Search by OrderId, DeliveryBoy, Soceity, Receiver Name",
                                    hintMaxLines: 2,
                                    hintStyle: TextStyle(fontSize: 12)),
                                onChanged: (text) {
                                  searchList = List<AllOrders>();

                                  setState(() {
                                    text = text.trim();
                                    text = text.toLowerCase();
                                    for (int i = 0;
                                        i < snapshot.data.length;
                                        i++) {
                                      print("index" + i.toString());
                                      print("searching for: " + text);

                                      //SALE ID
                                      if (snapshot.data[i].saleId != null &&
                                          snapshot.data[i].saleId
                                              .startsWith(text)) {
                                        print("TRUE for index $i");
                                        searchList.add(snapshot.data[i]);
                                      }
                                      //BOY NAME
                                      else if (snapshot.data[i].assignTo !=
                                              "0" &&
                                          (getBoyName(snapshot.data[i].assignTo)
                                              .toString()
                                              .toLowerCase()
                                              .contains(text.toLowerCase()))) {
                                        searchList.add(snapshot.data[i]);
                                      }
                                      //RECEIVER NAME
                                      else if (snapshot.data[i].receiverName !=
                                              null &&
                                          snapshot.data[i].receiverName
                                              .toLowerCase()
                                              .contains(text))
                                        searchList.add(snapshot.data[i]);

                                      //SOCIETY NAME
                                      else if (snapshot.data[i].socityName !=
                                              null &&
                                          snapshot.data[i].socityName
                                              .contains(text))
                                        searchList.add(snapshot.data[i]);
                                    }
//                                  print(searchList.length.toString());
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    title: Text(
                      "Today's Orders",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            if (searchList[index].status == "3")
                              return OrderCancelledScreen();
                            else
                              return OrderDetailsScreen(
                                  orderid: searchList[index].saleId);
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
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
                                          child: trackOrder(
                                              searchList[index].status),
                                        )
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //ASSIGN TO
                                    searchList[index].status != '3' &&
                                            searchList[index].status != '4'
                                        ? Container(
//                    color: Colors.red,
                                            child: Row(children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("Assign To: ",
                                                      style: prefixTextStyle)),
                                              searchList[index].assignTo != "0"
                                                  ? Expanded(
                                                      child: Text(
                                                        "ID:\t" +
                                                            searchList[index]
                                                                .assignTo +
                                                            "\nName:\t" +
                                                            getBoyName(
                                                                searchList[
                                                                        index]
                                                                    .assignTo),
                                                        style: suffixTextStyle,
                                                      ),
                                                    )
                                                  : RaisedButton(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Text(
                                                        "Assign Order",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                UtilsImporter()
                                                                    .stringUtils
                                                                    .HKGrotesk,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            CupertinoPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return AssignOrderScreen(
                                                              Orderid:
                                                                  searchList[
                                                                          index]
                                                                      .saleId);
                                                        }));
                                                      },
                                                    )
                                            ]),
                                          )
                                        : Container(),
                                    SizedBox(height: 5),

                                    //ORDER ID
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Order ID: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(searchList[index].saleId),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

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
                                            child: Text(
                                          showInfo(
                                              searchList[index].receiverName),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //HOUSENO
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "House No.: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(searchList[index].houseNo),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //SOCIETY
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Soceity: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(
                                              searchList[index].socityName),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    // DATE
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Date: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(searchList[index].onDate),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //TIME
                                    Container(
//                    color: Colors.blue,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Delivery Time: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(searchList[index]
                                                  .deliveryTimeFrom) +
                                              " to " +
                                              showInfo(searchList[index]
                                                  .deliveryTimeTo),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),

                                    //ORDER AMOUNT
                                    Container(
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

                                    //PAYMENT MODE
                                    Container(
                                      child: Row(children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Payment Mode: ",
                                            style: prefixTextStyle,
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          showInfo(
                                              searchList[index].paymentMethod),
                                          style: suffixTextStyle,
                                        ))
                                      ]),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        var url =
                                            'tel:${searchList[index].receiverMobile}';
                                        if (await canLaunch(url))
                                          await launch(url);
                                        else
                                          throw 'cant';
                                      },
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        constraints:
                                            BoxConstraints(maxHeight: 40),
                                        child: Center(
                                          child: Text("CALL",
                                              style: bottomRowStyle),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1),

                                  //ASSIGN TO
                                  searchList[index].status !=
                                              '3' && //NOT CANCELLED AND NOT COMPLETED SHOW DELIVERY BOY
                                          searchList[index].status != '4'
                                      ? searchList[index].assignTo != "0"
                                          ? //BOY IS ASSIGNED
                                          Expanded(
                                              child: Container(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                constraints: BoxConstraints(
                                                    maxHeight: 40),
                                                child: Center(
                                                  child: Text(
                                                    "Assigned To" +
                                                        getBoyName(
                                                            searchList[index]
                                                                .assignTo),
                                                    style: bottomRowStyle,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : //NOT ASSIGNED
                                          Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      CupertinoPageRoute(
                                                          builder: (context) {
                                                    return AssignOrderScreen(
                                                        Orderid:
                                                            searchList[index]
                                                                .saleId);
                                                  }));
                                                },
                                                child: Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  constraints: BoxConstraints(
                                                      maxHeight: 40),
                                                  child: Center(
                                                    child: Text(
                                                      "ASSIGN ORDER",
                                                      style: bottomRowStyle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                      : Container(),
                                ],
                                mainAxisSize: MainAxisSize.max,
                              )
                            ],
                          ),
                        ),
                      );
                    }, childCount: searchList.length),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    getTranslated(context, 'TODAY_ORDERS_KEY'),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Center(
                    child: Text(
                      getTranslated(context, 'NOTHING_KEY'),
                      style: suffixTextStyle,
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
