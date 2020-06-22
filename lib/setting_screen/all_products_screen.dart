import 'package:app_settings/app_settings.dart';
import 'package:bazarmanager/models/allProducts.dart';
import 'package:bazarmanager/services/getAllProducts.dart';
import 'package:bazarmanager/utils/common_utils.dart';
import 'package:bazarmanager/utils/utils_importer.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                          getTranslated(context, 'PRODUCTS_KEY'),
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
                        getTranslated(context, 'PRODUCTS_KEY'),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                            fontFamily: UtilsImporter().stringUtils.HKGrotesk),
                      ),
                      floating: false,
                      expandedHeight: 120,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          alignment: Alignment.bottomLeft,
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
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.2),
                                    hintText:
                                        "Search by Product Name, Category Name",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 12),
                                    hintMaxLines: 2,
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
                                        else if (snapshot.data[i].title !=
                                                null &&
                                            snapshot.data[i].title
                                                .toLowerCase()
                                                .contains(text))
                                          searchList3.add(snapshot.data[i]);
                                      }
                                      print(snapshot.data.length.toString());
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
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
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
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].productId,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].categoryId,
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
                                      child: SelectableText(
                                    searchList3[index].productName,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: SelectableText(
                                    searchList3[index].title,
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
                                    searchList3[index].price,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].mrp,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].unitValue,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].unit,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

                              //STOCK VALUE
                              Container(
//                    color: Colors.red,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Text("Stock: ",
                                          style: prefixTextStyle)),
                                  Expanded(
                                    child: Text(
                                      searchList3[index].stock,
                                      style: suffixTextStyle,
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(height: 5),

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
                                      child: Text(
                                    searchList3[index].increament,
                                    style: suffixTextStyle,
                                  ))
                                ]),
                              ),
                              SizedBox(height: 5),

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
                          getTranslated(context, 'PRODUCTS_KEY'),
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
