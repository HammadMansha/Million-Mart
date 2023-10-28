import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartString.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartHome.dart';

import 'MillionMartOrderDetails.dart';

class MillionMartTreackOrder extends StatefulWidget {
  final bool appbar;
  MillionMartTreackOrder({Key? key, required this.appbar}) : super(key: key);

  @override
  _MillionMartTreackOrderState createState() => _MillionMartTreackOrderState();
}

int offset = 0;
int total = 0;
bool isLoadingmore = true;

class _MillionMartTreackOrderState extends State<MillionMartTreackOrder>
    with TickerProviderStateMixin {
  List tempList = [];

  ScrollController controller = new ScrollController();
  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;

  @override
  void initState() {
    offset = 0;
    total = 0;
    super.initState();
  }

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  List orderList = [
    {
      'id': "0123456",
      'listStatus': "returned",
      'orderDate': "5-2-2021",
      'total': "150",
      'itemList': [
        {
          'image': "https://smartkit.wrteam.in/smartkit/images/Nikereak4.jpg",
          'name': "test",
          'qty': "2",
          'price': "75"
        }
      ]
    },
  ];
  getAppBar(String title, BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MillionMartHome(),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: widget.appbar == true
        appBar: getAppBar("Track order", context),

        // AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),
        //   title: Text(
        //           "Track order",
        //           style: TextStyle(color: Colors.white),
        //         ),
        //       )
        //     : PreferredSize(preferredSize: Size.fromHeight(0), child: AppBar()),
        body: ListView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: orderList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ORDER_ID_LBL + " : " + orderList[index]['id']),
                            Text(ORDER_DATE +
                                " : " +
                                orderList[index]['orderDate']),
                            Text(TOTAL_PRICE +
                                ":" +
                                CUR_CURRENCY +
                                " " +
                                orderList[index]['total']),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: primaryColor,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MillionMartOrderDetails()),
                            );
                          })
                    ],
                  ),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderList[index]['itemList'].length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return productItem(index, orderList[index]['itemList']);
                    },
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getPlaced("2-2-2020"),
                        getProcessed("3-2-2020", "4-2-2020"),
                        getShipped("4-2-2020", ""),
                        getDelivered("5-2-2021", ""),
                        getCanceled("5-2-2021"),
                        getReturned("6-2-2021", index),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Similar Products",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: primaryColor),
                        ),
                        Spacer(),
                        // Text('See ALL', style: Theme.of(context).textTheme.subtitle2)
                      ],
                    ),
                  ),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1 / 0.7,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return _Card(80, 50);
                      // return Container(
                      //   color: Colors.transparent,
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //
                      //       Image.asset('assets/image/micon.png',width: 120,height: 80,),
                      //       SizedBox(
                      //         height: 2.0,
                      //       ),
                      //       Text('Cat $index',style: Theme.of(context)
                      //           .textTheme
                      //           .headline6
                      //           .copyWith(color: primary),),
                      //     ],
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _Card(double h, double w) {
    return Card(
      child: Column(
        children: [
          Container(
              child: Image(
            image: AssetImage('assets/image/micon.png'),
            width: w,
            height: h,
            fit: BoxFit.fill,
          ))
          // ,Divider(thickness: 1,
          //  color: Colors.grey,)
          //  ,Container(
          //    height: double.infinity,
          //  )
          ,
          Text("Item Name")
        ],
      ),
    );
  }

  getDelivered(String dDate, String cDate) {
    return cDate == null
        ? Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Divider(
                  thickness: 2,
                  color: dDate == null ? Colors.grey : MillionMartcolor8,
                )),
                Column(
                  children: [
                    Text(
                      ORDER_DELIVERED,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        dDate == null
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: dDate == null ? Colors.grey : MillionMartcolor8,
                      ),
                    ),
                    Text(
                      dDate,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  getCanceled(String cDate) {
    return cDate != null
        ? Flexible(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                    flex: 1,
                    child: Divider(
                      thickness: 2,
                      color: Colors.red,
                    )),
                Column(
                  children: [
                    Text(
                      ORDER_CANCLED,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        Icons.radio_button_checked,
                        color: Colors.red[700],
                      ),
                    ),
                    Text(
                      cDate,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  getReturned(String rDate, int index) {
    return orderList[index]['listStatus'].contains(RETURNED)
        ? Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 1,
                    child: Divider(
                      thickness: 2,
                      color: Colors.red,
                    )),
                Column(
                  children: [
                    Text(
                      ORDER_RETURNED,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        Icons.radio_button_checked,
                        color: Colors.red[700],
                      ),
                    ),
                    Text(
                      rDate,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  getShipped(String sDate, String cDate) {
    return cDate == null
        ? Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: Divider(
                      thickness: 2,
                      color: sDate == null ? Colors.grey : MillionMartcolor8,
                    )),
                Column(
                  children: [
                    Text(
                      ORDER_SHIPPED,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        sDate == null
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: sDate == null ? Colors.grey : MillionMartcolor8,
                      ),
                    ),
                    Text(
                      sDate,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          )
        : sDate == null
            ? Container()
            : Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Divider(
                          thickness: 2,
                        )),
                    Column(
                      children: [
                        Text(
                          ORDER_SHIPPED,
                          style: TextStyle(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.radio_button_checked,
                          color: MillionMartcolor8,
                        ),
                        Text(
                          sDate,
                          style: TextStyle(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }

  getProcessed(String prDate, String cDate) {
    return cDate == null
        ? Flexible(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 1,
                    child: Divider(
                      thickness: 2,
                      color: prDate == null ? Colors.grey : MillionMartcolor8,
                    )),
                Column(
                  children: [
                    Text(
                      ORDER_PROCESSED,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Icon(
                        prDate == null
                            ? Icons.radio_button_unchecked
                            : Icons.radio_button_checked,
                        color: prDate == null ? Colors.grey : MillionMartcolor8,
                      ),
                    ),
                    Text(
                      prDate,
                      style: TextStyle(fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          )
        : prDate == null
            ? Container()
            : Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(
                        flex: 1,
                        child: Divider(
                          thickness: 2,
                          color: MillionMartcolor8,
                        )),
                    Column(
                      children: [
                        Text(
                          ORDER_PROCESSED,
                          style: TextStyle(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.radio_button_checked,
                          color: MillionMartcolor8,
                        ),
                        Text(
                          prDate,
                          style: TextStyle(fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              );
  }

  getPlaced(String pDate) {
    return Column(
      children: [
        Text(
          ORDER_NPLACED,
          style: TextStyle(fontSize: 8),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Icon(
            Icons.radio_button_checked,
            color: MillionMartcolor8,
          ),
        ),
        Text(
          pDate,
          style: TextStyle(fontSize: 8),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  productItem(int index, orderItem) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: orderItem[index]['image'],
          height: 100.0,
          width: 100.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(orderItem[index]['name']),
              Text(QUANTITY_LBL + ": " + orderItem[index]['qty']),
              Text(CUR_CURRENCY + " " + orderItem[index]['price']),
            ],
          ),
        )
      ],
    );
  }
}
