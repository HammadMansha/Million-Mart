import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/widget/DrawerSellerDashboard.dart';

import '../User/OrderProcessing.dart';
import '../User/OrdersPending.dart';

class SellerDashBoard extends StatefulWidget {
  const SellerDashBoard({Key? key}) : super(key: key);

  @override
  _SellerDashBoardState createState() => _SellerDashBoardState();
}

class _SellerDashBoardState extends State<SellerDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Seller Dashboard',
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        backgroundColor: Color(0xFFAED0F3),
      ),
      drawer: SellerDashboardDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardsDesign(
              color1: Color(0xFFE85A2A),
              color2: Color(0xFFED972E),
              cIcon: Icons.payments_outlined,
              title1: 'Orders Pending!',
              title2: '2',
              btn: true,
              rte: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderPenDing()));
              },
            ),
            CardsDesign(
              color1: Color(0xFF417FE0),
              color2: Color(0xFF53A5F1),
              cIcon: Icons.emoji_transportation,
              title1: 'Orders Processing!',
              title2: '2',
              btn: true,
              rte: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderProcessing(),
                  ),
                );
              },
            ),
            CardsDesign(
              color1: Color(0xFF51A89F),
              color2: Color(0xFF63C9BD),
              cIcon: Icons.where_to_vote_outlined,
              title1: 'Orders Completed!',
              title2: '2',
              btn: true,
              rte: () {},
            ),
            CardsDesign(
              color1: Color(0xFF5C4BEB),
              color2: Color(0xFF6F60EE),
              cIcon: Icons.shopping_cart_outlined,
              title1: 'Total Products!',
              title2: '2',
              btn: true,
              rte: () {},
            ),
            CardsDesign(
              color1: Color(0xFFD02934),
              color2: Color(0xFFE73C5D),
              cIcon: Icons.shopping_bag_outlined,
              title1: 'Total Item Sold!',
              title2: '2',
              btn: false,
              rte: () {},
            ),
            CardsDesign(
              color1: Color(0xFF439023),
              color2: Color(0xFF57B722),
              cIcon: Icons.account_balance_wallet,
              title1: 'Total Earning!',
              title2: '2',
              btn: false,
              rte: () {},
            ),
            // Grad_Cards(),
          ],
        ),
      ),
    );
  }
}

class CardsDesign extends StatefulWidget {
  CardsDesign(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.cIcon,
      required this.title1,
      required this.title2,
      required this.btn,
      required this.rte})
      : super(key: key);
  final Color color1;
  final Color color2;
  final IconData cIcon;
  final String title1;
  final String title2;
  final bool btn;
  final VoidCallback rte;

  @override
  _CardsDesignState createState() => _CardsDesignState();
}

class _CardsDesignState extends State<CardsDesign> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
            vertical: MediaQuery.of(context).size.height * 0.01),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width / 2.7,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(
                //   color: Colors.transparent,
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.5, 0.6),
                  // 10% of the width, so there are ten blinds.
                  colors: <Color>[
                    widget.color1,
                    widget.color2,
                  ],
                  // red to yellow
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
            ),
            widget.btn
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.title2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.left,
                          ),
                        ),
                        widget.btn
                            ? ElevatedButton(
                                onPressed: () {
                                  widget.rte();
                                },
                                child: Text('View All'),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: Colors.white,
                                  onPrimary: primaryColor,
                                ),
                              )
                            : Container(),
                        // Icon(CIcon)
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.title2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.left,
                          ),
                        ),
                        widget.btn
                            ? ElevatedButton(
                                onPressed: () {},
                                child: Text('View All'),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  primary: Colors.white,
                                  onPrimary: primaryColor,
                                ),
                              )
                            : Container(),
                        // Icon(CIcon)
                      ],
                    ),
                  ),
            Positioned(
                left: 320,
                top: 60,
                child: Icon(
                  widget.cIcon,
                  color: Colors.white,
                  size: 32,
                ))
          ],
        ),
      );
}
