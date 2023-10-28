import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';

import 'package:sms_autofill/sms_autofill.dart';

class MillionMartMobailVerification extends StatefulWidget {
  MillionMartMobailVerification({Key? key}) : super(key: key);

  @override
  _MillionMartMobailVerificationState createState() =>
      _MillionMartMobailVerificationState();
}

class _MillionMartMobailVerificationState
    extends State<MillionMartMobailVerification> with TickerProviderStateMixin {
  final dataKey = new GlobalKey();
  late String password,
      mobile,
      username,
      email,
      id,
      city,
      area,
      pincode,
      address,
      mobileno,
      countrycode,
      name,
      latitude,
      longitude,
      dob;
  String? otp;
  bool isCodeSent = false;
  String signature = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;

  @override
  void initState() {
    super.initState();
    getSingature();
  }

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    await SmsAutoFill().listenForCode;
  }

  verifyBtn() {
    return AppBtn(
        title: VERIFY_AND_PROCEED,
        onBtnSelected: () async {
          checkNetwork();
        });
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: notificationBackground,
      elevation: 1.0,
    ));
  }

  Future<void> checkNetwork() async {
    _playAnimation();
    Future.delayed(Duration(milliseconds: 500)).then((_) async {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => MillionMartHome()));
      await buttonController.reverse();
    });
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  getImage() {
    return Container(
      padding: EdgeInsets.only(top: 100.0),
      child: Center(
        child: new Image.asset(
          'assets/image/micon.png',
          width: 80.0,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  monoVarifyText() {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
        child: Center(
          child: new Text(MOBILE_NUMBER_VARIFICATION,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: lightblack)),
        ));
  }

  otpText() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Center(
          child: new Text(ENTER_YOUR_OTP_SENT_TO,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: lightblack, fontStyle: FontStyle.normal)),
        ));
  }

  mobText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.0, left: 20.0, right: 20.0, top: 10.0),
      child: Center(
        child: Text("0123456789",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: lightblack)),
      ),
    );
  }

  otpLayout() {
    return Padding(
        padding: EdgeInsets.only(left: 80.0, right: 80.0, top: 10.0),
        child: Center(
            child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder: FixedColorBuilder(primaryLight2),
                ),
                currentCode: otp,
                codeLength: 5,
                onCodeChanged: (String? code) {
                  otp = code!;
                },
                onCodeSubmitted: (String code) {
                  otp = code;
                })));
  }

  resendText() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0, top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DIDNT_GET_THE_CODE,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: lightblack2, fontWeight: FontWeight.normal),
          ),
          InkWell(
              onTap: () {},
              child: Text(
                RESEND_OTP,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: primaryColor, decoration: TextDecoration.underline),
              ))
        ],
      ),
    );
  }

  expandedBottomView() {
    double width = MediaQuery.of(context).size.width;
    return Expanded(
        child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: width,
                    padding:
                        EdgeInsets.only(top: 50.0, right: 24.0, left: 24.0),
                    child: Container(
                      decoration: back(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          monoVarifyText(),
                          otpText(),
                          mobText(),
                          otpLayout(),
                          verifyBtn(),
                          resendText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  back() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.black12,
        width: 0.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.withOpacity(0.5),
      //     spreadRadius: 5,
      //     blurRadius: 7,
      //     offset: Offset(0, 5), // changes position of shadow
      //   ),
      // ],
      // gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryLight2, primaryLight3], stops: [0, 1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode _currfocus = FocusScope.of(context);
          if (!_currfocus.hasPrimaryFocus) {
            _currfocus.unfocus();
          }
        },
        child: SafeArea(
          child: Container(
            // decoration: back(),
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                    ],
                  ),
                  getImage(),
                  expandedBottomView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
