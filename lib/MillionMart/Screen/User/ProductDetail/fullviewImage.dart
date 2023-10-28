

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/fullviewimageControlller.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FullViewImageController>(
        init: FullViewImageController(),
        builder: (_){
      return Obx(() {
        return _.networkController.networkStatus.value == true ? Scaffold(
          appBar: AppBar(
            title: Text(
              'Image View',
              style: TextStyle(color: Color(0xFF0A3966)),
            ),
            centerTitle: true,
            backgroundColor: Color(0xFFAED0F3),
            iconTheme: IconThemeData(color: Color(0xFF0A3966)),
          ),
          body: bodyData(_,url),
        ) : NoInternetScreen();
      });
    });
  }

  Widget bodyData(FullViewImageController _,String url)
  {
    print("image url is :"+url);
    return _.isLoading ?
    Center(
      child: Container(
        height: 50.0,
        width: 50.0,
        child: Image.asset(
          "assets/image/micon.png",
          height: 50.0,
          width: 50.0,
        ),
      ),
    ) :
    Container(
      height: Get.height,
      width: Get.width,
      color: Colors.white,
      child: InteractiveViewer(
        child: Container(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: url,
              // productController.proImgList[index].toString(),
              fit: BoxFit.contain,
              width: 1000.0,
              height: double.infinity,
              placeholder: (ctx, url) => Center(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: Image.asset(
                    "assets/image/micon.png",
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
              ),
              errorWidget: (ctx, url, e) => Center(
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  child: Image.asset(
                    "assets/image/micon.png",
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
