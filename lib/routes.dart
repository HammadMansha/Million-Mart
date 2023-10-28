import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartCart.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartChatScreen.dart';

import 'MillionMart/Screen/User/MillionMartOrders.dart';

routes() => [
      GetPage(name: "/chat", page: () => ChatScreen()),
      GetPage(name: "/cart", page: () => MillionMartCart()),
      GetPage(name: "/orders", page: () => Orders()),
    ];
