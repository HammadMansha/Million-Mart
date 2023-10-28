import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:app_settings/app_settings.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/AddAddressController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/models/AddAddressModelClass.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  String? dropdownValue = 'Select Country Name';

  String Address = 'search';
  String location = 'Null, Press Button';
  Placemark place = new Placemark();
  final HomeController homeController = Get.find<HomeController>();

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppSettings.openAppSettings();

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print(Address);
  }

  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController zip = new TextEditingController();
  TextEditingController country = new TextEditingController();

  gettingAddress() async {
    Position position = await _getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    getAddressFromLatLong(position);
    address.text = "${place.street! + ", " + place.subLocality!}";
    city.text = place.locality!;
    state.text = place.administrativeArea!;
    zip.text = place.postalCode!;
    country.text = place.country!;
  }

  Widget txtfield(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 20.0,
        shadowColor: Colors.white24,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              // errorText:
              labelText: hint,
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              labelStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
              hintText: hint,
              fillColor: Colors.white,
              filled: true),
        ),
      ),
    );
  }

  getAppBar(String title, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      elevation: 5,
      backgroundColor: Color(0xFFAED0F3),
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
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
      child: SafeArea(
        child: Center(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: getAppBar("add_shipping_address".tr, context),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: 50, right: 20, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: txtfield('address'.tr, address),
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
                          onPressed: () {
                            gettingAddress();
                            setState(() {});
                            gettingAddress();
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                  txtfield('city'.tr, city),
                  txtfield('state'.tr, state),
                  txtfield('zip'.tr, zip),
                  txtfield('country'.tr, country),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     child: Material(
                  //       elevation: 20.0,
                  //       shadowColor: Colors.white24,
                  //       child: DropdownButtonFormField<String>(
                  //         decoration: InputDecoration(
                  //             labelText: 'Country',
                  //             contentPadding: new EdgeInsets.symmetric(
                  //                 vertical: 8.0.h, horizontal: 1.0.w),
                  //             labelStyle: TextStyle(color: Colors.black),
                  //             border: InputBorder.none,
                  //             hintText: 'Select Country Name',
                  //             fillColor: Colors.white,
                  //             filled: true),
                  //         // value: dropdownValue,
                  //         style: TextStyle(color: Colors.black87),
                  //         items: countries
                  //             .map<DropdownMenuItem<String>>((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value),
                  //           );
                  //         }).toList(),
                  //         onChanged: (String? newValue) {
                  //           setState(() {
                  //             dropdownValue = newValue;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 40,
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF68628),
                        //background color of button
                        // side: BorderSide(width:3, color:Colors.brown), //border width and color
                        elevation: 3,
                        //elevation of button
                        shape: StadiumBorder(),
                        //content padding inside button
                      ),
                      onPressed: () {
                        if (address.text.isEmpty ||
                            city.text.isEmpty ||
                            state.text.isEmpty ||
                            zip.text.isEmpty ||
                            country.text.isEmpty) {
                          Get.snackbar(
                            "error".tr,
                            "fullFields".tr,
                              backgroundColor: notificationBackground,colorText: notificationTextColor,
                            // backgroundColor: notificationBackground,
                          );
                        } else {
                          print("save address id is :" + homeController.userId);
                          AddAddress _currAddress = AddAddress(
                              userId: homeController.userId,
                              town: state.text,
                              country: country.text,
                              city: city.text,
                              zip: zip.text,
                              address: address.text);
                          addAddressController(_currAddress);
                        }
                      },
                      child: Text(
                        'save_address'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
