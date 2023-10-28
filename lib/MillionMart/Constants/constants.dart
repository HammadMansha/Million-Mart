import 'package:millionmart_cleaned/MillionMart/ConfigFile/configFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:io';

//Config File Constants
final int loadMoreSize = configFile['constant']['loadMoreSize'];
final int maxItemsCart = configFile['constant']['maxItemsCart'];


class Constants {

  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();


  static String baseUrl = "millionmart.com/api";
  // static String baseUrl = "stag.millionmart.com";



  // static String baseUrl2 = "https://millionmart.com";


  // static String localUrl="http://192.168.100.225";
      // "https://millionmart.socialscrew.com/api";
      // "https://millionmart.com/api";
  // static String updatedBseUrl = "https://millionmart.com/api";
      // "https://millionmart.socialscrew.com/api";
  static String? userID;
  static String? userNameData;
  static String? token;
  static bool? isLoggedInCheck;
  static int apiIndex = 0;
  static var signUpCheck = false.obs;
  // static SharedPreferences onboard;
  static List<String> viewAllAPI = [baseUrl+'/bestviewall',baseUrl+'/featuredviewall',baseUrl+'/topviewall'];
  static String checkLanguage=Platform.localeName;

 static  Future<void>setBaseUrl()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Url ${prefs.getString('url').toString()}');
    prefs.getString('url').toString() == 'null'?
    baseUrl="https://"+"millionmart.com"+"/api" :
    baseUrl="https://"+prefs.getString('url').toString()+"/api"
    ;

    print("base url is updated"+baseUrl.toString());

  }

}
var loginCheck = false.obs;

String? userEmail, userPhone, userName;



Future<void> userData() async {
  final SharedPreferences _prefs = await Constants.prefs;
  userEmail = _prefs.getString('email');
  print('Profile page: $userEmail');
  userPhone = _prefs.getString('phone');
  userName = _prefs.getString('name');
  Constants.userID = _prefs.getString('id');
  Constants.userNameData = userName;
  if(_prefs.getBool('loggedIn') != null)
    {
      loginCheck.value = _prefs.getBool('loggedIn')!;
    }
  print("Logged In " + loginCheck.value.toString());
}
