import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../User/MillionMartHome.dart';
import 'SellerDashBoard.dart';

class SellerPeofile extends StatefulWidget {
  bool appbar = false;
  SellerPeofile({Key? key, required this.appbar}) : super(key: key);

  @override
  _SellerPeofileState createState() => _SellerPeofileState();
}

class _SellerPeofileState extends State<SellerPeofile>
    with TickerProviderStateMixin {
  late String name, email, mobile, city, area, pincode, address, image;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late TextEditingController nameC, emailC, mobileC, pincodeC, addressC;
  bool isDateSelected = false;
  late DateTime birthDate;
  bool isSelected = false;
  bool _isNetworkAvail = true;

  @override
  void initState() {
    super.initState();
    image = "https://smartkit.wrteam.in/smartkit/images/profile2.png";
    mobileC = new TextEditingController();
    nameC = new TextEditingController();
    emailC = new TextEditingController();
    pincodeC = new TextEditingController();
    addressC = new TextEditingController();
  }

  @override
  void dispose() {
    mobileC.dispose();
    nameC.dispose();
    addressC.dispose();
    pincodeC.dispose();
    super.dispose();
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    if (_isNetworkAvail) {
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MillionMartHome()));
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  getAppBar(String title, BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SellerDashBoard()));
          }),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      centerTitle: true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }

  _showContent() {
    return ScreenTypeLayout(
      mobile: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: <Widget>[
                profileImage(),
                setUserName(),
                setEmail(),
                setMobileNo(),
                setAddress(),
                setPincode(),
                updateBtn(),
              ],
            ),
          ),
        ),
      ),
      desktop: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: <Widget>[
                  profileImage(),
                  setUserName(),
                  setEmail(),
                  setMobileNo(),
                  setAddress(),
                  setPincode(),
                  updateBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  profileImage() {
    return Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: primaryColor)),
                  child: Icon(Icons.person, size: 100)),
            ),
            Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: primaryColor,
                      size: 15,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(color: primaryColor)),
                )),
          ],
        ));
  }

  updateBtn() {
    return AppBtn(
      title: UPDATE_PROFILE_LBL,
      onBtnSelected: () {
        validateAndSubmit();
      },
    );
  }

  setUserName() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: nameC,
        style: Theme.of(this.context)
            .textTheme
            .subtitle1!
            .copyWith(color: darkgrey),
        onChanged: (v) => setState(() {
          name = v;
        }),
        onSaved: (String? value) {
          name = value!;
        },
        decoration: InputDecoration(
          hintText: NAMEHINT_LBL,
          hintStyle: Theme.of(this.context)
              .textTheme
              .subtitle1!
              .copyWith(color: darkgrey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  setMobileNo() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: mobileC,
          // readOnly: true,
          style: Theme.of(this.context)
              .textTheme
              .subtitle1!
              .copyWith(color: darkgrey),
          decoration: InputDecoration(
            hintText: MOBILEHINT_LBL,
            hintStyle: Theme.of(this.context)
                .textTheme
                .subtitle1!
                .copyWith(color: darkgrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  setEmail() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailC,
          style: Theme.of(this.context)
              .textTheme
              .subtitle1!
              .copyWith(color: darkgrey),
          onChanged: (v) => setState(() {
            email = v;
          }),
          onSaved: (String? value) {
            email = value!;
          },
          decoration: InputDecoration(
            hintText: EMAILHINT_LBL,
            hintStyle: Theme.of(this.context)
                .textTheme
                .subtitle1!
                .copyWith(color: darkgrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  setAddress() {
    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: addressC,
                style: Theme.of(this.context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: darkgrey),
                onChanged: (v) => setState(() {
                  address = v;
                }),
                onSaved: (String? value) {
                  address = value!;
                },
                decoration: InputDecoration(
                  hintText: ADDRESS_LBL,
                  hintStyle: Theme.of(this.context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: darkgrey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: white),
                  color: white),
              child: IconButton(
                icon: new Icon(Icons.my_location),
                onPressed: () async {},
              ),
            )
          ],
        ));
  }

  setPincode() {
    double width = MediaQuery.of(this.context).size.width;
    return Container(
      width: width,
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: pincodeC,
          style: Theme.of(this.context)
              .textTheme
              .subtitle1!
              .copyWith(color: darkgrey),
          onChanged: (v) => setState(() {
            pincode = v;
          }),
          onSaved: (String? value) {
            pincode = value!;
          },
          decoration: InputDecoration(
            hintText: PINCODEHINT_LBL,
            hintStyle: Theme.of(this.context)
                .textTheme
                .subtitle1!
                .copyWith(color: darkgrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  // setUserName() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
  //     child: TextFormField(
  //       keyboardType: TextInputType.text,
  //       controller: nameC,
  //       style: Theme.of(this.context)
  //           .textTheme
  //           .subtitle1
  //           .copyWith(color: darkgrey),
  //       onChanged: (v) => setState(() {
  //         name = v;
  //       }),
  //       onSaved: (String value) {
  //         name = value;
  //       },
  //       decoration: InputDecoration(
  //         hintText: NAMEHINT_LBL,
  //         hintStyle: Theme.of(this.context)
  //             .textTheme
  //             .subtitle1
  //             .copyWith(color: darkgrey),
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: new EdgeInsets.only(right: 30.0, left: 30.0),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide: BorderSide(color: Colors.white),
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SellerDashBoard(),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: lightgrey,
        appBar: AppBar(
          title: Text(
            'Seller Profile',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
        ),
        body: Center(
          child: _showContent(),
        ),
      ),
    );
  }
}
