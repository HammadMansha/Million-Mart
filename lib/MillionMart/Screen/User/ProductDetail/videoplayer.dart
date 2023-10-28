


import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/videoController.dart';

class VideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerController = Get.put(VideoPlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(),
    );
  }

  Widget bodyData()
  {
    return GetBuilder<VideoPlayerController>(
      builder: (_){
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              child: BetterPlayer(
                controller: _.betterPlayerController,
              ),
            )
          ],
        );
      },
    );

  }
}
