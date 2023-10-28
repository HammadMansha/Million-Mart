import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'VoiceSearchController.dart';

// import 'package:speech_to_text/speech_to_text.dart';
class SpeechRecognition extends GetxController {
  var isListening = false.obs;
  var speechText = 'say_something'.tr.obs;
  var speechTextChek = ''.obs;

  stt.SpeechToText speechToText = stt.SpeechToText();

  void onInit() {
    super.onInit();
    speechToText = stt.SpeechToText();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    speechToText.stop();
    super.onClose();
  }

  void listen() async {
    if (!isListening.value) {
      bool available = await speechToText.initialize(
        onStatus: (val) => print('Status Occured $val'),
        onError: (val) => print('Error Occured $val'),
      );
      if (available) {
        isListening.value = true;
        speechToText.listen(onResult: (val) {
          speechText.value = val.recognizedWords;
          speechTextChek.value = val.recognizedWords;
          print('lkasfj;lasfjlka' + speechText.value.toString());
          if (speechText.value.isEmpty || speechText.value == "") {
            print("Not working");
          } else {
            final VoiceSearchController voiceSearchController =
                Get.put(VoiceSearchController());
            print("working");
            voiceSearchController.fetchProducts(speechText.value);
            print("Text Passed to API's" + speechText.value);
            speechToText.stop();
            // speechText.value = 'Search';
          }

          // print(speechText.value);
        });
      }
      // isListening.value = false;
      // speechToText.stop();
      // speechText.value = 'Search';
    } else {
      isListening.value = false;
      speechToText.stop();
      speechText.value = 'Search';
      print('Not working');
    }
  }
}
