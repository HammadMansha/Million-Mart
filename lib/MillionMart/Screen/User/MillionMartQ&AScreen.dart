import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/VoiceCommandsController.dart';
import 'package:millionmart_cleaned/MillionMart/Controllers/askQuestionController.dart';
import 'package:millionmart_cleaned/MillionMart/widget/MillionMartbtn.dart';

class QuestionAnswerScreen extends StatefulWidget {
  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  final AskQuestions askQuestions = Get.put(AskQuestions());

  bool _animate = false;
  VoiceCommandsController _voiceCommandsController =
      Get.put(VoiceCommandsController());

  initializeVoiceCommands() {
    setState(() {
      _animate = !_animate;
    });

    _voiceCommandsController.listen();
    Fluttertoast.showToast(msg: "Listening");
    Timer(
      Duration(
        seconds: 10,
      ),
      () {
        print(
            'Voice command result in UI: ${_voiceCommandsController.speechText.value}');

        askQuestions.questionController.text =
            _voiceCommandsController.speechText.value;
        print("Questions 2: ${askQuestions.questionController.text}");
        print(_voiceCommandsController.speechText.value);
        // _voiceCommandsController.speechText.value = "";
        print(_voiceCommandsController.speechText.value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: DraggableFab(
          child: AvatarGlow(
            glowColor: Colors.blue,
            duration: Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            animate: _animate,
            repeatPauseDuration: Duration(milliseconds: 100),
            endRadius: 40.0,
            child: FloatingActionButton(
              elevation: 10.0,
              tooltip: "Speak to comment.",
              backgroundColor: Color(0xFFAED0F3),
              child: Icon(
                Icons.settings_voice_rounded,
                color: Color(0xFF0A3966),
              ),
              onPressed: () async {
                askQuestions.questionController.clear();
                _voiceCommandsController.speechText.value = "";
                print("Questions: ${askQuestions.questionController.text}");
                await initializeVoiceCommands();
                setState(() {
                  _animate = !_animate;
                });
              },
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Questions',
            style: TextStyle(color: Color(0xFF0A3966)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFAED0F3),
          iconTheme: IconThemeData(color: Color(0xFF0A3966)),
        ),
        body: bodyData());
  }

  Widget bodyData() {
    return GetBuilder<AskQuestions>(
      builder: (_) {
        return _.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _.questionController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 8,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Ask your questions..",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.black54),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            // borderSide: new BorderSide(),
                          ),
                          fillColor: Colors.grey[40],
                          filled: true,
                        ),
                      ),
                    ),
                    AppBtn(
                      title: "Submit",
                      onBtnSelected: () {
                        _.askQuestion();
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
