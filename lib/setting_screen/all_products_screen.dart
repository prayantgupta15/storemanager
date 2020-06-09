import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storemanager/models/allProducts.dart';
import 'package:storemanager/services/getAllProducts.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/utils_importer.dart';

class AllProductsScreen extends StatefulWidget {
  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  double width = 0;
  List<ProductData> searchList3 = List<ProductData>();
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
          future: getStoreDataProducts(),
          builder: (context, AsyncSnapshot snapshot) {
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
                          "All Products",
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
              print("snapshot lenght" + snapshot.data.length.toString());
              if (searchController.text.length == 0) {
                searchList3 = productList;
                print("SNAPSHOT.DATA => SEARCH_LIST" +
                    searchList3.length.toString());
              }

              return Scrollbar(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        "All Products",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
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
                                        "Search by Product Name, Category Name",
                                    helperMaxLines: 2,
                                    hintText: "Eg. Apple",
                                    labelText: "Search",
                                    labelStyle: labelTextStyle,
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      searchList3 = List<ProductData>();
                                      print(text);
                                      text = text.toLowerCase();
                                      text = text.trim();
                                      for (int i = 0;
                                          i < snapshot.data.length;
                                          i++) {
                                        print("index" + i.toString());
                                        print("searching for: " + text);
                                        if (snapshot.data[i].productName !=
                                                null &&
                                            snapshot.data[i].productName
                                                .toLowerCase()
                                                .contains(text))
                                          searchList3.add(snapshot.data[i]);
                                        else if (snapshot.data[i].title != null &&
                                            snapshot.data[i].title
                                                .toLowerCase()
                                                .contains(text))
                                          searchList3.add(snapshot.data[i]);
                                      }
                                      print(snapshot.data.length.toString());
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
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                                    child: searchList3[index].inStock == "1"
                                        ? inStockTag()
                                        : outOfStockTag(),
                                  )
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //PRODUCT ID
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Product ID: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].productId,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //CATEGORY ID
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Category ID: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].categoryId,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

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
                                      child: SelectableText(
                                        searchList3[index].productName,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //TITLE
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Title: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: SelectableText(
                                        searchList3[index].title,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

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
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].price,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //MRP
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "MRP: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].mrp,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //Unit Value
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Unit Value: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].unitValue,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //Unit
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Unit: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].unit,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //STOCK VALUE
                              Container(
//                    color: Colors.red,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Stock: ",
                                          style: prefixTextStyle)),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      searchList3[index].stock,
                                      style: suffixTextStyle,
                                    ),
                                  )
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //Increments
                              Container(
//                    color: Colors.blue,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Increments: ",
                                      style: prefixTextStyle,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        searchList3[index].increament,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                              Divider(color: Theme.of(context).primaryColorDark),

                              //Rewards
                              Container(
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
                                        searchList3[index].rewards,
                                        style: suffixTextStyle,
                                      ))
                                ]),
                              ),
                            ],
                          ),
                        );
                      }, childCount: searchList3.length),
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
                          "All Products",
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
