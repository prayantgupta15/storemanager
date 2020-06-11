import 'package:app_settings/app_settings.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storemanager/models/allProducts.dart';
import 'package:storemanager/models/stock_update.dart';
import 'package:storemanager/services/getAllProducts.dart';
import 'package:storemanager/services/stock_update_method.dart';
import 'package:storemanager/status_screens/Faiulure/stockUpdatefail.dart';
import 'package:storemanager/status_screens/succefull/stockUpdatesucess.dart';
import 'package:storemanager/utils/common_utils.dart';
import 'package:storemanager/utils/shared_preferences_util.dart';
import 'package:storemanager/utils/utils_importer.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
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
      setState(() {});
    }
  }

  @override
  void initState() {
    print("stock screeen init");
    super.initState();
    checkConnection();
  }

  final productIDController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final searchController = TextEditingController(text: '');
  final unitController = TextEditingController();
  final FocusNode _quantityFocus = FocusNode();

  TextStyle labelTextStyle = TextStyle(
    color: UtilsImporter().colorUtils.greycolor,
    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
  );

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _prodSelected = false, _isPressed = false;
  String helperText = "Select a Product First.";
  TextStyle error = TextStyle(
    fontSize: 12,
    color: Colors.red,
    fontFamily: UtilsImporter().stringUtils.HKGrotesk,
  );
  GlobalKey<AutoCompleteTextFieldState<ProductData>> key =
      new GlobalKey<AutoCompleteTextFieldState<ProductData>>();

  @override
  Widget build(BuildContext context) {
    Text heading = Text(
      getTranslated(context, 'UPDATE_STOCK_KEY'),
      style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: UtilsImporter().stringUtils.HKGrotesk),
    );
    TextStyle formTitleTextStyle = TextStyle(
        fontFamily: UtilsImporter().stringUtils.HKGrotesk,
        fontWeight: FontWeight.w500,
        fontSize: 15.0,
        color: Theme.of(context).primaryColorDark);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        child: FutureBuilder(
            future: getStoreDataProducts(),
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
                          heading,
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
                return Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: Icon(
                                          Icons.keyboard_backspace,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      heading,
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                ),
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/icons.png'),
                                  radius:
                                      MediaQuery.of(context).size.width / 10,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 5.0,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      AutoCompleteTextField<ProductData>(
                                        key: key,
                                        textInputAction: TextInputAction.none,
                                        controller: searchController,
                                        clearOnSubmit: false,
                                        style: formTitleTextStyle,
                                        decoration: InputDecoration(
                                            hintText: "Eg.Apple",
                                            suffixIcon: productList != null
                                                ? Icon(
                                                    Icons.search,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )
                                                : Icon(
                                                    Icons.cloud_download,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            labelText: "Search Product",
                                            labelStyle: labelTextStyle,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                        itemBuilder: (context, item) {
                                          return ListTile(
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              size: 12,
                                            ),
                                            title: Text(
                                              "Name: " + item.productName,
                                              style: formTitleTextStyle,
                                            ),
                                            subtitle: Text(
                                              "ID:" + item.productId,
                                              style: labelTextStyle,
                                            ),
                                          );
                                        },
                                        itemFilter: (item, query) {
                                          return item.productName
                                              .toLowerCase()
                                              .startsWith(query.toLowerCase());
                                        },
                                        itemSorter: (a, b) {
                                          return a.productName
                                              .compareTo(b.productName);
                                        },
                                        suggestions: snapshot.data,
                                        itemSubmitted: (item) {
                                          setState(() {
                                            _prodSelected = true;
                                            searchController.text =
                                                item.productName;
                                            unitController.text = item.unit;
                                            productIDController.text =
                                                item.productId;
                                            priceController.text = item.price;
                                          });
                                        },
                                      ),
                                      _isPressed == true &&
                                              _prodSelected == false
                                          ? Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  "Product Not Selected",
                                                  style: error))
                                          : Text(
                                              " ",
                                              style: TextStyle(fontSize: 1.0),
                                            ),

                                      SizedBox(height: 20),

                                      //PRODUCT ID
                                      TextField(
                                        controller: productIDController,
                                        enabled: false,
                                        style: formTitleTextStyle,
                                        decoration: InputDecoration(
                                            helperText:
                                                "Auto-Fills on Product selection",
                                            helperStyle: labelTextStyle,
                                            labelText: "Product ID",
                                            labelStyle: labelTextStyle,
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                      SizedBox(height: 20),

                                      //PRODCUT UNIT
                                      TextField(
                                        enabled: false,
                                        controller: unitController,
                                        style: formTitleTextStyle,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                            helperText:
                                                "Auto-Fills on Product selection",
                                            helperStyle: labelTextStyle,
                                            labelText: "Unit",
                                            labelStyle: labelTextStyle,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      SizedBox(height: 20),

                                      //PRICE
                                      TextField(
                                        enabled: false,
                                        controller: priceController,
                                        style: formTitleTextStyle,
                                        showCursor: true,
                                        decoration: InputDecoration(
                                            helperText:
                                                "Auto-Fills on Product selection",
                                            helperStyle: labelTextStyle,
                                            labelText: "Price",
                                            labelStyle: labelTextStyle,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            )),
                                      ),
                                      SizedBox(height: 20),

                                      //QUANTIYY
                                      TextFormField(
                                        validator: (String val) {
                                          if (val.isEmpty)
                                            return 'Value  cannot be empty';
                                        },
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        controller: quantityController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        focusNode: _quantityFocus,
                                        onFieldSubmitted: (value) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        style: formTitleTextStyle,
                                        decoration: InputDecoration(
                                          labelText: "Quantity",
                                          labelStyle: labelTextStyle,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 30,
                                ),
                                RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 8),
                                  child: Text(
                                getTranslated(context, 'UPDATE_STOCK_KEY'),
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 20,
                                      fontFamily:
                                          UtilsImporter().stringUtils.HKGrotesk,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isPressed = true;
                                    });

                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate() &
                                        _prodSelected) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      priceController.text.replaceAll(" ", '');
                                      quantityController.text
                                          .replaceAll(" ", '');
                                      print("VALIDATION TREU");
                                      bool result = await stockUpdate(
                                          StockUpdateItem(
                                              productId:
                                                  productIDController.text,
                                              unit: unitController.text,
                                              price: priceController.text
                                                  .toString(),
                                              quantity: quantityController.text
                                                  .toString(),
                                              storeId:
                                                  await SharedPreferencesUtil
                                                      .getStoreId()));
                                      print("RESULT" + result.toString());
                                      result
                                          ? Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                              _isLoading = false;
                                              searchController.clear();
                                              productIDController.clear();
                                              unitController.clear();
                                              quantityController.clear();
                                              priceController.clear();

                                              FocusScope.of(context).unfocus();

                                              return StockUpdateSuccess();
                                            }))
                                          : Navigator.push(context,
                                              CupertinoPageRoute(
                                                  builder: (context) {
                                              _isLoading = false;
                                              FocusScope.of(context).unfocus();
                                              return StockUpdateFail();
                                            }));
                                    } else
                                      print("ALL VALUES ARE NOT ENTRED");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          )
                        : Container()
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
heading,                        ],
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
            }),
      ),
    );
  }
}
