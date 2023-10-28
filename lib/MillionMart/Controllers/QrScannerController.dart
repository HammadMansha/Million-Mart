import 'package:get/state_manager.dart';
import 'dart:async';

import 'package:barcode_scan2/barcode_scan2.dart';


class QrScannerController extends GetxController {

  // final _flashOnController = TextEditingController(text: 'Flash on');
  // final _flashOffController = TextEditingController(text: 'Flash off');
  // final _cancelController = TextEditingController(text: 'Cancel');

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  late ScanResult scanResult;

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  // QrScannerController(this.id);
  var isLoading = true.obs;
  var data1 = [].obs;
  var productList = [].obs;
  // final String  id;
  // var slg =''.obs;





  Future<void> scan() async {
    final result = await BarcodeScanner.scan(
      options: ScanOptions(
        strings: {
          'cancel': 'Cancel',
          'flash_on': 'Flash On',
          'flash_off': 'Flash off',
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      ),
    );

    print('scannnner Result String...'+result.toString());
    // on PlatformException catch (e) {
    //   setState(() {
    //     scanResult = ScanResult(
    //       type: ResultType.Error,
    //       format: BarcodeFormat.unknown,
    //       rawContent: e.code == BarcodeScanner.cameraAccessDenied
    //           ? 'The user did not grant the camera permission!'
    //           : 'Unknown error: $e',
    //     );
    //   });
    // }
  }
}







// @override
// void dispose() { // called just before the Controller is deleted from memory
//   super.dispose();
// }
