import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ForgotController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/contactusController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartFAQ.dart';
import 'package:millionmart_cleaned/MillionMart/widget/ManagerDialog.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'MillionMartLogin.dart';

class MillionMartForgotPassword extends StatefulWidget {
  MillionMartForgotPassword({Key? key}) : super(key: key);

  @override
  _MillionMartForgotPasswordState createState() =>
      _MillionMartForgotPasswordState();
}

class _MillionMartForgotPasswordState extends State<MillionMartForgotPassword>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isCodeSent = false;
  late String mobile, name, email, id, otp, countrycode, countryName;
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  // late Animation buttonSqueezeanimation;
  late AnimationController buttonController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void validateAndSubmit(String _number) async {
    if (validateAndSave()) {
      // _playAnimation();
      // validAniatin();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MillionMartLogin(number: _number,)));
    }
  }

  // Future<Null> _playAnimation() async {
  //   try {
  //     await buttonController.forward();
  //   } on TickerCanceled {}
  // }

  // Future<void> validAniatin() async {
  //   Future.delayed(Duration(seconds: 2)).then((_) async {
  //     await buttonController.reverse();

  //     Navigator.push(context, MaterialPageRoute(builder: (context) =>  MillionMartLogin()));
  //   });
  // }

  getPwdBtn() {
    return CupertinoButton(
      child: Container(
          // width: buttonSqueezeanimation.value,
          height: 45,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffF58323), Color(0xffFBA35B)],
                stops: [0, 1]),
            borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
          ),
          child: Text(GET_PASSWORD,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: white, fontWeight: FontWeight.normal))
          // : new CircularProgressIndicator(
          //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          //   ),
          ),
      onPressed: () {
        if (mobileController.text.isEmpty) {
          Get.snackbar(
            "error".tr,
            "fullFields".tr,
            backgroundColor: notificationBackground,
            colorText: notificationTextColor,
          );
        } else {
          ForgotController.SendForgotPassword(mobileController.text);
          validateAndSubmit(mobileController.text);
        }
      },
    );
    // return new AnimatedBuilder(
    //   // builder: _buildBtnAnimation,
    //   animation: buttonSqueezeanimation,
    // );
  }

  Widget _buildBtnAnimation(BuildContext context, Widget child) {
    return CupertinoButton(
      child: Container(
          // width: buttonSqueezeanimation.value,
          height: 45,
          alignment: FractionalOffset.center,
          decoration: new BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffF58323), Color(0xffFBA35B)],
                stops: [0, 1]),
            borderRadius: new BorderRadius.all(const Radius.circular(50.0)),
          ),
          child: Text(GET_PASSWORD,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: white, fontWeight: FontWeight.normal))
          // : new CircularProgressIndicator(
          //     valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          //   ),
          ),
      onPressed: () {
        if (mobileController.text.isEmpty) {
          Get.snackbar(
            "error".tr,
            "fullFields".tr,
            backgroundColor: notificationBackground,
            colorText: notificationTextColor,
          );
        } else {
          ForgotController.SendForgotPassword(mobileController.text);
          validateAndSubmit(mobileController.text);
        }
      },
    );
  }

  bool validateAndSave() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  imageView() {
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

  forgotPassTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Center(
          child: new Text(
            FORGOT_PASSWORDTITILE,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: lightblack, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget _buildCountryPicker(CountryCode country) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Image.asset(
                '',
                // country.flagUri,
                package: 'country_code_picker',
                height: 35,
                width: 30,
              ),
            ),
          ),
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Text(
                // country.dialCode
                '',
              ),
            ),
          ),
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: new Text(
                // country.name,
                '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: mobileController,
        onSaved: (String? value) {
          mobile = value!;
          print('Mobile no:$mobile');
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.call),
            hintText: "Mobile Number",
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  expandedBottomView() {
    return Expanded(
        child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Form(
                      key: _formkey,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            forgotPassTxt(),
                            // setCountryCode(),
                            setMobileNo(),
                            getPwdBtn(),
                            _termsText(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Contactus contactus = Get.find<Contactus>();
  callNumber() async {
    var number = "+${contactus.no}";
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print(res);
  }

  _termsText() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0,left: 5, bottom: 16.0,),
        child: RichText(
          text: TextSpan(
            text: "Don’t you remember your registered Mobile number?\n",
            style: TextStyle(
              color: Colors.grey,
            ),
            children: [
              TextSpan(text: 'Contact '),
              TextSpan(
                  text: 'Customer Support ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      callNumber();
                    }),
              TextSpan(text: 'now !'),
            ],
          ),
        ),
      ),
    );
  }

  back() {
    return BoxDecoration(
      color: Colors.white,
      // gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primaryLight2, primaryLight3], stops: [0, 1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        } // currentFocus.dispose();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // shadowColor: Colors.black,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.off(
                        () => MillionMartLogin(
                          number: mobileController.text,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  // CircleAvatar(
                  //   backgroundImage: NetworkImage("<https://randomuser.me/api/portraits/men/5.jpg>"),
                  //   maxRadius: 20,
                  // ),
                  SizedBox(
                    width: 12,
                  ),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text("Security and Setting",style: TextStyle( fontSize: 20 ,fontWeight: FontWeight.w600),),
                  //       SizedBox(height: 6,),
                  //       // Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                  //     ],
                  //   ),
                  // ),
                  // Icon(Icons.more_vert,color: Colors.black,),
                ],
              ),
            ),
          ),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: back(),
          child: Center(
            child: ScreenTypeLayout(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                  //   child: IconButton(onPressed: (){
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (BuildContext context) => MillionMartLogin(),
                  //     ));
                  //   },
                  //       icon: Icon(Icons.arrow_back_ios)
                  //   ),
                  // ),
                  imageView(),
                  expandedBottomView(),
                ],
              ),
              desktop: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      imageView(),
                      expandedBottomView(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
