import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderPenDing extends StatefulWidget {
  const OrderPenDing({Key? key}) : super(key: key);

  @override
  _OrderPenDingState createState() => _OrderPenDingState();
}

class _OrderPenDingState extends State<OrderPenDing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pending Order',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          backgroundColor: Color(0xFFAED0F3),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FittedBox(
              child: DataTable(
                decoration: BoxDecoration(border: Border.all(width: 1.0)),
                columns: [
                  DataColumn(label: Text('Customer Email')),
                  DataColumn(label: Text('Order Number')),
                  DataColumn(
                    label: Text('Total Quantity'),
                  ),
                  DataColumn(
                    label: Text('Total Cost'),
                  )
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('abc @gmail.com')),
                      DataCell(Text('123213')),
                      DataCell(Text('1')),
                      DataCell(Text('12312'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
