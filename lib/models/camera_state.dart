import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier{
  late CameraController _controller;
  late CameraDescription _cameraDescription;
  bool _readyTakePhoto = false;
  String? errorMessage; // 오류 메시지 상태 추가

  Future<void> getReadyToTakePhoto() async {
    errorMessage = null;
    List<CameraDescription> cameras = await availableCameras();
    if(cameras.isNotEmpty){
      setCameraDescription(cameras[0]);
    } else {
      print("There is no existing Camera");
      errorMessage = "There is no existing Camera";
      _readyTakePhoto = false;
      notifyListeners();
      return;
    }

    bool init = false;
    while(!init){
      init = await initialize();
    }

    _readyTakePhoto = true;
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription){
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription, ResolutionPreset.medium);
  }

  Future<bool> initialize() async{
    try{
      await _controller.initialize();
      return true;
    }
    catch(e){
      return false;
    }
  }

  CameraController get controller => _controller;
  CameraDescription get description => _cameraDescription;
  bool get isReadyToTakePhoto => _readyTakePhoto;
}