
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class VideoPlayerController extends GetxController {
  bool isLoading = false;
  String url = "";


  late BetterPlayerController betterPlayerController;

  RxBool startTimer = false.obs;
  RxBool showBack = false.obs;

  @override
  void onInit() {
    print(Get.arguments);
    var videoarg = Get.arguments;
    if (videoarg != null) {
      url = videoarg;
    }

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        showPlaceholderUntilPlay: true,
        aspectRatio: 16/9,
        looping: false,
        autoDispose: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
        autoPlay: true,
        eventListener: (BetterPlayerEvent e) => eveB(e),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableAudioTracks: false,
          enablePip: false,
          enableOverflowMenu: false,
          enableSkips: false,
          enableProgressBar: true,
          enableFullscreen: false,
        ),
        fit: BoxFit.cover,
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        url,
      ),
    );
    super.onInit();
  }

  @override
  void onReady() async {
    isLoading = false;
    update();
    super.onReady();
  }

  void eveB(e) {
    if (e.betterPlayerEventType == BetterPlayerEventType.play) {
      startTimer(true);
    } else if (e.betterPlayerEventType == BetterPlayerEventType.pause) {
      startTimer(false);
    }
    else if(e.betterPlayerEventType == BetterPlayerEventType.controlsVisible)
    {
      showBack(true);
    }
    else if(e.betterPlayerEventType == BetterPlayerEventType.controlsHidden)
    {
      showBack(false);
    }
  }

  @override
  onClose() {
    betterPlayerController.pause();
    super.onClose();
  }

  Future<bool> started() async {
    return true;
  }
}