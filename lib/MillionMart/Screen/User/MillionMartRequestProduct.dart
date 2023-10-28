import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestProduct extends StatefulWidget {
  const RequestProduct({Key? key}) : super(key: key);

  @override
  _RequestProductState createState() => _RequestProductState();
}

class _RequestProductState extends State<RequestProduct> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  TextEditingController pTitle = TextEditingController();
  TextEditingController pLink = TextEditingController();
  TextEditingController uName = TextEditingController();
  TextEditingController uNumber = TextEditingController();
  TextEditingController pDescription = TextEditingController();
  RxString selectImagePath=''.obs;

  var id;

  void getID() async {
    final SharedPreferences _prefs = await Constants.prefs;
    id = _prefs.getString('id') ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return  GestureDetector(
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
            'request_product'.tr,
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              child: Column(
                children: [
                  inputTextField("product_name", pTitle),
                  inputTextField("product_link", pLink),
                  inputTextField("your_name", uName),
                  inputTextField("mobile_number", uNumber),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: pDescription,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'description'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      // minLines: 1,//Normal textInputField will be displayed
                      maxLines:
                          7, // when user presses enter it will adapt to it
                    ),
                  ),

                  // inputTextField("Enter Detail"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        selectImage();

                      },
                      child: SizedBox(
                        height: 50,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [

                                    selectImagePath.toString()==""?
                                    Text('select_image'.tr):
                                    Text('${selectImagePath.toString()}'),

                                    Spacer(),
                                    Icon(Icons.image,size: 26),
                                  ],
                                ),
                                // if (imageFile != null) Container(
                                //   child: Image.asset(imageFile!.path.toString()),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  AppBtn(
                    title: "request_product".tr,
                    onBtnSelected: () async {
                      if (pTitle.text.isEmpty ||
                          pLink.text.isEmpty ||
                          uName.text.isEmpty ||
                          uNumber.text.isEmpty ||
                          pDescription.text.isEmpty) {
                        Get.snackbar(
                          "Warning".tr,
                          "fullFields".tr,
                          backgroundColor: notificationBackground,
                          colorText: notificationTextColor,
                        );
                      } else {
                        // print("User Id is :" + id.toString());
                        var _formData = <String, dynamic>{
                          'title': pTitle.text,
                          'link': pLink.text,
                          'customer_name': uName.text,
                          'customer_phone': uNumber.text,
                          'description': pDescription.text,
                          'image': "",
                          'user_id': id.toString(),
                        };
                        print(_formData);
                        await requestProductApi();
                        Get.back();

                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    });

}

  Future requestProductApi() async {
    var uri = Uri.parse(Constants.baseUrl + "/request-product");
    if(imageFile != null) {
      var request = http.MultipartRequest('POST', uri)
        ..fields['title'] = pTitle.text
        ..fields['link'] = pLink.text
        ..fields['customer_name'] = uName.text
        ..fields['customer_phone'] = uNumber.text
        ..fields['description'] = pDescription.text
        ..files.add(await http.MultipartFile.fromPath("image", imageFile!.path))
        ..fields['user_id'] = id.toString();

      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print('Uploaded with image!' + resBody.toString());
        Get.offAll(() => MillionMartHome());
        Get.snackbar("success".tr, "reqSucess".tr,backgroundColor: notificationBackground,
          colorText: notificationTextColor,);
      } else {
        Get.snackbar("error".tr, "try_Again".tr,backgroundColor: notificationBackground,
          colorText: notificationTextColor,);
        print(response.stream);
        throw Exception('Failed to save Data.');
      }
    }
    else{
      final response = await http.post(uri,body: {
        'title': pTitle.text,
        'link': pLink.text,
        'customer_name': uName.text,
        'customer_phone': uNumber.text,
        'description': pDescription.text,
        'image': "",
        'user_id': id.toString(),
      });
      if (response.statusCode == 200) {
        print('Uploaded!' + response.toString());
        Get.offAll(() => MillionMartHome());
        Get.snackbar("success".tr, "reqSucess".tr,backgroundColor: notificationBackground,colorText: notificationTextColor,);
      } else {
        Get.snackbar("error".tr, "try_Again".tr,backgroundColor: notificationBackground,colorText: notificationTextColor,);
        print(response.body);
        throw Exception('Failed to save Data.');
      }
    }
  }

  Future selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(
        () {
          imageFile = File(pickedFile.path);
          print("Image File " +
              imageFile.toString() +
              "Runtime Type : " +
              imageFile.runtimeType.toString());
          selectImagePath.value=imageFile.toString().split('image_picker')[1];
          print("Image name is "+selectImagePath.toString());
        },
      );
    }
  }
}

Widget inputTextField(String _label, TextEditingController _controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _controller,
      onSaved: (String? value) {
        // email = value!;
      },
      decoration: InputDecoration(
          // prefixIcon: Icon(Icons.email_outlined),
          hintText: _label.tr,
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(7.0))),
    ),
  );
}
