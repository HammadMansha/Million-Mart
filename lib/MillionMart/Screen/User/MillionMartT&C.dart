import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MillionMartTC extends StatefulWidget {
  const MillionMartTC({Key? key}) : super(key: key);

  @override
  _MillionMartTCState createState() => _MillionMartTCState();
}

class _MillionMartTCState extends State<MillionMartTC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
          title: Text(
            "Terms & Conditions",
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Html(
              data:
                  """<h3 class="text-center mb-4" style='box-sizing: border-box; margin-top: 0px; margin-bottom: 1.5rem !important; font-weight: 700; line-height: 1.08333; font-size: 26px; color: rgb(20, 50, 80); font-family: "Open Sans", sans-serif; text-align: center !important; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;'>Terms and Conditions &ndash; (for Million Mart account)</h3>
<p style='box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-size: 16px; color: rgb(51, 51, 51); line-height: 1.625; hyphens: auto; font-family: "Open Sans", sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;'>To access and use of Services, you must register for a Million Mart account by providing your full legal name, current address, phone number, a valid email address, and any other information indicated as required. Million Mart may reject your application for an Account, or cancel an existing Account, for any reason, in our sole discretion. You must be the older of: (i) 18 years to create an account on the application.</p>
<p style='box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-size: 16px; color: rgb(51, 51, 51); line-height: 1.625; hyphens: auto; font-family: "Open Sans", sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;'>Furthermore, you are required to acknowledge that Million Mart will use the email address and the phone number you provide on opening an Account or as updated by you from time to time as the primary method for communication with you. You must monitor the primary Account email address and phone number you provide to Million Mart regularly. Your email communications with Million Mart can only be authenticated if they come from your primary Account email address.</p>
<p style='box-sizing: border-box; margin-top: 0px; margin-bottom: 1rem; font-size: 16px; color: rgb(51, 51, 51); line-height: 1.625; hyphens: auto; font-family: "Open Sans", sans-serif; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;'>You are responsible for keeping your password secure. Million Mart cannot and will not be liable for any loss or damage from your failure to maintain the security of your Account and password.</p>""",
            ),
          ),
        ));
  }
}
