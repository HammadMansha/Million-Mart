import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  var headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'privacy_policy'.tr,
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        backgroundColor: Color(0xFFAED0F3),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Million Mart Privacy Policy",
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'This page informs you about Million Mart Privacy Policies regarding the collection, use, and disclosure of your personal data when you are using Million Mart services and the choices you have associated with your data.\nWe use your data to provide and improve the best e-commerce services. By using the services, you agree to the collection and use of information in accordance with this Policy. For any further information you can write to us at info@millionmart.com.'),
              SizedBox(
                height: 10,
              ),
              Text(
                "Information Collection and Use",
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We collect different information of yours for various purposes to provide and improve Million Mart services offered to you both as vendor and customer.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Types of Data Collected',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Personal Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'While using Million Mart services, we may ask you to provide us with certain personal identifiable information that can be used to contact or identify you (“Personal Data”). Personal identifiable information may include, but is not limited to:'),
              SizedBox(
                height: 10,
              ),
              Text("\t\t\t\t\t• First Name and Last Name"),
              Text("\t\t\t\t\t• Email Address and Phone Number"),
              Text(
                  "\t\t\t\t\t• Residential Address, State, Province, ZIP/Postal code and City"),
              Text("\t\t\t\t\t• Cookies and Usage Data"),
              SizedBox(
                height: 10,
              ),
              Text(
                'Usage Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We may also collect information on how the Service is accessed and used (“Usage Data”). This Usage Data may include information such as your computer’s Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Tracking & Cookies Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We use cookies and similar tracking technologies to track the activity on our Service and hold certain information.\nCookies are files with a small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and scripts to collect and track information and to improve and analyze our Service.\nYou can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service.'),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Examples of Cookies we use: Session Cookies; we use Session Cookies to operate our Service. Preference Cookies; we use Preference Cookies to remember your preferences and various settings. Security Cookies; we use Security Cookies for security purposes.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Use of Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Million Mart uses the collected data for various purposes:'),
              SizedBox(
                height: 10,
              ),
              Text("\t\t\t\t\t• To provide and maintain the Service"),
              Text("\t\t\t\t\t• To notify you about changes to our Service"),
              Text(
                  "\t\t\t\t\t• To allow you to participate in interactive features of our Service when you choose to do so"),
              Text("\t\t\t\t\t• To provide customer care and support"),
              Text(
                  "\t\t\t\t\t• To provide analysis or valuable information so that we can improve the Service"),
              Text("\t\t\t\t\t• To monitor the usage of the Service"),
              Text(
                  "\t\t\t\t\t• To detect, prevent and address technical issues"),
              SizedBox(
                height: 10,
              ),
              Text(
                'Transfer of Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ from those from your jurisdiction.\nIf you are located outside Pakistan and choose to provide information to us, please note that we transfer the data, including Personal Data, to Pakistan and process it there.\nYour consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.\nMillion Mart will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Disclosure of Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text('Legal Requirements'),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Million Mart may disclose your Personal Data in the good faith belief that such action is necessary to:'),
              SizedBox(
                height: 10,
              ),
              Text("\t\t\t\t\t• To comply with a legal obligation"),
              Text(
                  "\t\t\t\t\t• To protect and defend the rights or property of Million Mart"),
              Text(
                  "\t\t\t\t\t• To prevent or investigate possible wrongdoing in connection with the Service"),
              Text(
                  "\t\t\t\t\t• To protect the personal safety of users of the Service or the public"),
              Text("\t\t\t\t\t• To protect against legal liability"),
              SizedBox(
                height: 10,
              ),
              Text(
                'Security of Data',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Service Providers',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We may employ third party companies and individuals to facilitate our Service (“Service Providers”), to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.\nThese third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Links to Other Sites',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party’s site. We strongly advise you to review the Privacy Policy of every site you visit.\nWe have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Children’s Privacy',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Our Service does not address anyone under the age of 18 (“Children”).'),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your Children have provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from children without verification of parental consent, we take steps to remove that information from our servers.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Changes to This Privacy Policy',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\nWe will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the “effective date” at the top of this Privacy Policy.\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Rights',
                style: headingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'If you are concerned about your data you have the right to request access to the personal data which we may hold or process about you. You have the right to require us to correct any inaccuracies in your data free of charge. At any stage you also have the right to ask us to stop using your personal data for direct marketing purposes.'),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
