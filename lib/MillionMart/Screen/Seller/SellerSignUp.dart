import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/models/SignUpModelClass.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
// import 'package:flutter/gestures.dart';

import 'package:responsive_builder/responsive_builder.dart';

import '../User/MillionMartMobailVerification.dart';
import 'SellerSignin.dart';

class SellerProfile extends StatefulWidget {
  SellerProfile({Key? key}) : super(key: key);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile>
    with TickerProviderStateMixin {
  bool _showPassword = false;
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final ccodeController = TextEditingController();
  final passwordController = TextEditingController();
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
          context,
          MaterialPageRoute(
              builder: (context) => MillionMartMobailVerification()));
    });
  }

  bool validateAndSave() {
    return true;
  }

  @override
  void dispose() {
    buttonController.dispose();
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
          title: Text(
            'Seller SignUp',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
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
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Center(
        child: new Image.asset(
          'assets/image/micon.png',
          width: 80.0,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  registerTxt() {
    return Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: Center(
          child: new Text(USER_REGISTRATION,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: lightblack)),
        ));
  }

  setUserName() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        controller: nameController,
        onSaved: (String? value) {
          name = value!;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            hintText: NAMEHINT_LBL,
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(7.0))),
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: mobileController,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSaved: (String? value) {
          mobile = value!;
          print('Mobile no:$mobile');
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.call_outlined),
            hintText: MOBILEHINT_LBL,
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
        controller: emailController,
        onSaved: (String? value) {
          email = value!;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: EMAILHINT_LBL,
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
      padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: !this._showPassword,
            controller: passwordController,
            onSaved: (val) => password = val!,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: PASSHINT_LBL,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MillionMartMobailVerification()));
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
          Text(SHOW_PASSWORD,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: lightblack2))
        ],
      ),
    );
  }

  verifyBtn() {
    return AppBtn(
      title: VERIFY_MOBILE_NUMBER,
      onBtnSelected: () async {
        validateAndSubmit();
        Signup _signUp = Signup(
          fullname: nameController.text,
          email: emailController.text,
          mobilenumber: mobileController.text,
          password: passwordController.text,
          phonenumber: '',
        );
        // signUpController(_signUp);
        print(_signUp.fullname);
      },
    );
  }

  loginTxt() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(ALREADY_A_CUSTOMER,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: lightblack)),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SellerLogin(),
                ));
              },
              child: Text(
                LOG_IN_LBL,
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
          text: "By creating an account, you agree to\nMillion's Mart ",
          style: TextStyle(
            color: Colors.grey,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'terms',
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('Terms');
                  }),
            TextSpan(text: ' and '),
            TextSpan(
                text: 'Conditions.',
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('Conditions');
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
  }
}
