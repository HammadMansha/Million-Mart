import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceCommandsController extends GetxController {
  stt.SpeechToText speechToText = stt.SpeechToText();
  var isListening = false.obs;
  var speechText = ''.obs;

  @override
  void onInit() {
    speechToText = stt.SpeechToText();
    super.onInit();
  }

  @override
  void onClose() {
    speechToText.stop();
    super.onClose();
  }

  void listen() async {
    if (!isListening.value) {
      print('Inside Listening');
      bool available = await speechToText.initialize(
        onStatus: (val) => print('Status Occured $val'),
        onError: (val) {
          print('Error Occured $val');
          Fluttertoast.showToast(msg: 'Too many attempts.');
        },
      );
      if (available) {
        print('Service initialized successfully');
        speechToText.listen(
          onResult: (value) {
            print('Listening');
            if (value.finalResult) {
              speechText.value = value.recognizedWords;
              print('Recognized Words: ${speechText.value}');
            } else {
              print('Still Listening');
            }
          },
        );
      } else {
        print('Service initialization unsuccessfull');
      }
    } else {
      print('Outside Listening');
    }
  }
}
