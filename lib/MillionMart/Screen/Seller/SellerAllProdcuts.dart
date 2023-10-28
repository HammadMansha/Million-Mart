import 'package:flutter/material.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/widget/DrawerSellerDashboard.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
          style: TextStyle(color: Color(0xFF0A3966)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        backgroundColor: Color(0xFFAED0F3),
      ),
      drawer: SellerDashboardDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
            ProductsTile(),
          ],
        ),
      ),
    );
  }
}

class ProductsTile extends StatefulWidget {
  const ProductsTile({Key? key}) : super(key: key);

  @override
  _ProductsTileState createState() => _ProductsTileState();
}

class _ProductsTileState extends State<ProductsTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        iconColor: primaryColor,
        textColor: primaryColor,
        collapsedIconColor: primaryColor,
        collapsedTextColor: primaryColor,
        title: Text(
          'Products Name is here',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Product ID :111111'), Text('Type of Product',overflow: TextOverflow.ellipsis,)],
        ),
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
            child: Row(
              children: [
                Text(
                  'Price   ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                ),
                Text(
                  '11111 Rs',
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
            child: Row(
              children: [
                Text(
                  'Status   ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                ),
                Text(
                  'Active',
                  style: TextStyle(color: primaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
