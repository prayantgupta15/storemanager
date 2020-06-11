import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storemanager/models/allOrders.dart';
import 'package:storemanager/models/allProducts.dart';
import 'package:storemanager/services/getDeliveryBoysList.dart';
import 'package:storemanager/services/getTodaysOrders.dart';
import 'package:storemanager/status_screens/Faiulure/Order_Cancelled_Screen.dart';
import 'package:storemanager/status_screens/Order_Details_Screen.dart';
import 'package:storemanager/status_screens/assign_screen.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/utils_importer.dart';
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
                    floating: true,
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
                                      "Search by OrderId, DeliveryBoy, Soceity, Receiver Name",
                                  helperMaxLines: 2,
                                  hintText: "Eg. City Name",
                                  labelText: "Search",
                                  labelStyle: labelTextStyle,
                                ),
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
                              )),
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
//                            STATUS
                              Container(
//                    color: Colors.red,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Status: ",
                                          style: prefixTextStyle)),
                                  Expanded(
                                      child:
                                          trackOrder(searchList[index].status))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            ASSIGN TO
                              searchList[index].status != '3' &&
                                      searchList[index].status != '4'
                                  ? Container(
//                    color: Colors.red,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Text("Assign To: ",
                                                style: prefixTextStyle)),
                                        searchList[index].assignTo !=
                                                "0" //DELIVERY BOY ASSIGNED
                                            ? Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "ID:\t" +
                                                      searchList[index]
                                                          .assignTo +
                                                      "\n" +
                                                      "Name:\t" +
                                                      getBoyName(
                                                          searchList[index]
                                                              .assignTo),
                                                  style: suffixTextStyle,
                                                ),
                                              )
                                            : RaisedButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: Text("Assign Order"),
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      CupertinoPageRoute(
                                                          builder: (context) {
                                                    return AssignOrderScreen(
                                                        Orderid:
                                                            searchList[index]
                                                                .saleId);
                                                  }));
                                                },
                                              )
//                                        : cancelTag()
                                      ]),
                                    )
                                  : Container(
                                      width: 1,
                                      height: 1,
                                    ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].saleId),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

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
                                        showInfo(
                                            searchList[index].receiverName),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            CONTACT
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
                                        Text(
                                            showInfo(searchList[index]
                                                .receiverMobile),
                                            style: suffixTextStyle),
                                        IconButton(
                                          icon: Icon(Icons.call),
                                          color: Colors.green,
                                          onPressed: () async {
                                            var url =
                                                'tel:${searchList[index].receiverMobile}';
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

//                            HOUSENO
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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].houseNo),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            SOCIETY
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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].socityName),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                             DATE
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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].onDate),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            TIME
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
                                      flex: 2,
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
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            ORDER AMOUNT
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
                                      flex: 2,
                                      child: Text(
                                        showInfo(searchList[index].totalAmount),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),

//                            PAYMENT MODE
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
                                      flex: 2,
                                      child: Text(
                                        showInfo(
                                            searchList[index].paymentMethod),
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(
                                  color: Theme.of(context).primaryColorDark),
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
