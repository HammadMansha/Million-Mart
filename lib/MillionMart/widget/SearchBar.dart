import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/SpeechRecognitionControllerGetX.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceSearchController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/custom_search_delgates.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MMImageSearchProdcuts.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/SearchProducts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var imageSearchData = [].obs;
var isLoadingProducts = true.obs;

TextEditingController searchController = TextEditingController();

// ignore: camel_case_types
class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);
  @override
  SearchBarState createState() => SearchBarState();
}

// FocusScopeNode focusScopeNode = FocusScopeNode();
class SearchBarState extends State<SearchBar> {
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  Widget settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.mic),
                    title: new Text('Music'),
                    onTap: () => {}),
                Text('Search..')
              ],
            ),
          );
        });
    throw 'Check Later';
  }

  @override
  Widget build(BuildContext context) {
    SpeechRecognition _speechController = Get.put(SpeechRecognition());
    return Card(
      color: Colors.white,
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.grey,
      //     style:
      //   )
      //
      // ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: false,
              controller: searchController,
              focusNode: _focusNode,
              onChanged: (c) {
                _showSearch();
                searchController.clear();
                _focusNode.unfocus();
              },

              onTap:(){
                _showSearch();
                searchController.clear();
                _focusNode.unfocus();
              } ,
              autofocus: false,
              textAlign: TextAlign.justify,
              decoration: InputDecoration(
                // enabled: false,
                // fillColor: Colors.white,
                // filled: true,
                // border: OutlineInputBorder(),
                border: InputBorder.none,
                hintText: 'search'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF0A3966),
                  size: 24,
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 24),
                isDense: true,
                // suffixIcon:
                contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                // suffixIcon:
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () async {
                    _speechController.listen();
                    print('Mic Pressed');
                    showModalBottomSheet(
                      isDismissible: false,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        context: context,
                        builder: (context) => Container(
                          width: 300,
                          height: 150,
                          color: Colors.white54,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/icon/sound.gif',
                                  height: 80,
                                  width: 200,
                                ),
                                Obx(() {
                                  return Text(_speechController
                                      .speechText.value
                                      .toString());
                                })
                              ],
                            ),
                          ),
                        ));
                    Timer(Duration(seconds: 4), () {
                      String wordchek = '';
                      print('recognized words....' +
                          _speechController.speechTextChek.value.toString());
                      wordchek = _speechController.speechTextChek.value;

                      Get.delete<SpeechRecognition>();
                      refresh();
                      Navigator.pop(context);
                      if (wordchek.toString() != '') {
                        VoiceSearchController voiceSearchController =
                        Get.put(VoiceSearchController());
                        voiceSearchController.keyword = wordchek.toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchProducts()));
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: Icon(
                    Icons.camera_alt,
                    size: 24,
                    color: Color(0xFF0A3966),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future selectImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        imageFile = File(pickedFile!.path);
        print(imageFile);
      });
      if (imageFile != null) {
        print("imageSearchData");
        isLoadingProducts.value = true;
        imageSearchData.value = [];
        print("Initail Values: " +
            isLoadingProducts.toString() +
            " " +
            imageSearchData.toString());
        _upload(imageFile!);
        Get.to(() => ImageSearchProducts());
      }
    } on Exception catch (error) {
      print("Error is: $error");
      AppSettings.openAppSettings();
    }
  }

  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithSuggestionDelegate(
        onSearchChanged: _getRecentSearchesLike,
      ),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    await _saveToRecentSearches(searchText!);

    //Do something with searchText. Note: This is not a result.
    if (searchText.isNotEmpty) {
      final VoiceSearchController voiceSearchController =
          Get.put(VoiceSearchController());
      voiceSearchController.keyword = searchText.toString();
      voiceSearchController.update();
      voiceSearchController.fetchProducts(searchText.trim());
      FocusScope.of(context).requestFocus(new FocusNode());
      Get.back();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchProducts()));
      searchController.clear();
    }
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    // if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
}

Future<dynamic> _upload(file) async {
  imageSearchData.clear();
  if (file == null) return;
  String base64Image = base64Encode(file.readAsBytesSync());
  String fileName = file.path.split(".").last;

  var url = Constants.baseUrl;
  final response = await http.post(Uri.parse(url + '/image-search'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "image_search": base64Image,
        "extension": fileName,
      }));
  if (response.statusCode == 200) {
    if (response.body.contains('error')) {
      print("api reponse code  :" +
          response.statusCode.toString() +
          ":" +
          "reponse" +
          response.body.toString());
      isLoadingProducts.value = false;
      print("api reponse with error " + response.body);
      imageSearchData.value = [];
    } else {
      print("api reponse code  :" +
          response.statusCode.toString() +
          ":" +
          "reponse" +
          response.body.toString());
      imageSearchData.value = jsonDecode(response.body);
      isLoadingProducts.value = false;
      print("Api data is :" + response.body.toString());
    }
  } else {
    // isLoadingProducts.value = false;
    // imageSearchData.value = jsonDecode(response.body);
    print("api reponse code  :" +
        response.statusCode.toString() +
        ":" +
        "reponse" +
        response.body.toString());
    isLoadingProducts.value = false;
    // Exception("Api Not Hit");
    print(response.body);
    throw ('Api Not Hit');
  }
}
