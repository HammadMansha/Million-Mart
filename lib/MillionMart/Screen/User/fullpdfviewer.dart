
import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  final String url;

  PdfViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "PDF Viewer",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: Color(0xFFAED0F3),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        elevation: 5,
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
