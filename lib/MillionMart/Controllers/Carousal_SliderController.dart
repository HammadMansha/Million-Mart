import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/Carousal_SliderModelClass.dart';

Future<Carousal_Slider> fetch_Slider() async {
  var url = Constants.baseUrl;
  final res = await http.get(Uri.parse(url + '/getslider'));
  if (res.statusCode == 200) {
    return Carousal_Slider.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Error to Load Data');
  }
}
