// import 'package:flutter/material.dart';
// import 'package:millionmart/FullApp/MillionMart%20App/Helper/HappyShopColor.dart';
//
// class SellerSignIn extends StatefulWidget {
//   const SellerSignIn({Key? key}) : super(key: key);
//
//   @override
//   _SellerSignInState createState() => _SellerSignInState();
// }
//
// class _SellerSignInState extends State<SellerSignIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign In', style: TextStyle(
//           color:Color(0xFF0A3966) ,
//         ),),
//         iconTheme: IconThemeData(color: Color(0xFF0A3966)),
//         backgroundColor: Color(0xFFAED0F3),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: primary,
//                   onPrimary: Colors.white,
//                   onSurface: Color(0xFFAED0F3),
//                   padding: EdgeInsets.symmetric(horizontal: 60),
//                   shape: StadiumBorder(),
//                 ),
//                 onPressed: () {},
//                 child: Text('Sign In'),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: primary,
//                   onPrimary: Colors.white,
//                   onSurface: Color(0xFFAED0F3),
//                   padding: EdgeInsets.symmetric(horizontal: 60),
//                   shape: StadiumBorder(),
//                 ),
//                 onPressed: () {},
//                 child: Text('Sign Up'),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SignInController.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignInModelClass.dart';
import 'package:millionmart_cleaned/MillionMart/widget/ManagerDialog.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'package:millionmart_cleaned/main.dart';

import 'package:responsive_builder/responsive_builder.dart';
import '../User/MillionMartHome.dart';
import '../User/MillionMartMobailVerification.dart';
import 'SellerDashBoard.dart';
import 'SellerForgetPassword.dart';
import 'SellerSignUp.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// import 'package:flutter_twitter_login/flutter_twitter_login.dart';

class SellerLogin extends StatefulWidget {
  SellerLogin({Key? key}) : super(key: key);

  @override
  _SellerLoginState createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin>
    with TickerProviderStateMixin {
  // static final TwitterLogin twitterLogin = new TwitterLogin(
  //   consumerKey: 'kkOvaF1Mowy4JTvCxKTV5O1WF',
  //   consumerSecret: 'ZECGsI6UUDBEUVGkJe4S5vd0FGqGxC3wMJCgsXgPRfjSwRFnyH',
  // );

  late String _message;

  // static final TwitterLogin twitterLogin = new TwitterLogin(
  //   consumerKey: 'Y2MyConsumerKeyYKX',
  //   consumerSecret: 'xYXUMyConsumerSecretKeyjFAJZMyConsumerSecretKeyS3i',
  // );

  // void _loginTwitter() async {
  //   final TwitterLoginResult result = await twitterLogin.authorize();
  //   String newMessage;
  //
  //   switch (result.status) {
  //     case TwitterLoginStatus.loggedIn:
  //       newMessage = 'Logged in! username: ${result.session.username}';
  //       break;
  //     case TwitterLoginStatus.cancelledByUser:
  //       newMessage = 'Login cancelled by user.';
  //       break;
  //     case TwitterLoginStatus.error:
  //       newMessage = 'Login error: ${result.errorMessage}';
  //       break;
  //   }
  //
  //   setState(() {
  //     _message = newMessage;
  //   });
  // }

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
  final passwordController = TextEditingController();

  late Animation buttonSqueezeanimation;

  late AnimationController buttonController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  get deviceWidth => null;

  @override
  void initState() {
    super.initState();
    // buttonController = new AnimationController(
    //     duration: new Duration(milliseconds: 2000), vsync: this);

    // buttonSqueezeanimation = new Tween(
    //   begin: deviceWidth * 0.7,
    //   end: 50.0,
    // ).animate(new CurvedAnimation(
    //   parent: buttonController,
    //   curve: new Interval(
    //     0.0,
    //     0.150,
    //   ),
    // ));
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        } // currentFocus.dispose();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Seller Login',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
        ),
        // backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Container(
                height: height,
                width: width,
                // height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: new Image.asset(
                          'assets/image/micon.png',
                          width: 80.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ScreenTypeLayout(
                        mobile: Container(
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 20),
                                  child: Form(
                                    key: _formkey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Container(
                                        decoration: back(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            welcomeMillionMartTxt(),
                                            eCommerceforBusinessTxt(),
                                            // setCountryCode(),
                                            setMobileNo(),
                                            setPass(),
                                            forgetPass(),
                                            loginBtn(),
                                            _needHelp(),
                                            // _socialMedia(),
                                            accSignup(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
                child: Text('Sign in With'),
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
              InkWell(
                onTap: () {},
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
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
              SizedBox(
                width: 8.0,
              ),
              InkWell(
                onTap: () {
                  // _loginTwitter();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icon/twitter.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  back() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

  welcomeMillionMartTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: new Text(
            WELCOME_MillionMart,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Color(0xff0b3c68), fontWeight: FontWeight.bold),
          ),
        ));
  }

  eCommerceforBusinessTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: new Text(
            ECOMMERCE_APP_FOR_ALL_BUSINESS,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Color(0xffF68628)),
          ),
        ));
  }

  setMobileNo() {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: mobileController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onSaved: (String? value) {
              mobileno = value!;
              mobile = mobileno;
              print('Mobile no:$mobile');
            },
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.call_outlined,
                ),
                hintText: MOBILEHINT_LBL,
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
          obscureText: true,
          controller: passwordController,
          onSaved: (String? value) {
            password = value!;
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              hintText: PASSHINT_LBL,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 40, maxHeight: 20),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(7.0))),
        ),
        VerticalDivider(
            // thickness: 2.0,
            // width: 1.0,
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 4),
                width: 1.0,
                height: 30.0,
                color: Colors.red,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MillionMartMobailVerification()));
                  // Navigator.push(context, MaterialPageRoute(builder: MillionMartMobailVerification()),),
                },
                style: ButtonStyle(
                  splashFactory: InkSplash.splashFactory,
                ),
                child: Text(
                  'SEND OTP',
                  style: TextStyle(
                    color: Color(0xffF68628),
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
            EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SellerForgotPassword()));
              },
              child: Text(FORGOT_PASSWORD_LBL,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: lightblack)),
            ),
          ],
        ));
  }

  accSignup() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DONT_HAVE_AN_ACC,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: lightblack2, fontWeight: FontWeight.normal)),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SellerProfile()));
            },
            child: Text(
              SIGN_UP_LBL,
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
    return AppBtn(
      title: LOGIN_LBL,
      onBtnSelected: () async {
        validateAndSubmit();
        SignIn _signIn = SignIn(
            email: mobileController.text,
            password: passwordController.text,
            mobilenumber: '');
        signInController(_signIn);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => SellerDashBoard()));
      },
    );
  }

  _needHelp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 34.0, top: 0.0),
          child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => ManaGerDialog(),
                  barrierDismissible: true);
            },
            child: Text(
              'Need Help?',
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

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      validatanmation();
    }
  }
}
