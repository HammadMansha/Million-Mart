import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/productDetailController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/MillionMartQ&AScreen.dart';
import 'package:resize/resize.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  @override
  ProductController _dataController = Get.find<ProductController>();
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _dataController.getQuesAns.length==0?Text("No Questions Asked"):
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index){
          return ExpansionTile(
            backgroundColor: Colors.black12,
            title: Text(
              _dataController.getQuesAns[index]['question'].toString(),
            ),
            children: [
              Text(_dataController.getQuesAns[index]['answer'].toString(),),
            ],
          );
        },
        itemCount: _dataController.getQuesAns.length,),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300.w,
              height: 30.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF68628),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(8)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionAnswerScreen(),
                    ),
                  );
                },
                child: Text(
                  'Ask Question?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
