import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/HomeControllerGetx.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/contactusController.dart';
import 'package:millionmart_cleaned/routes.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:resize/resize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MillionMart/Constants/PushNotifications.dart';
import 'MillionMart/app_translations.dart';
import 'MillionMart/Screen/User/MillionMartSplash.dart';
import 'package:uni_links/uni_links.dart' as UniLink;



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkDeepLink();

  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: systemNavigationBarColor, // navigation bar color
    statusBarColor: statusBarColor,
  ));
  Constants.checkLanguage="English";
  Constants.checkLanguage = (await getLang())!;

  final bool isConnected = await InternetConnectionChecker().hasConnection;
  print("Internet Connection: " + isConnected.toString());
  print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}');
  print("current language of app is "+ Constants.checkLanguage.toString());
 await Constants.setBaseUrl();

  print("base url before main is"+Constants.baseUrl.toString());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  final Contactus contactus = Get.put(Contactus());
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    return Resize(
      builder: () {
        print("1222222"+Constants.checkLanguage);
        return OverlaySupport.global(
          child: GetMaterialApp(
            title: 'Million Mart',
            debugShowCheckedModeBanner: false,
            locale: Constants.checkLanguage=="English"?Locale('en', 'US') : Locale('ur', 'PK'),
            // getLang().toString().contains('English')?LocalizationService.locale:LocalizationService.fallbackLocale,
            fallbackLocale: LocalizationService.fallbackLocale,
            translations: LocalizationService(),
            home: ScreenTypeLayout(
              mobile:MillionMartSplash(),
            ),
            getPages: routes(),
          ),
        );
      },
    );
  }
}

Future checkDeepLink() async {
  StreamSubscription sub;
  try {
    print("checkDeepLink");
    await UniLink.getInitialLink();
    sub = UniLink.uriLinkStream.listen((Uri? uri) {
      print('uri: $uri');
      print("uri is");
      WidgetsFlutterBinding.ensureInitialized();
      runApp(MyApp());
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed

      print("onError");
    });
  } on PlatformException {
    print("PlatformException");
  } on Exception {
    print('Exception thrown');
  }
}

//Lang
Future<String?> getLang()async{
  final SharedPreferences _prefs = await Constants.prefs;
  print('Shared pref Lang ${_prefs.getString('lang').toString()}');
  if(_prefs.getString('lang').toString() != "null")
  return _prefs.getString('lang');
  else
    {
      return "English";
    }
}