import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/models/ShippingMethodsmodel.dart';

Future<List<ShippingModel>> shippingMethodsController() async {
  var url = Constants.baseUrl;
  final response = await http.get(Uri.parse(url + '/shipping-order'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
    return shippingModelFromJson(response.body);
  } else {
    throw Exception('Error to Load Data');
  }
}

