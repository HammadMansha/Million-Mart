import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';

Future<dynamic> paymentMethodsController() async {
  var url = Constants.baseUrl;
  final response = await http.get(Uri.parse(url + '/payment-methods'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print("pay methods : "+data.toString());
    return data;
  } else {
    throw Exception('Error to Load Data');
  }
}

