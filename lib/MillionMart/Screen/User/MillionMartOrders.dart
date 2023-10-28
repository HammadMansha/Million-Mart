import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/OrdersDetailController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartOrderHistoryDetail.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List colors = [Colors.white, Colors.blue[800]];
  bool delivered = true;
  bool processing = false;
  bool cancelled = false;
  var deliveredButtonBack = Colors.blue[800];
  var deliveredButtonText = Colors.white;
  var processingButtonBack = Colors.white;
  var processingButtonText = Colors.blue[800];
  var canceledButtonBack = Colors.white;
  var canceledButtonText = Colors.blue[800];
  var _ordersData = [].obs;

  void getOrdersData() async {
    print("Api is called ");
    loadOrders.value = true;
    _ordersData.value = await orderDetailController();
    loadOrders.value = false;
    print("Api data is " + _ordersData.toString());
  }

  @override
  void initState() {
    super.initState();
    getOrdersData();
  }

  NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return networkController.networkStatus.value == true
          ? Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text(
                  'orders'.tr,
                  style: TextStyle(color: Color(0xFF0A3966)),
                ),
                centerTitle: true,
                backgroundColor: Color(0xFFAED0F3),
                iconTheme: IconThemeData(color: Color(0xFF0A3966)),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadOrders.value == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _ordersData.isEmpty
                        ? Center(
                            child: Text('No Order in History'),
                          )
                        : Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _ordersData.length,
                                    itemBuilder: (context, index) {
                                      return deliveredContainer(index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            )
          : NoInternetScreen();
    });
  }

  Widget deliveredContainer(int index) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              "order_id".tr +
                  ": " +
                  _ordersData[index].orderNumber.toString().toUpperCase(),
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
            Text(
              _ordersData[index].createdAt.toString().split(" ")[0],
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(text: 'total_amount'.tr + ': '),
                  TextSpan(
                      text: _ordersData[index].payAmount.toString(),
                      style: TextStyle(fontSize: 15.0, color: Colors.orange)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(() => OrderProducts(),
                    arguments: _ordersData[index].orderNumber.toString());
              },
              child: Text("order_detail".tr),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0A3966),
                textStyle: TextStyle(
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: Color(0xFF0A3966),
                  ),
                ),
              ),
            ),
            Text(
              _ordersData[index].status.toString().toUpperCase(),
              style: TextStyle(fontSize: 15.0, color: Colors.green[800]),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: Colors.grey,
          height: 1,
        )
      ],
    );
  }
}
