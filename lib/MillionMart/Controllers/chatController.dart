import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/MillionMartColor.dart';
import 'package:millionmart_cleaned/MillionMart/Constants/constants.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/chat/newAudioFile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';


class ChatController extends GetxController {
  bool isLoading = true;
  var type;
  final storageDir = getApplicationDocumentsDirectory();
  String currentRecordingId = "";

  bool isPlaying = false;
  Duration duration = Duration();
  Duration position = Duration();

  int isplaying = -1;

  static var client = http.Client();
  final firebaseChatRoom = FirebaseFirestore.instance.collection("chatRoom");

  TextEditingController message = TextEditingController();
  // final player = AudioPlayer();
  var audio = AudioPlayer();


  String voiceLink = "";
  String voiceType = "";

  IconData recordIcon = Icons.mic_none;
  String recordText = 'Click To Start';
  RecordingState recordingState = RecordingState.UnSet;

  // Recorder properties
  late FlutterAudioRecorder2 audioRecorder;

  // PickerFiles

  XFile? xFile;
  final ImagePicker picker = ImagePicker();
  PickedFile? pickedFile;
  File? imageFile;
  File? audiofile;

  String attachedmentBase64Image = "";
  String audioBase64Image = "";

  String userId = "";
  String username = "";

  List messagelist = [];

  @override
  void onInit() {
    FlutterAudioRecorder2.hasPermissions.then((hasPermision) {
      if (hasPermision!) {
        recordingState = RecordingState.Set;
        recordIcon = Icons.mic;
        recordText = 'Record';
      }
    });
    super.onInit();
  }

  @override
  void onReady() async {
    final SharedPreferences getUid = await Constants.prefs;
    if (getUid.getString('id') != null) {
      userId = getUid.getString('id')!;
      print("User id $userId");
      username = getUid.getString('name')!;
    }
    getMessage();
    isLoading = false;
    update();
    super.onReady();
  }

