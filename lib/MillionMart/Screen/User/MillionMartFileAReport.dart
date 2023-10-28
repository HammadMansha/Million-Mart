import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ReportProdcut extends StatefulWidget {
  const ReportProdcut({Key? key}) : super(key: key);

  @override
  _ReportProdcutState createState() => _ReportProdcutState();
}

class _ReportProdcutState extends State<ReportProdcut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        backgroundColor: Color(0xFFAED0F3),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
      ),
      body: Container(
        child: Column(
          children: [
            _DropDown('Report Category'),
          ],
        ),
      ),
    );
  }
}

_DropDown(var _text) {
  return Column(
    children: [
      Text(_text),
    ],
  );
}
