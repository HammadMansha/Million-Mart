
import 'dart:io';

import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SoundRecorder{

  bool isLoading = true;
  var type;
  final storageDir = getApplicationDocumentsDirectory();
  String currentRecordingId = "";

  final uuid = const Uuid();

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  bool get isRecording => _audioRecorder?.isRecording ?? false;

  void generateNewRecordingId() => (currentRecordingId = uuid.v4());


  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future<String> get currentRecordingPath async =>
      "${(await storageDir).path}/$currentRecordingId.wav";

  Future<void> init() async {
    _audioRecorder = FlutterSoundRecorder();

    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  Future<void> _record() async {
    if (!_isRecorderInitialised) return;
    generateNewRecordingId();

    await _audioRecorder!.startRecorder(toFile: await currentRecordingPath);
  }

  Future<void> _stop() async {
    if (!_isRecorderInitialised) return;

    await _audioRecorder!.stopRecorder();
    // currentRecordingPath.then((value) {
    //   storageDir.then((v) {
    //     final file = File(v.path);
    //     file.delete(recursive: true).then((z){
    //       print(z.toString());
    //       print("Storage Delete done");
    //     });
    //   });
    //   print("Path is ${value.toString()}");
    //
    // });
    // await uploadFile(currentRecordingId, await currentRecordingPath);
  }

  Future<void> toggleRecording() async =>
      await (_audioRecorder!.isStopped ? _record() : _stop());
}
