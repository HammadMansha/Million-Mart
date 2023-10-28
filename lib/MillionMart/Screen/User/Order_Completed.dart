import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/CheckoutController.dart';
import 'MillionMartHome.dart';

class order_completed extends StatefulWidget {
  const order_completed({Key? key}) : super(key: key);


  @override
  _order_completedState createState() => _order_completedState();
}

class _order_completedState extends State<order_completed> {

  CheckoutController checkoutController = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/image/yesicon.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Congratulations..!!!!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Order have been and\n is being attended to',
                textAlign: TextAlign.center,
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         // shape: CircleBorder(),
            //         primary: Color(0xFFF68628),
            //       ),
            //       child: Container(
            //         width: 90,
            //         height: 50,
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(40))),
            //         child: Text(
            //           'Track Order',
            //           style: TextStyle(fontSize: 16),
            //         ),
            //       ),
            //       onPressed: () {
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => MillionMartTreackOrder(
            //               appbar: true,
            //             ),
            //           ),
            //         );
            //       },
            //     )
            //     // ElevatedButton(onPressed: (){}, child: Text('Track Order'),
            //     //   style: ElevatedButton.styleFrom(
            //     //       shape: Radius.circular(radius),
            //     //     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            //     //   primary: Colors.deepOrangeAccent
            //     // ),
            //     // ),
            //     ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: () {
                    checkoutController.promoCodeDiscount.value = '';
                    checkoutController.discountType.value = '';
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MillionMartHome()));
                  },
                  child: Text('Continue Shoping'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
