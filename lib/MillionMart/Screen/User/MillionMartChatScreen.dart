import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/NetworkController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/chatController.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/NoInternet.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/ProductDetail/fullviewImage.dart';
import 'package:millionmart_cleaned/MillionMart/Screen/User/fullpdfviewer.dart';
import 'package:millionmart_cleaned/MillionMart/widget/audiocontroll.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkController networkController = Get.put(NetworkController());
    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (_) {
          return Obx(() {
            return networkController.networkStatus.value == true
                ? Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                      ),
                      title: Text(
                        "${_.username}",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                      backgroundColor: Color(0xFFAED0F3),
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Color(0xFF0A3966)),
                      elevation: 5,
                    ),
                    body: bodyData(_, context),
                  )
                : NoInternetScreen();
          });
        });
  }

  Widget bodyData(ChatController _, BuildContext context) {
    return _.isLoading
        ? Center(
            child: Image.asset(
              'assets/icon/mmgif.gif',
              height: 50,
              width: 50,
            ),
          )
        : Column(
            children: [
              // ControlButtons(_.player),
              Expanded(child: chatBox(_)),
              sendMessageBox(_, context)
            ],
          );
  }

  Widget chatBox(ChatController _) {
    return ListView.builder(
      itemCount: _.messagelist.length,
      reverse: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      itemBuilder: (context, index) {
        print("Voice type are" + _.messagelist[index]['message']);

        return _.messagelist[index]['type'] == "text"
            ? Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment:
                      (_.messagelist[index]['user_role'].toString() == "user"
                          ? Alignment.topRight
                          : Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_.messagelist[index]['user_role'].toString() ==
                              "user"
                          ? Colors.indigo
                          : Colors.deepOrangeAccent),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "${_.messagelist[index]['message']}",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              )
            : _.messagelist[index]['type'] == "audio"
                ? Container(
                    alignment:
                        (_.messagelist[index]['user_role'].toString() == "user"
                            ? Alignment.topRight
                            : Alignment.topLeft),
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MillionMartcolor2,

                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: Icon(_.isplaying == index? Icons.stop : Icons.play_arrow , color: Colors.white,),
                              onPressed: () {
                                _.audio.play(_.messagelist[index]['message']);
                               _.isplaying = index;
                                _.update();
                                // _.isPlaying = !_.isPlaying;
                                // _.update();
                                // if(_.isPlaying == true)
                                //   {
                                //     _.audio.play(_.messagelist[index]['message']);
                                //     _.audio.onDurationChanged.listen((Duration duration) {
                                //       _.duration = duration;
                                //       _.update();
                                //     });
                                //
                                //     _.audio.onAudioPositionChanged
                                //         .listen((Duration duration) {
                                //       _.position = duration;
                                //       _.update();
                                //     });
                                //   }
                                // else
                                //   {
                                //     _.audio.stop();
                                //   }
                              }),
                          // Container(
                          //   width: Get.width / 2.8,
                          //   child: Slider.adaptive(
                          //     activeColor: Colors.white,
                          //     inactiveColor: Colors.white,
                          //     onChanged: (double value) {
                          //       _.audio.seek(Duration(seconds: value.toInt()));
                          //     },
                          //     min: 0.0,
                          //     max: _.duration.inSeconds.toDouble(),
                          //     value: _.position.inSeconds.toDouble(),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // child: AudioPlayerMessage(
                    //   source: AudioSource.uri(
                    //       Uri.parse(_.messagelist[index]['message'])),
                    //   // id: "${_.messagelist[index]['message']}",
                    // ),
                  ).marginOnly(bottom: 4.0,right: 7.0,left: 7.0)
                : _.messagelist[index]['type'] == "pdf"
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        alignment:
                            (_.messagelist[index]['user_role'].toString() ==
                                    "user"
                                ? Alignment.topRight
                                : Alignment.topLeft),
                        height: Get.height / 3.5,
                        width: Get.width / 2.5,
                        child: Stack(
                          children: [
                            Container(
                              height: Get.height / 3.5,
                              width: Get.width / 2.5,
                              child: SfPdfViewer.network(
                                _.messagelist[index]['message'],
                              ),
                            ),
                            Container(
                              height: Get.height / 3.5,
                              width: Get.width / 2.5,
                              color: Colors.black12,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    Get.to(() => PdfViewer(
                                          url: _.messagelist[index]['message'],
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    size: 30.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Get.to(
                              () => FullScreenView(
                                    url: _.messagelist[index]['message']
                                        .toString(),
                                  ),
                              arguments:
                                  _.messagelist[index]['message'].toString());
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          alignment:
                              (_.messagelist[index]['user_role'].toString() ==
                                      "user"
                                  ? Alignment.topRight
                                  : Alignment.topLeft),
                          height: Get.height / 3.5,
                          width: Get.width / 2.5,
                          child: Align(
                            alignment:
                                (_.messagelist[index]['user_role'].toString() ==
                                        "user"
                                    ? Alignment.topRight
                                    : Alignment.topLeft),
                            child: CachedNetworkImage(
                              imageUrl: _.messagelist[index]['message'],
                              placeholder: (ctx, url) => Center(
                                child: Lottie.asset(
                                    'assets/svgs/image_loading.json'),
                              ),
                              errorWidget: (ctx, url, e) => Center(
                                child: Lottie.asset(
                                    'assets/svgs/image_not_found.json'),
                              ),
                              height: Get.height / 3.5,
                              width: Get.width / 2.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
      },
    );
  }

  Widget sendMessageBox(ChatController _, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              final action = CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          "Photo",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Get.back();
                      final action = CupertinoActionSheet(
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera,
                                  color: Colors.amber,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            isDefaultAction: true,
                            onPressed: () {
                              _.uploadImage();
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.indigo.shade700,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            isDestructiveAction: true,
                            onPressed: () {
                              _.uploadImageByCamera();
                            },
                          )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      );
                      showCupertinoModalPopup(
                          context: context, builder: (context) => action);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Row(
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          color: Colors.indigo.shade700,
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          "Documents",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    isDestructiveAction: true,
                    onPressed: () {
                      _.uploadFile();
                    },
                  )
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              );
              showCupertinoModalPopup(
                  context: context, builder: (context) => action);
              // showAttachmentBox(_);
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.add,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              autocorrect: true,
              controller: _.message,
              decoration: InputDecoration(
                hintText: "Type here",
                contentPadding: EdgeInsets.all(10.0),
                hintStyle: TextStyle(color: Colors.black),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  // borderSide: new BorderSide(),
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () async {
              // _.recorderProcessing = true;
              // _.update();
              // _.recorder.toggleRecording().then((value){
              //   _.recorderProcessing = false;
              //   _.update();
              // });
              await _.onRecordButtonPressed();
              _.update();
            },
            child: Icon(
              _.recordIcon,
              color: Colors.black87,
              size: 18,
            ),
            //   _.recorderProcessing
            //       ? Icons.cloud_download_outlined
            //       : _.recorder.isRecording
            //       ? Icons.stop_circle_sharp
            //       : Icons.mic_none,
            //   color: Colors.black87,
            //   size: 18,
            // ),
            backgroundColor: Colors.grey[200],
            elevation: 0,
          ),
          SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            onPressed: () async {
              if (_.message.text.isEmpty) {
                Get.snackbar(
                  'error'.tr,
                  'reportData'.tr,
                  backgroundColor: notificationBackground,
                  colorText: notificationTextColor,
                );
              } else {
                await _.sendMessage();
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.black87,
              size: 18,
            ),
            backgroundColor: Colors.grey[200],
            elevation: 0,
          ),
        ],
      ),
    );
  }

  void showAttachmentBox(ChatController _) {
    Get.bottomSheet(Container(
      padding: EdgeInsets.all(10.0),
      height: 100,
      width: Get.width,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () async {
                      _.uploadImage();
                    },
                    child: commonContainer(_, Icons.image, Color(0xff1877f2))),
                GestureDetector(
                  onTap: () {
                    _.uploadFile();
                  },
                  child: commonContainer(_, Icons.document_scanner_outlined,
                      Colors.indigo.shade700),
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                      // _.uploadVideo();
                    },
                    child: commonContainer(_, Icons.cancel, Colors.amber)),
              ]),
        ],
      ),
    ));
  }

  Widget commonContainer(ChatController _, IconData icon, Color clr) {
    return Container(
      decoration: BoxDecoration(
        color: clr,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: (Get.width / 5) - 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Icon(
            icon,
            color: Colors.white,
          ).marginAll(20.0)),
        ],
      ),
    );
  }
}
