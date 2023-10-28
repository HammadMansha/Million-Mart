import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/cartController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MMBarcodeSearch.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ManagerDialog.dart';
import 'SearchBar.dart';

var qrImageSearchData = [].obs;
var qrIsLoadingProducts = true.obs;

class MillionMartAppBar extends StatefulWidget {
  MillionMartAppBar({
    Key? key,
  }) : super(key: key);

  // QrScannerController qrScannerController= Get.put(QrScannerController());
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  @override
  _MillionMartAppBarState createState() => _MillionMartAppBarState();
}

class _MillionMartAppBarState extends State<MillionMartAppBar> {
  List<BarcodeFormat> selectedFormats = [...MillionMartAppBar._possibleFormats];

  CartController cartController = Get.put(CartController());

  late ScanResult scanResult;

  var _aspectTolerance = 0.00;

  var _selectedCamera = -1;

  var _useAutoFocus = true;

  var _autoEnableFlash = false;

  bool checkLogin = false;

  isLogin() async {
    final SharedPreferences _prefs = await Constants.prefs;
    if (_prefs.getBool('loggedIn') != null) {
      checkLogin = _prefs.getBool('loggedIn')!;
      print('Login Check $checkLogin');
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('search_qr_login'.tr),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), primary: primaryColor),
                child: Text('search_product'.tr),
                onPressed: () async {
                  Navigator.pop(context);
                  String scan = await _scan();
                  print("Barcode Value is : " + scan);
                  if (scan.isNotEmpty) {
                    searchWithQR(scan);
                    Get.to(() => QRSearchProducts());
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), primary: primaryColor),
                child: Text('login_web'.tr),
                onPressed: () async {
                  if (checkLogin == true) {
                    String scan = await _scan();
                    print('Scanned $scan');
                    Navigator.pop(context);
                    if (scan.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'There is an error logging you in.');
                    } else {
                      loginWithQRWeb(scan);
                    }
                  } else {
                    Fluttertoast.showToast(msg: 'Login to use this feature.');
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    cartController.cartCoount();
    isLogin();
  }

  Future<String> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'Cancel',
            'flash_on': 'Flash On',
            'flash_off': 'Flash Off',
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
      print('QR Scanner Result ${scanResult.rawContent}');
      return scanResult.rawContent.toString();
      // var decoded = base64Url.decode(scanResult.rawContent.toString());
      // print('decoded qr.........'+decoded.toString());
    } on Exception {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
        );
      });
    }
    throw 'Checked';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Scaffold.of(context).openDrawer();
        },
        child: Icon(
          Icons.menu,
          color: Color(0xFF0A3966),
        ),
      ),
      titleSpacing: 0,
      title: Image.asset(
        'assets/icon/mmlogo.png',
        width: 135.0,
        // height: 18.0,
        fit: BoxFit.cover,
      ),
      centerTitle: false,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: primaryColor),
      backgroundColor: statusBarColor,
      actions: <Widget>[
        InkWell(
          child: Icon(
            Icons.qr_code_scanner,
            color: primaryColor,
            // .withOpacity(0.5),
            size: 26,
          ),
          onTap: () async {
            final action = CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_search,
                        color: secondaryColor,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'search_product'.tr,
                        style: TextStyle(
                            fontSize: 15.0,
                            // color: Colors.black,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.pop(context);
                    String scan = await _scan();
                    print("Barcode Value is : " + scan);
                    if (scan.isNotEmpty) {
                      searchWithQR(scan);
                      Get.to(() => QRSearchProducts());
                    }
                  },
                ),
                CupertinoActionSheetAction(
                  child: Row(
                    children: [
                      Icon(
                        Icons.document_scanner_outlined,
                        color: Colors.indigo.shade700,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        'login_web'.tr,
                        style: TextStyle(
                            fontSize: 15.0,
                            // color: Colors.black,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  isDestructiveAction: true,
                  onPressed: () async {
                    if (checkLogin == true) {
                      String scan = await _scan();
                      print('Scanned $scan');
                      Navigator.pop(context);
                      if (scan.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'There is an error logging you in.');
                      } else {
                        loginWithQRWeb(scan);
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Login to use this feature.');
                    }
                  },
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            );
            showCupertinoModalPopup(
                context: context, builder: (context) => action);
            // _displayTextInputDialog(context);
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        InkWell(
          child: ImageIcon(
            AssetImage('assets/image/manager.png'),
            color: primaryColor,
            // withOpacity(0.5),
            size: 26,
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => searchBar(),
            //     ));
            showDialog(
                context: context,
                builder: (context) => ManaGerDialog(),
                barrierDismissible: true);
          },
        ),
        SizedBox(
          width: 10.0,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: new Stack(children: <Widget>[
              Center(
                child: Icon(
                  Icons.shopping_cart_rounded,
                  // color: Color(0xFF0A3965),
                  size: 26,
                ),
              ),

              // _dbcartmanager.getCartCount()

              cartController.cartCoount.length != 0
                  ? new Positioned(
                      top: 0.0,
                      right: 5.0,
                      bottom: 15,
                      child: Container(
                          // height: 100,
                          //   width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: new Center(
                            child: Padding(
                                padding: EdgeInsets.all(2),
                                child: Obx(() {
                                  return new Text(
                                    "${cartController.cartCoount.length}",
                                    style: TextStyle(
                                        fontSize: 8, color: Colors.white),
                                  );
                                })),
                          )),
                    )
                  : new Positioned(
                      top: 0.0,
                      right: 5.0,
                      bottom: 15,
                      child: Container(
                          // height: 100,
                          //   width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent),
                          child: new Center(
                            child: Padding(
                              padding: EdgeInsets.all(2),
                            ),
                          )),
                    )
              // : Container()
            ]),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MillionMartCart(),
                  ));
            },
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
      ],
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
            child: SearchBar(),
          ),
        ),
        preferredSize: Size.fromHeight(120),
      ),
      elevation: 2.0,
    );
  }

  loginWithQRWeb(String scan) async {
    var url = scan.split('qrcodelogin/')[0];
    var token = scan.split('qrcodelogin/')[1];
    print(url + 'qrcodelogin/');
    print(token);
    final SharedPreferences _prefs = await Constants.prefs;
    var username = _prefs.getString('email');
    var password = _prefs.getString('password');
    print(username);
    print(password);
    var body = {
      'username': username,
      'password': password,
      'token': token,
    };
    final response =
        await http.post(Uri.parse(url + 'qrcodelogin'), body: body);
    print('Response ${response.body}');
  }

  Future<dynamic> searchWithQR(String scan) async {
    print("inside qr api ");
    qrImageSearchData.clear();
    var url = Constants.baseUrl;
    final response = await http.post(Uri.parse(url + '/barcode-search'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"barcode": scan}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (response.body.contains('No Product Found')) {
        qrIsLoadingProducts.value = false;
        print("api reponse With No product " + response.body);
        qrImageSearchData.value = [];
      } else {
        qrImageSearchData.value = jsonDecode(response.body);
        qrIsLoadingProducts.value = false;
        print("Api data is :" + data.toString());
      }
    } else {
      imageSearchData.value = jsonDecode(response.body);
      qrIsLoadingProducts.value = false;
      Exception("Api Not Hit");
      print(response.body);
      throw ('Api Not Hit');
    }
  }
}
