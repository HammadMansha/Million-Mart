import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/database/database.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({Key? key}) : super(key: key);

  @override
  _ComparisonScreenState createState() => _ComparisonScreenState();
}

DatabaseHelper _databaseHelp = DatabaseHelper();

class _ComparisonScreenState extends State<ComparisonScreen> {
  var _data = [].obs;

  void getCompareData() async {
    _data.value = await _databaseHelp.getCompData();
    print("SQL data is " + _data.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCompareData();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dataBase = DatabaseHelper();
    return Obx(() {
      return _data.isEmpty
          ? Scaffold(
              appBar: AppBar(
                title: Text(
                  'Compare',
                  style: TextStyle(color: Color(0xFF0A3966)),
                ),
                centerTitle: true,
                backgroundColor: Color(0xFFAED0F3),
                iconTheme: IconThemeData(color: Color(0xFF0A3966)),
              ),
              body: Center(
                child: Text("No items"),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Compare',
                  style: TextStyle(color: Color(0xFF0A3966)),
                ),
                backgroundColor: Color(0xFFAED0F3),
                iconTheme: IconThemeData(color: Color(0xFF0A3966)),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _dataBase.deleteWholeComp();
                  _data.value = [];
                },
                child: new Icon(Icons.delete),
                backgroundColor: primaryColor,
              ),
              backgroundColor: Colors.grey[100],
              body: _data.isEmpty
                  ? Text("No Items")
                  : Container(
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return _items(index, context);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return  VerticalDivider(
                              color: primaryColor,
                              thickness: 0.7,
                            );
                          },
                          itemCount: _data.length),
                    ),
            );
    });
  }

  Widget _items(int index, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _container(_data[index].name),
          ClipRect(
              child:Center(
                child: CachedNetworkImage(
                  imageUrl:
                  _data[index].image,
                  width: MediaQuery.of(context).size.width / 2.2,
                  fit: BoxFit.contain,
                  placeholder: (ctx, url) => Center(
                    child: Lottie.asset(
                        'assets/svgs/image_loading.json'),
                  ),
                  errorWidget: (ctx, url, e) => Center(
                    child: Image.asset("assets/imageNotFound.png"),
                  ),
                ),
              ),
          //     Image(
          //   image: NetworkImage(_data[index].image),
          //   width: MediaQuery.of(context).size.width / 2.2,
          //   height: MediaQuery.of(context).size.width / 2.2,
          // )
          ),
          Container(
            child: Html(data: _data[index].des),
            width: MediaQuery.of(context).size.width / 2.0,
            height: MediaQuery.of(context).size.width / 10.2,
          ),
          // _container(_data[index].des),
          _container("Rs: " + _data[index].price.toString()),
          _container(_data[index].discount.toString().split('.')[0] + " %Off"),
          ElevatedButton(onPressed: (){
           _databaseHelp.deleteComp(_data[index].name.toString());
           getCompareData();

          }, child: Text("Remove Item"),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: primaryColor,
            ),

          )
          // _container("Rating "+_data[index].rating??" "),
        ],
      ),
    );
  }

  Widget _container(String _text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.orange, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _text,
            style: TextStyle(
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
