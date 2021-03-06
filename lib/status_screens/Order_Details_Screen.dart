import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bazarmanager/services/getorderdetails.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/utils_importer.dart';

class OrderDetailsScreen extends StatefulWidget {
  String orderid;
  OrderDetailsScreen({@required this.orderid});
  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
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
        child: FutureBuilder(
          future: getOrderDetails(widget.orderid),
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
                          "Order Details",
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
            } else if (snapshot.data != null) {
              return CustomScrollView(
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
                      "Order Details",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                    ),
                    expandedHeight: 80,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Order ID: ${widget.orderid}",
                              style: prefixTextStyle,
                            ),
                            Text(
                              "Items NOS : ${snapshot.data.length.toString()}",
                              style: prefixTextStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
//                      delegate: SliverChildListDelegate([],),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 35),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(18),
                          color: Colors.grey.withOpacity(0.2),
                          child: Column(
                            children: <Widget>[
                              //STATUS
                              Container(
//                    color: Colors.red,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Stock: ",
                                          style: prefixTextStyle)),
                                  Expanded(
                                    child: snapshot.data[index].inStock == "1"
                                        ? inStockTag()
                                        : outOfStockTag(),
                                  )
                                ]),
                              ),
                              SizedBox(height: 5),

                              //Product NAME
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Product Name: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    showInfo(snapshot.data[index].productName),
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

                              //Quantity
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Quanity: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    showInfo(snapshot.data[index].qty) +
                                        showInfo(snapshot.data[index].unit),
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

                              //PRICE
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Price: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    showInfo(snapshot.data[index].price),
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

                              //TAX
                              Container(
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "TAX: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    showInfo(snapshot.data[index].tax),
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

                              //PRIDUCT IMAGE
//                          CircleAvatar(
//                            radius: 50,
//                            backgroundImage:
//                                NetworkImage(snapshot.data[index].productImage),
//                          )
                            ],
                          ),
                        );
                      },
                      childCount: snapshot.data.length,
                    ),
                  ),
                ],
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
                          "Order Details",
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
            }
          },
        ),
      ),
    );
  }
}