  @override
  void onClose() {
    isplaying = -1;
    audio.stop();
    update();
    recordingState = RecordingState.UnSet;
    super.onClose();
  }




  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }


  Future getMessage() async {
    print("Function Call");
    Stream<QuerySnapshot> streamdata = firebaseChatRoom
        .doc("support-$userId")
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
    await streamdata.forEach((e) {
      messagelist.clear();

      for (var value in e.docs) {
        print("Check data ${value.data()}");
        messagelist.add(value.data());
      }
      update();
    }).catchError((er) {
      Get.snackbar('error'.tr, 'not_found'.tr,
          backgroundColor: notificationBackground,
      colorText: notificationTextColor);
    });
  }

  Future<void> sendMessage() async {
    await firebaseChatRoom.doc("support-$userId").collection("messages").add({
      "createdAt": Timestamp.now(),
      "message": message.text,
      "name": username,
      "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
      "type": "text",
      "user_role": "user",
      "sendBy": 19,
      // "sendBy": userId,
      "support_id": "support",
    }).then((value) {
      message.clear();
    });
  }

  uploadImage() async {
    final pickFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickFile != null) {
      String path = pickFile.path;
      String newPath = path.substring(path.length - 8);
      String ext = newPath.split(".").last;
      print(ext);

      attachedmentBase64Image = base64Encode(await pickFile.readAsBytes());
      Get.log(attachedmentBase64Image);
      await addImage(attachedmentBase64Image, ext);
    }
  }

  uploadImageByCamera() async {
    final pickFile = await picker.pickImage(source: ImageSource.camera);
    if (pickFile != null) {
      String path = pickFile.path;
      String newPath = path.substring(path.length - 8);
      String ext = newPath.split(".").last;
      print(ext);
      attachedmentBase64Image = base64Encode(await pickFile.readAsBytes());
      await addImage(attachedmentBase64Image, ext);
    }
  }

  Future<void> addImage(String attachedimage, String exe) async {
    print(exe);
    Get.back();
    isLoading = true;

    update();
    var url = Constants.baseUrl;

    var response = await client.post(Uri.parse(url + '/storechatfiles'),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode({"extension": exe, "file_base64": attachedimage}));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      var link = res['ImageAudio'];
      var type = res['type'];
      if (link.toString().isNotEmpty && type.toString().isNotEmpty) {
        await firebaseChatRoom.doc("support-$userId").collection("messages").add({
          "createdAt": Timestamp.now(),
          "message": link.toString(),
          "name": username,
          "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
          "type": type,
          "user_role": "user",
          "sendBy": 19,
          // "sendBy": userId,
          "support_id": "support",
        }).then((value) {
          isLoading = false;
          update();
          Get.snackbar('success'.tr, 'imageSuccess'.tr,backgroundColor: notificationBackground,colorText: notificationTextColor,);
          print("image send");
        });
      }
      isLoading = false;
      update();
     // print(res['ImageAudio']);
    }
    else
      {
        isLoading = false;
        update();
      }
  }

  uploadFile() async {
    final pickFile = await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickFile != null) {
      imageFile = File(pickFile.files.single.path!);

      String path = pickFile.files.single.path!;
      String newPath = path.substring(path.length - 8);
      String ext = newPath.split(".").last;
      print(ext);
      attachedmentBase64Image = base64Encode(await imageFile!.readAsBytes());
      print(attachedmentBase64Image);
      await addImage(attachedmentBase64Image, ext);
    }
  }

  Future<void> addFile(String attachedimage, String exe) async {
    Get.back();
    isLoading = true;
    update();
    if (exe == "pdf") {
      print(exe);
      var url = Constants.baseUrl;

      var response = await client.post(Uri.parse(url + '/storechatfiles'),
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          },
          body: json.encode({"extension": exe, "file_base64": attachedimage}));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        var link = res['ImageAudio'];
         type = res['type'];
        if (link.toString().isNotEmpty && type.toString().isNotEmpty) {
          await firebaseChatRoom.doc("support-$userId").collection("messages").add({
            "createdAt": Timestamp.now(),
            "message": link,
            "name": username,
            "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
            "type": type,
            "user_role": "user",
            "sendBy": 19,
            // "sendBy": userId,
            "support_id": "support",
          }).then((value) {
            isLoading = false;
            update();
            Get.snackbar('success'.tr, 'fileSuccess'.tr,backgroundColor: notificationBackground,
              colorText: notificationTextColor,);
            print("image send");
          });
        }
        else
          {
            isLoading = false;
            update();
            Get.snackbar('error'.tr, 'notSuccess'.tr,
                backgroundColor: notificationBackground,colorText: notificationTextColor,);
          }
      }
    } else {
      isLoading = false;
      update();
      Get.snackbar('error'.tr, 'errorFile'.tr,
          backgroundColor: notificationBackground,colorText: notificationTextColor,);
    }
  }

  Future<void> onRecordButtonPressed() async {
    switch (recordingState) {
      case RecordingState.Set:
        await recordVoice();
        break;

      case RecordingState.Recording:
        await stopRecording();
        recordingState = RecordingState.Stopped;
        recordIcon = Icons.mic;
        // recordIcon = Icons.fiber_manual_record;
        recordText = 'Record new one';
        break;

      case RecordingState.Stopped:
        await recordVoice();
        break;

      case RecordingState.UnSet:
        Get.snackbar('error'.tr, 'recAllow'.tr,
            backgroundColor: notificationBackground,
          colorText: notificationTextColor,);
        break;
    }
  }

  startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }
  stopRecording() async {
    await audioRecorder.stop();
    Directory appDirectory = await getApplicationDocumentsDirectory();
    appDirectory.list().listen((onData) async {
      print("Audio path ${onData.path}");
      final file = File(onData.path);
      await sendVoiceMessage(file);
    }).onDone(()async {
      final file = File(appDirectory.path);
      file.delete(recursive: true).then((value){
        print(value.toString());
        print("done");
        Get.snackbar('success'.tr, 'fileSuccess'.tr,
          backgroundColor: notificationBackground,
          colorText: notificationTextColor,);
      });
    });
    // widget.onSaved();
  }

  Future<void> sendVoiceMessage(File file) async
  {
    String audioBase64 = base64Encode(await file.readAsBytes());
    print(audioBase64Image);
    var url = "http://192.168.100.187/million_final_code/api";

    var response = await client.post(Uri.parse(Constants.baseUrl + '/storechatfiles'),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode({"file_base64": audioBase64,"extension":"wav"}));
    print(response.statusCode);
    print("Audio Response "+response.body.toString());
    if (response.statusCode == 200) {
      // Get.log(response.body.toString());
      print("Audio Response 200" + response.body.toString());
      var res = jsonDecode(response.body);
      print("Check Audio Response $res");
      voiceLink = res['ImageAudio'];
      voiceType = res['type'];
      update();
      print("Voice Link Is $voiceLink");
      await firebaseChatRoom.doc("support-$userId").collection("messages")
          .add({
        "createdAt": Timestamp.now(),
        "message": voiceLink,
        "name": url,
        "photo": "https://cdn-icons-png.flaticon.com/512/21/21104.png",
        "type": voiceType,
        "user_role": "user",
        "sendBy": "19",
        "support_id": "support",
      }).then((value) {
        print("Check value $value");
        isLoading = false;
        update();
        // final file = File(appDirectory.path);
        // file.delete(recursive: true).then((value) {
        //   print(value.toString());
        //   print("done");
        // });

        print("Audio send");

      });
    }
  }


  // Future<void> init(File file) async {
  //   print("check ${file.path}");
  //   audioBase64Image = base64Encode(await file.readAsBytes());
  //   Get.log(audioBase64Image);
  //   //audioSave();
  //   final session = await AudioSession.instance;
  //   await session.configure(AudioSessionConfiguration.speech());
  //   player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //         print('A stream error occurred: $e');
  //       });
  //
  //   try {
  //     print("File path ${file.path}");
  //     await player.setAudioSource(AudioSource.uri(Uri.file(file.path)));
  //     // await player.setAsset(file.path);
  //     // await player.setAudioSource(AudioSource.uri(Uri.parse(
  //     //     "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
  //     // audioSave();
  //   } catch (e) {
  //     print("Error loading audio source: $e");
  //   }
  // }
  // stopRecording() async {
  //   await audioRecorder.stop();
  //   Directory appDirectory = await getApplicationDocumentsDirectory();
  //   appDirectory.list().listen((onData) {
  //     print(onData.path);
  //   }).onDone(()async {
  //     final file = File(appDirectory.path);
  //     Blob blob = new Blob(await file.readAsBytes());
  //     audioSave(blob);
  //     print("api is called");
  //
  //
  //     // final file = File(appDirectory.path);
  //     // file.delete(recursive: true).then((value){
  //     //   print(value.toString());
  //     //   print("done");
  //     // });
  //   });
  //   // widget.onSaved();
  // }

  Future<void> recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await initRecorder();

      await startRecording();
      recordingState = RecordingState.Recording;
      recordIcon = Icons.stop;
      recordText = 'Recording';
    } else {
      Get.snackbar(
        'error'.tr,
        'recAllow'.tr,
        backgroundColor: notificationBackground,
        colorText: notificationTextColor,
      );
    }
  }

  initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    print("app Directory ${appDirectory.path}");
    String filePath = appDirectory.path +
        '/' + DateTime.now().millisecondsSinceEpoch.toString() +
        '.wav';
    print("File Path $filePath");
    print(filePath);
    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.WAV);
    await audioRecorder.initialized;
  }



}


enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}
