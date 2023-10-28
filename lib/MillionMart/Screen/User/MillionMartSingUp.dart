import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/OtpController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SignUpController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartT&C.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignUpModelClass.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'package:otp_autofill/otp_autofill.dart';
// import 'package:flutter/gestures.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'MillionMartLogin.dart';

class MillionMartSingUp extends StatefulWidget {
  MillionMartSingUp({Key? key}) : super(key: key);

  @override
  _MillionMartSingUpState createState() => _MillionMartSingUpState();
}

class _MillionMartSingUpState extends State<MillionMartSingUp>
    with TickerProviderStateMixin {
  bool _showPassword = false;
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  // final ccodeController = TextEditingController();
  OTPTextEditController passwordController =
      OTPTextEditController(codeLength: 6);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String name, email, password, mobile, id, countrycode, countryName;

  late Animation buttonSqueezeanimation;

  late AnimationController buttonController;

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      validatanimations();
    }
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  Future<void> validatanimations() async {
    await buttonController.reverse();
    Future.delayed(Duration(milliseconds: 500)).then((_) async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MillionMartLogin()));
    });
  }

  bool validateAndSave() {
    return true;
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   //  ----------- otp autofill code-------
  //   OTPInteractor.getAppSignature()
  //   //ignore: avoid_print
  //       .then((value) => print('signature - $value'));
  //   passwordController = OTPTextEditController(
  //     codeLength: 5,
  //     //ignore: avoid_print
  //     onCodeReceive: (code) => print('Your Application receive code - $code'),
  //   )..startListenUserConsent(
  //         (code) {
  //       final exp = RegExp(r'(\d{5})');
  //       return exp.stringMatch(code ?? '') ?? '';
  //     },
  //     strategies: [
  //       // SampleStrategy(),
  //     ],
  //   );
  // }

  @override
  Future<void> dispose() async {
    await passwordController.stopListen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode _currfocus = FocusScope.of(context);
        if (!_currfocus.hasPrimaryFocus) {
          _currfocus.unfocus();
        }
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MillionMartLogin(),
                      ));
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
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: back(),
              child: Stack(children: [
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: IconButton(
                //           onPressed: () {
                //             Navigator.of(context).push(MaterialPageRoute(
                //               builder: (BuildContext context) =>
                //                   MillionMartLogin(),
                //             ));
                //           },
                //           icon: Icon(Icons.arrow_back_ios)),
                //     ),
                //   ],
                // ),
                Center(
                  child: Column(
                    children: <Widget>[
                      subLogo(),
                      expandedBottomView(),
                    ],
                  ),
                ),
              ]),
            ),
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

  subLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Center(
          child: new Image.asset(
            'assets/image/micon.png',
            width: 80.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  registerTxt() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0),
      child: Center(
        child: new Text('user_registration'.tr,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: lightblack)),
      ),
    );
  }

  setUserName() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.words,
        controller: nameController,
        onSaved: (String? value) {
          name = value!;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_outline),
          hintText: 'user_name'.tr,
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        controller: mobileController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSaved: (String? value) {
          mobile = value!;
          print('Mobile no:$mobile');
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.call_outlined),
            hintText: 'mobile_number'.tr,
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(7.0))),
      ),
    );
  }

  setEmail() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: emailController,
        onSaved: (String? value) {
          email = value!;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'email'.tr,
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(7.0))),
      ),
    );
  }

  setPass() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 0.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: !this._showPassword,
            controller: passwordController,
            onSaved: (val) => password = val!,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: 'password'.tr,
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, maxHeight: 20),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                if (mobileController.text.isEmpty) {
                  Get.snackbar("error".tr, "fullFields".tr,
                      backgroundColor: notificationBackground, colorText: notificationTextColor,);
                } else {
                  passwordController.clear();
                  OtpController.sendOtp(mobileController.text);
                }
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => MillionMartMobailVerification()));
                // Navigator.push(context, MaterialPageRoute(builder: MillionMartMobailVerification()),),}
              },
              style: ButtonStyle(
                splashFactory: InkSplash.splashFactory,
              ),
              child: Text(
                'send_otp'.tr,
                style: TextStyle(
                  color: Color(0xffF68628),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showPass() {
    return Padding(
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Checkbox(
            value: _showPassword,
            onChanged: (bool? value) {
              setState(() {
                _showPassword = value!;
              });
            },
          ),
          Text('show_password'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: lightblack2))
        ],
      ),
    );
  }

  verifyBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBtn(
        title: 'register'.tr,
        onBtnSelected: () async {
          // validateAndSubmit();
          if (mobileController.text.isEmpty ||
              passwordController.text.isEmpty ||
              nameController.text.isEmpty ||
              emailController.text.isEmpty) {
            Get.snackbar("error".tr, "fullFields".tr,
                backgroundColor: notificationBackground,
              colorText: notificationTextColor,);
          } else if (nameController.text.contains(".") ||
              num.tryParse(nameController.text) != null) {
            Get.snackbar("error".tr, "nameError".tr,
                backgroundColor: notificationBackground,
              colorText: notificationTextColor,);
          } else {
            bool emailValid =
                RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                    .hasMatch(emailController.text);
            if (emailValid == true) {
              Signup _signUp = Signup(
                fullname: nameController.text,
                phonenumber: mobileController.text,
                email: emailController.text,
                // mobilenumber: mobileController.text,
                password: passwordController.text,
                mobilenumber: '',
              );
              var res = await signUpController(_signUp);
              if (!res.contains('already')) {
                Future.delayed(Duration(seconds: 3), () {
                  // 5 seconds over, navigate to Page2.
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MillionMartLogin()));
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => Screen2()));
                });
              }
              print(_signUp.fullname);
            } else {
              Get.snackbar("error".tr, "incorrectEmail".tr,
                  backgroundColor: notificationBackground,
                colorText: notificationTextColor,);
            }
          }
        },
      ),
    );
  }

  loginTxt() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('already_customer'.tr + " ",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: lightblack)),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MillionMartLogin(),
                ));
              },
              child: Text(
                'login_here'.tr,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  _termsText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: RichText(
        text: TextSpan(
          text: 'by_creating'.tr,
          style: TextStyle(
            color: Colors.grey,
          ),
          children: <TextSpan>[
            // TextSpan(
            //     text: 'terms',
            //     style: TextStyle(fontWeight: FontWeight.bold, color: primary),
            //     recognizer: TapGestureRecognizer()
            //       ..onTap = () {
            //         print('Terms');
            //       }),
            // TextSpan(text: ' and '),
            TextSpan(
                text: 'term_condition'.tr,
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return MillionMartTC();
                    }));
                  }),
          ],
        ),
      ),
    );
  }

  expandedBottomView() {
    double width = MediaQuery.of(context).size.width;
    return ScreenTypeLayout(
      mobile: Center(
        child: Container(
          // color: Colors.white,
          width: double.infinity,
          // height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          registerTxt(),
                          setUserName(),
                          // setCountryCode(),
                          setMobileNo(),
                          setEmail(),
                          setPass(),
                          showPass(),
                          verifyBtn(),
                          _termsText(),
                          loginTxt(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

//  ---------otp autofill code-----
    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
    passwordController = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{5})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }
}
