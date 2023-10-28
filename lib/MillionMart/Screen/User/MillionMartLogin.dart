import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/ForgotController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/GoogleSigninController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SignInController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SocialLoginsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/contactusController.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignInModelClass.dart';
import 'package:millionmart_cleaned/MillionMart/models/SocialLoginsModelClass.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:resize/src/resizeExtension.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MillionMartForgotPassword.dart';
import 'MillionMartHome.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'MillionMartSingUp.dart';
import 'package:http/http.dart' as http;
import 'NoInternet.dart';

class MillionMartLogin extends StatefulWidget {
  MillionMartLogin({Key? key, this.number}) : super(key: key);
  String? number;

  @override
  _MillionMartLoginState createState() => _MillionMartLoginState();
}

class _MillionMartLoginState extends State<MillionMartLogin>
    with TickerProviderStateMixin {
  bool isLocked = false;
  Timer? timer;
  bool _showPassword = false;

  late Timer otptimer;
  int start = 60;

  TextEditingController url = new TextEditingController();
  final HomeController homeController = Get.find<HomeController>();

  void startTimer() {
    const onesec = const Duration(seconds: 1);
    otptimer = new Timer.periodic(onesec, (Timer timer) {
      setState(() {
        if (start < 1) {
          timer.cancel();
        } else if (passwordController.text.isEmpty) {
          start = start - 1;
        } else if (passwordController.text.isNotEmpty) {
          timer.cancel();
          start = 60;
        }
      });
    });
  }

  HomeController controller = Get.find<HomeController>();

  lockCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('lock') != null) {
      String? a = prefs.getString('lock');
      // String b = DateTime.now().subtract(Duration(minutes: 1)).toString();
      String b = DateTime.now().difference(DateTime.parse(a!)).toString();
      String hours = b.split(":")[0];
      String minutes = b.split(':')[1];
      print(hours);
      print(minutes);
      if (int.parse(hours) >= 1) {
        print('Hours');
        setState(() {
          isLocked = false;
          timer?.cancel();
          count = 0;
        });
      } else {
        print('Hours Else');
        if (int.parse(minutes) >= 01) {
          print('Minutes');
          setState(() {
            isLocked = false;
            count = 0;
          });
        } else {
          print('Minutes Else');
          setState(() {
            isLocked = true;
          });
        }
      }
      // if (int.parse(c) = ) {
      //   isLocked = false;
      // }
      // isLocked = true;
    }
    print(prefs.getString('lock'));
    print('lock check');
  }

  late String password,
      mobile,
      username,
      email,
      id,
      countrycode,
      mobileno,
      city,
      area,
      pincode,
      address,
      latitude,
      longitude,
      image;
  late String countryName;

  final mobileController = TextEditingController();
  OTPTextEditController passwordController =
      OTPTextEditController(codeLength: 6);

  late Animation buttonSqueezeanimation;

  late AnimationController buttonController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String emailCheck = 'email';
  int count = 0;

  fingerprintCheck() async {
    final SharedPreferences _prefs = await Constants.prefs;
    if (_prefs.getString('email') != null) {
      emailCheck = _prefs.getString('email')!;
      setState(() {});
      print(emailCheck);
    }
  }

  final LocalAuthentication _localAuthentication = LocalAuthentication();

  authenticate() async {
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
    }
  }

  late String _authenticationResult;

  initializeFaceRecognition() async {
    print('Inside iOS Facial Test');
    if (Platform.isIOS) {
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      print(canCheckBiometrics);
      if (!canCheckBiometrics) {
        setState(() =>
            _authenticationResult = 'This device does not support biometrics');
        print(_authenticationResult);
        return;
      }
      List<BiometricType> availableBiometrics;
      try {
        availableBiometrics =
            await _localAuthentication.getAvailableBiometrics();
        print(availableBiometrics);
      } on PlatformException catch (e) {
        print(e);
      }
      // if (!availableBiometrics.contains(BiometricType.face)) {
      //   setState(() => _authenticationResult = 'This device does not support face recognition');
      //   print(_authenticationResult);
      //   return;
      // }
      bool didAuthenticate = await _localAuthentication.authenticate(
          biometricOnly: true,
          localizedReason: 'Authenticate with face recognition',
          useErrorDialogs: true);
      if (didAuthenticate) {
        setState(() => _authenticationResult = 'Authenticated');

        print(_authenticationResult);
        final SharedPreferences _prefs = await Constants.prefs;
        var phone = _prefs.getString('phone')!;
        var password = _prefs.getString('password');
        SignIn _signIn =
            SignIn(mobilenumber: phone, password: password, email: '');
        signInController(_signIn).then((value) async {
          if (value.toString() == 'null') {
            print('later');
          } else {
            _prefs.setBool('loggedIn', true);
            controller.checkLogin();
            controller.update();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MillionMartHome()));
          }
        });
      } else {
        setState(() => _authenticationResult = 'Not authenticated');
        print(_authenticationResult);
      }
    } else {
      setState(() => _authenticationResult = 'Not compatible platform');
      print(_authenticationResult);
    }
  }

  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = await _localAuthentication.canCheckBiometrics;
    return isAvailable;
  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics =
        await _localAuthentication.getAvailableBiometrics();
    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = await _localAuthentication.authenticate(
      localizedReason: "Use biometric",
      useErrorDialogs: true,
      stickyAuth: true,
    );

    if (isAuthenticated) {
      print('auth okay');
      final SharedPreferences _prefs = await Constants.prefs;
      var phone = _prefs.getString('phone')!;
      var password = _prefs.getString('password');
      SignIn _signIn =
          SignIn(mobilenumber: phone, password: password, email: '');
      isSigning.value == false ? _showMaterialDialog() : SizedBox();
      signInController(_signIn).then((value) async {
        if (value.toString() == 'null') {
          Fluttertoast.showToast(msg: 'try Again');
          print('later');
        } else {
          _prefs.setBool('loggedIn', true);
          controller.checkLogin();
          controller.update();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MillionMartHome()));
        }
      });
    }
  }

  showBox(context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: MillionMartcolor1,
        title: Text(
          'ENTER URL',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
        ),
        content: Container(
          height: 150,
          child: Column(
            children: [
              // GlobalTextField(_.linkController, (value) {
              //   if (value.isEmpty) return "Enter link";
              // }, "110.93.212.132:3000",TextInputAction.done, false),

              Container(
                height: 50.0,
                child: TextField(
                  controller: url,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Enter Url",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print("111111111" + prefs.getString('url').toString());
                  if (url.text != "") {
                    prefs.setString('url', url.text);

                    Constants.setBaseUrl();

                    Get.back();
                    Get.snackbar("Success", "URL updated");
                  } else {
                    Get.back();
                    Get.snackbar("Warning", "URL remain same");
                  }
                },
                child: Text(
                  "DONE",
                  style: TextStyle(color: Colors.white, fontSize: 11.sp),
                ),
                minWidth: 274.w,
                height: 36.h,
                color: MillionMartcolor2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isIphone = false;

  isIOS() {
    if (Platform.isIOS) {
      isIphone = true;
    } else {
      isIphone = false;
    }
  }

  @override
  void initState() {
    super.initState();

    isSigning.value = false;
    if (widget.number != null) {
      print("Phone Number is " + widget.number.toString());
      mobileController.text = widget.number.toString();
    }
    lockCheck();
    fingerprintCheck();
    checkSdk();
    isIOS();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => lockCheck());

    //  ----------- otp autofill code-------
    OTPInteractor.getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));
    passwordController = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          // SampleStrategy(),
        ],
      );
  }

  offlineTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lock", '${DateTime.now()}');
    print(prefs.getString('lock'));
    isLocked = true;
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LockScreen()),
    //     (Route<dynamic> route) => false);
  }

  @override
  Future<void> dispose() async {
    // await passwordController.stopListen();
    timer?.cancel();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          } // currentFocus.dispose();
        },
        child: networkController.networkStatus.value == true
            ? Scaffold(
                // resizeToAvoidBottomInset: true,
                // backgroundColor: Colors.white,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 30.0, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  // Future.delayed(Duration(milliseconds: 000)).then((_)
                                  {
                                    homeController.isLoading.value = true;
                                    homeController.getCartCount();
                                    homeController.carouselController();
                                    homeController.fetchProducts();
                                    homeController.checkLogin();
                                    homeController.isLoading.value = false;
                                    controller.update();
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             MillionMartHome()));
                                    Get.offAll(()=>MillionMartHome());
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: secondaryColor),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                      'skip'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                            color: secondaryColor,
                                            // decoration: TextDecoration.underline),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            showBox(context);
                          },
                          child: Container(
                            child: Center(
                              child: new Image.asset(
                                'assets/image/micon.png',
                                width: 80.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        ScreenTypeLayout(
                          mobile: Form(
                            key: _formkey,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                decoration: back(),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    welcomeMillionMartTxt(),
                                    eCommerceforBusinessTxt(),
                                    // setCountryCode(),
                                    setMobileNo(),
                                    setPass(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        showPass(),
                                        Spacer(),
                                        forgetPass(),
                                      ],
                                    ),
                                    loginBtn(),
                                    _needHelp(),
                                    _socialMedia(),
                                    accSignup(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : NoInternetScreen(),
      );
    });
  }

  Future<void> validatanmation() async {
    await buttonController.reverse();
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MillionMartHome()));
    });
  }

  bool validateAndSave() {
    return true;
  }

  var sdkInt = 21;

  checkSdk() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    sdkInt = androidInfo.version.sdkInt;
    print(sdkInt);
  }

  iconHere() {
    return InkWell(
      onTap: () {
        if (Platform.isAndroid) {
          if (sdkInt >= 28) {
            authenticate();
          } else {
            Fluttertoast.showToast(
                msg: 'Your device not support this feature.');
          }
        } else {
          // authenticate();
          initializeFaceRecognition();
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.fingerprint),
        ),
      ),
    );
  }

  _socialMedia() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Row(
            children: [
              Expanded(
                  child: Divider(
                thickness: 1.0,
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'sign_in'.tr,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emailCheck.contains('email') ? Container() : iconHere(),
              SizedBox(
                width: 8.0,
              ),
              isIphone == true
                  ? InkWell(
                      onTap: () {
                        signInWithApple();
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icon/apple.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: 8.0,
              ),
              InkWell(
                onTap: () {
                  signIn(context);
                  isSigning.value == false ? _showMaterialDialog() : SizedBox();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icon/google.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              InkWell(
                onTap: () {
                  isSigning.value = false;
                  signInWithFacebook();
                  isSigning.value == false ? _showMaterialDialog() : SizedBox();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icon/facebook.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 8.0,
              // ),
              // InkWell(
              //   onTap: () {
              //     // _loginTwitter();
              //   },
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Image.asset(
              //         'assets/icon/twitter.png',
              //         width: 24,
              //         height: 24,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  back() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  welcomeMillionMartTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
        child: Align(
          alignment: Alignment.center,
          child: new Text(
            'welcome'.tr,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Color(0xff0b3c68), fontWeight: FontWeight.bold),
          ),
        ));
  }

  eCommerceforBusinessTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
        child: Align(
          alignment: Alignment.center,
          child: new Text(
            "subtitle".tr,
            // 'the_eCommerce'.tr,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: subtitleColor),
          ),
        ));
  }

  showPass() {
    return Padding(
      padding: EdgeInsets.only(
        left: 18.0,
        right: 0.0,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
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
                  .copyWith(color: lightblack2, fontSize: 11.sp))
        ],
      ),
    );
  }

  setMobileNo() {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.phone,
            controller: mobileController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            onSaved: (String? value) {
              mobileno = value!;
              mobile = mobileno;
              print('Mobile no:$mobile');
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.call_outlined,
                ),
                // errorText: '',
                hintText: 'mobile_number'.tr,
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40, maxHeight: 20),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0))),
          ),
        ),
      ],
    );
    // );
  }

  setPass() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: Stack(alignment: Alignment.centerRight, children: [
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: !_showPassword,
          controller: passwordController,
          onSaved: (String? value) {
            password = value!;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: 'password'.tr,
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
          ),
        ),
        // VerticalDivider(
        //     // thickness: 2.0,
        //     // width: 1.0,
        //     ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 4),
                width: 1.0,
                height: 30.0,
                color: secondaryColor,
              ),
              // TextButton(
              //   onPressed: () {
              //     if (mobileController.text.isEmpty) {
              //       Get.snackbar("Warning", "Fill all the fields.",
              //           backgroundColor: Colors.red, colorText: Colors.white);
              //     } else if (mobileController.text.isNotEmpty) {
              //       passwordController.clear();
              //       ForgotController.SendForgotPassword(mobileController.text);
              //       startTimer();
              //       // OtpController.sendOtp(mobileController.text);
              //       // Navigator.push(
              //       //     context,
              //       //     MaterialPageRoute(
              //       //         builder: (context) =>
              //       //             MillionMartMobailVerification()));
              //     }
              //
              //     // Navigator.push(context, MaterialPageRoute(builder:(context)=> MillionMartMobailVerification()));
              //   },
              //   style: ButtonStyle(
              //     splashFactory: InkSplash.splashFactory,
              //   ),
              //   child:
              start == 60 || start == 0
                  ? TextButton(
                      onPressed: () {
                        if (mobileController.text.isEmpty) {
                          Get.snackbar(
                            "error".tr,
                            "fullFields".tr,
                            backgroundColor: notificationBackground,
                            colorText: notificationTextColor,
                          );
                        } else if (mobileController.text.isNotEmpty) {
                          passwordController.clear();
                          ForgotController.SendForgotPassword(
                              mobileController.text);
                          if (start == 0) {
                            start = 60;
                            startTimer();
                          } else {
                            start = 60;
                            startTimer();
                          }
                          // OtpController.sendOtp(mobileController.text);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             MillionMartMobailVerification()));
                        }

                        // Navigator.push(context, MaterialPageRoute(builder:(context)=> MillionMartMobailVerification()));
                      },
                      child: Text(
                        start == 0 ? "RESEND OTP" : 'send_otp'.tr,
                        style: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    )
                  //   : start == 0
                  //       ? TextButton(
                  // onPressed: () {
                  //   if (mobileController.text.isEmpty) {
                  //     Get.snackbar("Warning", "Fill all the fields.",
                  //         backgroundColor: Colors.red, colorText: Colors.white);
                  //   } else if (mobileController.text.isNotEmpty) {
                  //     passwordController.clear();
                  //     ForgotController.SendForgotPassword(mobileController.text);
                  //     startTimer();
                  //     // OtpController.sendOtp(mobileController.text);
                  //     // Navigator.push(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //         builder: (context) =>
                  //     //             MillionMartMobailVerification()));
                  //   }
                  //
                  //   // Navigator.push(context, MaterialPageRoute(builder:(context)=> MillionMartMobailVerification()));
                  // },
                  //         child: Text(
                  //             'RESEND OTP',
                  //             style: TextStyle(
                  //               color: Color(0xffF68628),
                  //             ),
                  //           ),
                  //       )
                  :
                  // passwordController.text.isNotEmpty
                  //         ? TextButton(
                  //             onPressed: () {
                  //               if (mobileController.text.isEmpty) {
                  //                 Get.snackbar("error".tr, "fullFields".tr,
                  //                     backgroundColor: notificationBackground,
                  //                     colorText: Colors.white);
                  //               } else if (mobileController.text.isNotEmpty) {
                  //                 passwordController.clear();
                  //                 ForgotController.SendForgotPassword(
                  //                     mobileController.text);
                  //                 if (start == 0) {
                  //                   start = 60;
                  //                   startTimer();
                  //                 } else {
                  //                   start = 60;
                  //                   startTimer();
                  //                 }
                  //               }
                  //               // if (mobileController.text.isEmpty) {
                  //               //   Get.snackbar("error".tr, "fullFields".tr,
                  //               //       backgroundColor: notificationBackground,
                  //               //       colorText: Colors.white);
                  //               // } else if (mobileController.text.isNotEmpty) {
                  //               //   passwordController.clear();
                  //               //   ForgotController.SendForgotPassword(
                  //               //       mobileController.text);
                  //               //   startTimer();
                  //               //   // OtpController.sendOtp(mobileController.text);
                  //               //   // Navigator.push(
                  //               //   //     context,
                  //               //   //     MaterialPageRoute(
                  //               //   //         builder: (context) =>
                  //               //   //             MillionMartMobailVerification()));
                  //               // }
                  //
                  //               // Navigator.push(context, MaterialPageRoute(builder:(context)=> MillionMartMobailVerification()));
                  //             },
                  //             child: Text(
                  //               'SEND OTP',
                  //               style: TextStyle(
                  //                 color: secondaryColor,
                  //               ),
                  //             ),
                  //           )
                  //         :
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        '$start sec',
                        style: TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ),
            ],
          ),
        )
      ]),
    );
  }

  forgetPass() {
    return Padding(
        padding:
            EdgeInsets.only(bottom: 10.0, left: 10.0, right: 30.0, top: 10.0),
        child: InkWell(
          onTap: () {
            // ForgotController.SendForgotPassword(mobileController.text);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MillionMartForgotPassword()));
          },
          child: Text('forgot_password'.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: lightblack2, fontSize: 11.sp)
              // Theme.of(context)
              //     .textTheme
              //     .subtitle1!
              //     .copyWith(color: lightblack)
              ),
        ));
  }

  accSignup() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('don\'t_have'.tr + " ",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: lightblack2, fontWeight: FontWeight.normal)),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MillionMartSingUp()));
            },
            child: Text(
              'sign_up'.tr,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  loginBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBtn(
        title: 'login'.tr,
        onBtnSelected: () async {
          if (isLocked == true) {
            Fluttertoast.showToast(msg: 'Locked for 1 minute.');
            Fluttertoast.showToast(msg: 'Locked for 1 minute.');
          } else {
            if (mobileController.text.isEmpty ||
                passwordController.text.isEmpty) {
              Get.snackbar(
                "error".tr,
                "fullFields".tr,
                backgroundColor: notificationBackground,
                colorText: notificationTextColor,
              );
            } else {
              if (mobileController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                Get.snackbar(
                  "error".tr,
                  "fullFields".tr,
                  backgroundColor: notificationBackground,
                  colorText: notificationTextColor,
                );
              } else {
                print(mobileController.text);
                print(passwordController.text);
                // validateAndSubmit();
                SignIn _signIn = SignIn(
                    mobilenumber: mobileController.text,
                    password: passwordController.text,
                    email: '');
                isSigning.value == false ? _showMaterialDialog() : SizedBox();
                signInController(_signIn).then((value) async {
                  print(value);
                  if (value.toString() == 'null') {
                    if (count > 4) {
                      print("Locked");
                      offlineTime();
                      setState(() {});
                    } else {
                      count++;
                      isSigning.value = true;
                      Get.snackbar(
                        "error".tr,
                        "wrong".tr,
                        backgroundColor: notificationBackground,
                        colorText: notificationTextColor,
                      );
                    }
                  } else {
                    print('check this' + value.toString());
                    var id = value['id'];
                    var name = value['name'];
                    var phone = value['phone'];
                    var email = value['email'];
                    final SharedPreferences _prefs = await Constants.prefs;
                    _prefs.setBool('loggedIn', true);
                    _prefs.setString('id', id.toString());
                    _prefs.setString('name', name);
                    _prefs.setString('phone', phone);
                    _prefs.setString('email', email);
                    _prefs.setString('password', passwordController.text);
                    Constants.userID = _prefs.getString('id');
                    print("User Id is added : " + Constants.userID.toString());
                    var url = Constants.baseUrl;
                    //Todo
                    var res = await http
                        .post(Uri.parse(url + '/get-device-token'), body: {
                      "user_id": Constants.userID.toString(),
                      "device_token": Constants.token,
                    });
                    print(res);
                    controller.checkLogin();
                    controller.update();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MillionMartHome(),
                        ));
                  }
                });
              }
            }
          }
        },
      ),
    );
  }

  Future<void> getUserID() async {
    final SharedPreferences _prefs = await Constants.prefs;
    Constants.userID = _prefs.getString('id')!;
    Constants.isLoggedInCheck = _prefs.getBool('loggedIn');
    print("User ID is " + Constants.userID.toString());
  }

  _needHelp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 34.0, top: 0.0),
          child: TextButton(
            onPressed: () {
              showWillPopMessage(context);
              // showDialog(
              //     context: context,
              //     builder: (context) => manaGerDialog(),
              //     barrierDismissible: true);
            },
            child: Text(
              'need_help'.tr,
              style: TextStyle(
                color: primaryColor,
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future signIn(BuildContext context) async {
    User? user = await Authentication.signInWithGoogle(context: context);
    print("Login data " + user.toString());
    print(user.runtimeType);
    print("User iD is " + user!.uid);
    print("User iD is " + {user.displayName}.toString());
    // print("User iD is " +user!.email);
    SocialLogins _googleLogin = SocialLogins(
        name: user.displayName, email: user.email, token: user.uid);

    socialLoginsController(_googleLogin);
    Timer(Duration(seconds: 4), () async {
      final SharedPreferences _prefs = await Constants.prefs;
      _prefs.setBool('loggedIn', true);
      // _prefs.setString('id', user.uid.toString());
      _prefs.setString('name', user.displayName!);
      _prefs.setString('email', user.email!);
      Constants.userID = _prefs.getString('id');
      print("User Id is added : " + Constants.userID.toString());
      var url = Constants.baseUrl;
      //Todo
      var res = await http.post(Uri.parse(url + '/get-device-token'), body: {
        "user_id": user.uid.toString(),
        "device_token": Constants.token,
      });
      print(res);

      controller.checkLogin();
      controller.update();

      if (socialLogin.value) {
        Get.offAll(() => MillionMartHome());
      }
      // ? Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(
      //     builder: (context) => MillionMartHomeTab()))
      else {
        isSigning.value = true;
        Fluttertoast.showToast(msg: 'Try Again');
      }
    });
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      validatanmation();
    }
  }

  signInWithApple() async {
    print('Apple Sign In Method');
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential.email);
    print(credential);
    print(credential.givenName);
    print(credential.userIdentifier);
    if (credential.userIdentifier!.isNotEmpty) {
      SocialLogins _socialLogins = SocialLogins(
          token: credential.userIdentifier,
          email: credential.email ?? "abc@gmail.com",
          name: credential.givenName ?? "Username");
      final SharedPreferences _prefs = await Constants.prefs;
      _prefs.setBool('loggedIn', true);
      // _prefs.setString('id', credential.userIdentifier.toString());
      _prefs.setString('name', credential.givenName ?? "Username");
      _prefs.setString('email', credential.email ?? "abc@gmail.com");
      Constants.userID = _prefs.getString('id');
      print("User Id is added : " + Constants.userID.toString());
      var url = Constants.baseUrl;
      //Todo
      var res = await http.post(Uri.parse(url + '/get-device-token'), body: {
        "user_id": credential.userIdentifier.toString(),
        "device_token": Constants.token,
      });
      print(res);
      socialLoginsController(_socialLogins);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MillionMartHome()));
    } else {
      Fluttertoast.showToast(msg: 'There\'s an error logging you in.');
    }
  }

  signInWithFacebook() async {
    print('Facebook Sign In Method');
    final result = await FacebookAuth.i.login(
      permissions: [
        'email',
        'public_profile',
        'user_birthday',
        'user_gender',
        'user_link'
      ],
    );
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200),birthday,gender,link",
      );
      SocialLogins _socialLogins = SocialLogins(
          token: userData['id'],
          email: userData['email'] ?? "abc@gmail.com",
          name: userData['name']);
      socialLoginsController(_socialLogins);
      print(userData);
      final SharedPreferences _prefs = await Constants.prefs;
      _prefs.setBool('loggedIn', true);
      _prefs.setString('id', userData['id'].toString());
      _prefs.setString('name', userData['name']);
      _prefs.setString('email', userData['email'] ?? "abc@gmail.com");
      Constants.userID = _prefs.getString('id');
      print("User Id is added : " + Constants.userID.toString());
      var url = Constants.baseUrl;
      //Todo
      var res = await http.post(Uri.parse(url + '/get-device-token'), body: {
        "user_id": userData['id'].toString(),
        "device_token": Constants.token,
      });
      print(res);
      controller.checkLogin();
      controller.update();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MillionMartHome()));
      // setState(() {});
    } else {
      isSigning.value = true;
      Fluttertoast.showToast(msg: 'Try Again');
    }
  }

  void _showMaterialDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            // backgroundColor: ,
            // title: Text('Material Dialog'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Loading")
              ],
            ),

            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: primaryColor, shape: StadiumBorder()),
                  child: Text(
                    "close".tr,
                    style: TextStyle(
                        // color: Color(0xffF68628),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    isSigning.value = true;
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}

showWillPopMessage(context) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Column(
          children: [
            GestureDetector(
              onTap: () {
                callNumber();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Call", style: Theme.of(context).textTheme.subtitle1!),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      "assets/callCus.png",
                      height: 24,
                      width: 24,
                    ),
                  )
                  // Icon(Icons.call)
                ],
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                _whatsAppNumber();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Whatsapp", style: Theme.of(context).textTheme.subtitle1!
                      // .
                      // copyWith(color: lightblack),
                      ),
                  Image.asset(
                    "assets/icon/whatsapp-new.png",
                    height: 34,
                    width: 34,
                  ),
                  // ImageIcon(
                  //   AssetImage("assets/icon/whatsapp-new.png"),
                  //   size: 24,
                  //   // color: ,
                  // ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor, shape: StadiumBorder()),
                child: Text(
                  "close".tr,
                  style: TextStyle(
                      // color: Color(0xffF68628),
                      ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      );
    },
  );
}

Contactus contactus = Get.find<Contactus>();

callNumber() async {
  var number = "+${contactus.no}";
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  print(res);
}

_whatsAppNumber() async {
  var whatsapp = "+${contactus.no}";
  var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  if (Platform.isIOS) {
    if (await canLaunch(whatappURL_ios)) {
      await launch(whatappURL_ios, forceSafariVC: false);
    } else {
      print("No Whatsapp installed.");
    }
  } else {
    await launch("https://wa.me/+$whatsapp/?text=${Uri.parse("")}");
  }
}
